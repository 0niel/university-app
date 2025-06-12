"""Main FastAPI application with unified social media client architecture."""

import asyncio
from contextlib import asynccontextmanager
from typing import Any, Dict, List, Optional

import uvicorn
from fastapi import Depends, FastAPI, HTTPException, status, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse, HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from loguru import logger
from src.config import Settings
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
from src.scheduler import BackgroundScheduler
from src.services import ServiceContainer
from src.supabase_client import SupabaseNewsClient
from src.clients.telegram import TelegramFetcher
from src.clients.vk import VKFetcher

settings = Settings()

# Global service container
services = ServiceContainer()
scheduler = None

# Templates and static files
templates = Jinja2Templates(directory="templates")


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Application lifespan handler."""
    global scheduler

    logger.info("Starting Social Media Fetcher API...")

    try:
        await setup_services()
        await services.initialize_all()

        scheduler_config = settings.get_scheduler_config()
        if scheduler_config.get("enabled", False):
            if services.database and services.media_storage:
                scheduler = BackgroundScheduler(
                    services.database,
                    services.media_storage,
                    services.client_registry,
                    settings
                )
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

        await services.close_all()
        logger.info("Application shutdown complete")


async def setup_services():
    """Setup all services and register them."""
    if settings.supabase_configured:
        # Setup database
        db_client = SupabaseNewsClient(settings)
        services.database = db_client
        logger.info("Database client registered")

        # Setup media storage
        media_storage = MediaStorage(settings, db_client.client)
        services.media_storage = media_storage
        logger.info("Media storage registered")
    else:
        logger.warning("Supabase not configured - database and media storage features disabled")

    # Setup clients
    if settings.telegram_configured:
        telegram_client = TelegramFetcher(settings)
        services.client_registry.register_client(telegram_client)
        logger.info("Telegram client registered")

    if settings.vk_configured:
        vk_client = VKFetcher(settings)
        services.client_registry.register_client(vk_client)
        logger.info("VK client registered")


app = FastAPI(
    title="Social Media Fetcher API",
    description="Unified API for fetching social media content from various platforms",
    version="2.0.0",
    lifespan=lifespan,
)

# Mount static files
app.mount("/static", StaticFiles(directory="static"), name="static")

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
    if services.database:
        return services.database
    else:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Database service not available",
        )


def get_scheduler() -> BackgroundScheduler:
    """Get scheduler dependency."""
    if scheduler:
        return scheduler
    else:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Scheduler service not available",
        )


# Frontend routes
@app.get("/dashboard", response_class=HTMLResponse)
async def dashboard(request: Request):
    """Dashboard page."""
    return templates.TemplateResponse("dashboard.html", {"request": request})

@app.get("/sources-page", response_class=HTMLResponse)
async def sources_page(request: Request):
    """Sources management page."""
    return templates.TemplateResponse("sources.html", {"request": request})

@app.get("/news-page", response_class=HTMLResponse)
async def news_page(request: Request):
    """News viewing page."""
    return templates.TemplateResponse("news.html", {"request": request})

@app.get("/analytics", response_class=HTMLResponse)
async def analytics_page(request: Request):
    """Analytics page."""
    return templates.TemplateResponse("analytics.html", {"request": request})

@app.get("/settings", response_class=HTMLResponse)
async def settings_page(request: Request):
    """Settings page."""
    return templates.TemplateResponse("settings.html", {"request": request})

# Redirect root to dashboard
@app.get("/", response_class=HTMLResponse)
async def root_redirect(request: Request):
    """Redirect root to dashboard."""
    return templates.TemplateResponse("dashboard.html", {"request": request})

# API routes
@app.get("/api", response_model=Dict[str, Any])
async def api_root():
    """Root API endpoint with service information."""
    return {
        "message": "Social Media Fetcher API",
        "version": "2.0.0",
        "status": "running",
        "available_clients": list(services.client_registry.get_all_clients().keys()),
        "enabled_clients": list(services.client_registry.get_enabled_clients().keys()),
        "auto_sync_clients": list(services.client_registry.get_auto_sync_clients().keys()),
    }

@app.get("/api/health", response_model=Dict[str, Any])
async def health_check():
    """Health check endpoint."""
    services_status = {
        "database": "available" if services.database else "unavailable",
        "media_storage": "available" if services.media_storage else "unavailable",
    }

    clients = services.client_registry.get_all_clients()
    services_status["clients"] = {
        client_type: "initialized" if client._initialized else "not_initialized"
        for client_type, client in clients.items()
    }

    services_status["scheduler"] = "available" if scheduler else "unavailable"

    return {
        "status": "healthy",
        "services": services_status,
        "enabled_clients": list(services.client_registry.get_enabled_clients().keys()),
        "auto_sync_clients": list(services.client_registry.get_auto_sync_clients().keys()),
    }


@app.post("/api/sources", response_model=SourceResponse)
async def add_source(
    request: AddSourceRequest,
    db: SupabaseNewsClient = Depends(get_database),
):
    """Add a new social media source."""
    try:
        client = services.client_registry.get_client(request.source_type)
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


@app.get("/api/sources", response_model=List[SourceResponse])
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


@app.put("/api/sources/{source_id}", response_model=SourceResponse)
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


@app.delete("/api/sources/{source_id}")
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


@app.get("/api/news", response_model=NewsListResponse)
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


@app.get("/api/scheduler/status", response_model=SchedulerStatusResponse)
async def get_scheduler_status():
    """Get scheduler status."""
    try:
        if services.database:
            status_info = await services.database.get_status()
        else:
            status_info = {
                "is_enabled": False,
                "sync_interval_minutes": 30,
                "last_sync_at": None,
                "next_sync_at": None,
                "total_synced": 0,
                "errors_count": 0,
            }
        return SchedulerStatusResponse(**status_info)

    except Exception as e:
        logger.error(f"Error getting scheduler status: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e),
        ) from e


@app.post("/api/scheduler/start")
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


@app.post("/api/scheduler/stop")
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


@app.get("/api/statistics", response_model=StatisticsResponse)
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


@app.post("/api/fetch")
async def manual_fetch(
    source_type: str,
    source_id: str,
    limit: int = 10,
):
    """Manually fetch posts from a source (for testing)."""
    try:
        client = services.client_registry.get_client(source_type)
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
