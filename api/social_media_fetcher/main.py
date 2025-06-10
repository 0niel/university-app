"""Main FastAPI application with unified social media client architecture."""

import asyncio
from contextlib import asynccontextmanager
from typing import Any, Dict, List, Optional

import uvicorn
from fastapi import Depends, FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from loguru import logger
from src.client_factory import setup_clients
from src.config import Settings
from src.interfaces import Configuration, ServiceRegistryProtocol, SocialMediaClient
from src.media_storage import MediaStorage
from src.models import (
    AddSourceRequest,
    NewsItemResponse,
    NewsListResponse,
    SchedulerConfigRequest,
    SchedulerStatusResponse,
    SourceResponse,
    StatisticsResponse,
    UpdateSourceRequest,
)
from src.registry import service_registry
from src.scheduler import BackgroundScheduler
from src.supabase_client import SupabaseNewsClient

settings = Settings()

scheduler = None
client_factory = None


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan handler."""
    global scheduler, client_factory

    logger.info("Starting Social Media Fetcher API...")

    try:
        await setup_services()

        await service_registry.initialize_all_clients()

        scheduler_config = settings.get_scheduler_config()
        if scheduler_config.get("enabled", False):
            scheduler = service_registry.get_service("scheduler")
            if scheduler:
                await scheduler.start()
                logger.info("Background scheduler started")

        logger.info("Application startup complete")
        yield

    except Exception as e:
        logger.error(f"Failed to start application: {e}")
        raise
    finally:
        logger.info("Shutting down Social Media Fetcher API...")

        if scheduler:
            await scheduler.stop()
            logger.info("Background scheduler stopped")

        await service_registry.close_all_clients()
        logger.info("Application shutdown complete")


async def setup_services():
    """Setup all services and register them."""
    global client_factory

    if settings.supabase_configured:
        db_client = SupabaseNewsClient(settings)
        await db_client.initialize()
        service_registry.register_service("database", db_client)
        logger.info("Database client registered")
    else:
        logger.warning("Supabase not configured - database features disabled")

    media_storage = MediaStorage(settings)
    service_registry.register_service("media_storage", media_storage)
    logger.info("Media storage registered")

    client_factory = setup_clients(settings, service_registry)
    service_registry.register_service("client_factory", client_factory)

    scheduler = BackgroundScheduler(service_registry, settings)
    service_registry.register_service("scheduler", scheduler)
    logger.info("Scheduler registered")


app = FastAPI(
    title="Social Media Fetcher API",
    description="Unified API for fetching social media content from various platforms",
    version="2.0.0",
    lifespan=lifespan,
)

server_config = settings.get_server_config()
app.add_middleware(
    CORSMiddleware,
    allow_origins=server_config["allowed_origins"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


def get_database() -> SupabaseNewsClient:
    """Get database client dependency."""
    if db := service_registry.get_service("database"):
        return db
    else:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Database service not available",
        )


def get_scheduler() -> BackgroundScheduler:
    """Get scheduler dependency."""
    if scheduler := service_registry.get_service("scheduler"):
        return scheduler
    else:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Scheduler service not available",
        )


@app.get("/", response_model=Dict[str, Any])
async def root():
    """Root endpoint with API information."""
    return {
        "message": "Social Media Fetcher API",
        "version": "2.0.0",
        "status": "running",
        "available_clients": service_registry.get_available_client_types(),
        "registry_status": service_registry.get_status(),
    }


@app.get("/health", response_model=Dict[str, Any])
async def health_check():
    """Health check endpoint."""
    db = service_registry.get_service("database")
    services_status = {"database": "available" if db else "unavailable"}

    clients = service_registry.get_all_clients()
    services_status["clients"] = {
        client_type: "initialized" if client._initialized else "not_initialized"
        for client_type, client in clients.items()
    }

    scheduler = service_registry.get_service("scheduler")
    services_status["scheduler"] = "available" if scheduler else "unavailable"

    return {
        "status": "healthy",
        "services": services_status,
        "registry": service_registry.get_status(),
    }


@app.post("/sources", response_model=SourceResponse)
async def add_source(
    request: AddSourceRequest,
    db: SupabaseNewsClient = Depends(get_database),
):
    """Add a new social media source."""
    try:
        client = service_registry.get_client(request.source_type)
        if client and client._initialized:
            is_valid = await client.validate_source(request.source_id)
            if not is_valid:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"Source {request.source_id} is not accessible",
                )

        source = await db.add_source(
            source_type=request.source_type,
            source_id=request.source_id,
            source_name=request.source_name,
            category=request.category,
            description=request.description,
            is_active=request.is_active,
        )

        return SourceResponse(**source)

    except Exception as e:
        logger.error(f"Error adding source: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e),
        ) from e


@app.get("/sources", response_model=List[SourceResponse])
async def get_sources(
    source_type: Optional[str] = None,
    category: Optional[str] = None,
    active_only: bool = True,
    db: SupabaseNewsClient = Depends(get_database),
):
    """Get all sources with optional filtering."""
    try:
        sources = await db.get_sources(
            source_type=source_type,
            category=category,
            active_only=active_only,
        )
        return [SourceResponse(**source) for source in sources]

    except Exception as e:
        logger.error(f"Error getting sources: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e),
        ) from e


@app.put("/sources/{source_id}", response_model=SourceResponse)
async def update_source(
    source_id: int,
    request: UpdateSourceRequest,
    db: SupabaseNewsClient = Depends(get_database),
):
    """Update a source."""
    try:
        source = await db.update_source(source_id, **request.dict(exclude_unset=True))
        return SourceResponse(**source)

    except Exception as e:
        logger.error(f"Error updating source: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e),
        ) from e


@app.delete("/sources/{source_id}")
async def delete_source(
    source_id: int,
    db: SupabaseNewsClient = Depends(get_database),
):
    """Delete a source."""
    try:
        await db.delete_source(source_id)
        return {"message": "Source deleted successfully"}

    except Exception as e:
        logger.error(f"Error deleting source: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e),
        ) from e


@app.get("/news", response_model=NewsListResponse)
async def get_news(
    limit: int = 20,
    offset: int = 0,
    source_type: Optional[str] = None,
    source_id: Optional[str] = None,
    category: Optional[str] = None,
    db: SupabaseNewsClient = Depends(get_database),
):
    """Get latest news from cached data."""
    try:
        news_items = await db.get_latest_news(
            limit=limit,
            offset=offset,
            source_type=source_type,
            source_id=source_id,
            category=category,
        )

        items = [NewsItemResponse(**item) for item in news_items]

        return NewsListResponse(
            items=items,
            total=len(items),
            limit=limit,
            offset=offset,
        )

    except Exception as e:
        logger.error(f"Error getting news: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e),
        ) from e


@app.get("/scheduler/status", response_model=SchedulerStatusResponse)
async def get_scheduler_status(
    scheduler: BackgroundScheduler = Depends(get_scheduler),
):
    """Get scheduler status."""
    try:
        status_info = await scheduler.get_status()
        return SchedulerStatusResponse(**status_info)

    except Exception as e:
        logger.error(f"Error getting scheduler status: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e),
        ) from e


@app.post("/scheduler/start")
async def start_scheduler(
    scheduler: BackgroundScheduler = Depends(get_scheduler),
):
    """Start the background scheduler."""
    try:
        await scheduler.start()
        return {"message": "Scheduler started successfully"}

    except Exception as e:
        logger.error(f"Error starting scheduler: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e),
        ) from e


@app.post("/scheduler/stop")
async def stop_scheduler(
    scheduler: BackgroundScheduler = Depends(get_scheduler),
):
    """Stop the background scheduler."""
    try:
        await scheduler.stop()
        return {"message": "Scheduler stopped successfully"}

    except Exception as e:
        logger.error(f"Error stopping scheduler: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e),
        ) from e


@app.get("/statistics", response_model=StatisticsResponse)
async def get_statistics(
    db: SupabaseNewsClient = Depends(get_database),
):
    """Get aggregated statistics."""
    try:
        stats = await db.get_statistics()
        return StatisticsResponse(**stats)

    except Exception as e:
        logger.error(f"Error getting statistics: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e),
        ) from e


@app.post("/fetch")
async def manual_fetch(
    source_type: str,
    source_id: str,
    limit: int = 10,
):
    """Manually fetch posts from a source (for testing)."""
    try:
        client = service_registry.get_client(source_type)
        if not client:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Client for {source_type} not available",
            )

        if not client._initialized:
            await client.initialize()

        posts = await client.fetch_posts(source_id, limit)

        return {
            "message": f"Fetched {len(posts)} posts from {source_type}:{source_id}",
            "posts": [
                {
                    "id": post.id,
                    "title": post.title,
                    "content": (
                        f"{post.content[:200]}..."
                        if len(post.content) > 200
                        else post.content
                    ),
                    "published_at": post.published_at.isoformat(),
                    "image_count": len(post.image_urls),
                    "video_count": len(post.video_urls),
                }
                for post in posts
            ],
        }

    except Exception as e:
        logger.error(f"Error during manual fetch: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e),
        ) from e


if __name__ == "__main__":
    server_config = settings.get_server_config()
    uvicorn.run(
        "main:app",
        host=server_config["host"],
        port=server_config["port"],
        reload=server_config["debug"],
        log_level="debug" if server_config["debug"] else "info",
    )
