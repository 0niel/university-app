"""Main FastAPI application with unified social media client architecture."""

import asyncio
from contextlib import asynccontextmanager
from typing import Any, Dict, List, Optional
from datetime import datetime, timezone

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

        await _auto_register_client_sources()

        scheduler_config = settings.get_scheduler_config()
        if scheduler_config.get("enabled", False):
            if services.database and services.media_storage:
                scheduler = BackgroundScheduler(
                    services.database,
                    services.media_storage,
                    services.client_registry,
                    settings,
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
    else:
        logger.warning(
            "Supabase not configured - database and media storage features disabled"
        )

    # Setup clients
    if settings.telegram_configured:
        telegram_client = TelegramFetcher(settings)
        services.client_registry.register_client(telegram_client)
        logger.info("Telegram client registered")

    if settings.vk_configured:
        vk_client = VKFetcher(settings)
        services.client_registry.register_client(vk_client)
        logger.info("VK client registered")

    from src.clients.mirea.client import MireaOfficialFetcher
    mirea_client = MireaOfficialFetcher(settings)
    services.client_registry.register_client(mirea_client)
    logger.info("MIREA client registered")


async def _auto_register_client_sources():
    """Auto-register sources for clients that support it."""
    if not services.database:
        logger.warning("Database not available - skipping auto-registration of sources")
        return

    # Check if database is properly initialized
    try:
        # Test database connection with a simple query
        await services.database.get_sources(limit=1)
    except Exception as e:
        logger.warning(f"Database not properly initialized - skipping auto-registration: {e}")
        return

    all_clients = services.client_registry.get_all_clients()
    
    for client_type, client in all_clients.items():
        if not client.auto_register_sources:
            continue
            
        default_sources = client.get_default_sources()
        if not default_sources:
            continue
            
        logger.info(f"Auto-registering {len(default_sources)} sources for {client_type} client")
        
        for source_info in default_sources:
            try:
                existing_sources = await services.database.get_sources(
                    source_type=client_type,
                    active_only=False
                )
                
                source_exists = any(
                    source["source_id"] == source_info["source_id"] 
                    for source in existing_sources
                )
                
                if not source_exists:
                    await services.database.add_source(
                        source_type=client_type,
                        source_id=source_info["source_id"],
                        source_name=source_info["source_name"],
                        description=source_info.get("description", ""),
                        category=source_info.get("category", "general"),
                        is_active=True
                    )
                    logger.info(f"Auto-registered source: {source_info['source_name']} ({client_type})")
                else:
                    logger.debug(f"Source already exists: {source_info['source_name']} ({client_type})")
                    
            except Exception as e:
                logger.error(f"Error auto-registering source {source_info['source_name']}: {e}")


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
        "auto_sync_clients": list(
            services.client_registry.get_auto_sync_clients().keys()
        ),
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
        "auto_sync_clients": list(
            services.client_registry.get_auto_sync_clients().keys()
        ),
    }


@app.post("/api/sources", response_model=SourceResponse)
async def add_source(
    request: AddSourceRequest,
    db: SupabaseNewsClient = Depends(get_database),
):
    """Add a new social media source."""
    try:
        # Import ClientFactory here to avoid circular imports
        from src.client_factory import ClientFactory
        from src.registry import ServiceRegistry
        
        # Create a temporary factory to use detection methods
        factory = ClientFactory(settings, ServiceRegistry())
        
        # Auto-detect source type and extract source ID if not provided
        if not request.source_type or not request.source_id:
            detected_type, detected_id = factory.extract_source_info_from_url(request.source_url)
            
            if not detected_type:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"Could not determine source type from URL: {request.source_url}. "
                           f"Supported platforms: {', '.join(factory.get_available_client_types())}"
                )
            
            if not detected_id:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"Could not extract source ID from URL: {request.source_url}"
                )
            
            # Use detected values if not provided
            if not request.source_type:
                request.source_type = detected_type
            if not request.source_id:
                request.source_id = detected_id
        
        # Validate that we have a client for this source type
        if request.source_type not in factory.get_available_client_types():
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Unknown source type: {request.source_type}. "
                       f"Available types: {', '.join(factory.get_available_client_types())}"
            )
        
        # Validate the source if client is available and initialized
        client = services.client_registry.get_client(request.source_type)
        if client and client._initialized:
            is_valid = await client.validate_source(request.source_id)
            if not is_valid:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail=f"Source {request.source_id} is not accessible or does not exist"
                )

        # Add the source to database
        source = await db.add_source(
            source_type=request.source_type,
            source_id=request.source_id,
            source_name=request.source_name,
            source_url=request.source_url,
            category=request.category,
            description=request.description,
            is_active=request.is_active,
        )

        return SourceResponse(**source)

    except HTTPException:
        raise
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
    source_id: str,
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


@app.post("/api/sources/{source_id}/fetch", status_code=status.HTTP_202_ACCEPTED)
async def manual_fetch_source(
    source_id: str,
    limit: int = 20,
    db: SupabaseNewsClient = Depends(get_database),
):
    """Manually fetches posts from a single source and saves them."""
    try:
        logger.info(f"Manual fetch: source_id={source_id}, limit={limit}")
        source = await db.get_source(source_id)
        if not source:
            logger.error(f"Source with ID {source_id} not found in DB")
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Source with ID {source_id} not found",
            )
        logger.info(f"Source found: {source}")

        source_type = source["source_type"]
        platform_source_id = source["source_id"]
        logger.info(f"Source type: {source_type}, platform_source_id: {platform_source_id}")
        
        client = services.client_registry.get_client(source_type)
        if not client:
            logger.error(f"Client for source type '{source_type}' not available or configured.")
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Client for source type '{source_type}' not available or configured.",
            )
        logger.info(f"Client found: {client}")

        if not client.is_initialized:
            logger.info(f"Initializing client {source_type}")
            await client.initialize()
        logger.info(f"Client {source_type} initialized: {client.is_initialized}")

        raw_data_list = await client.fetch_raw_data(platform_source_id, limit)
        logger.info(f"Fetched {len(raw_data_list)} raw items from client")

        saved_count = 0
        for idx, raw_data in enumerate(raw_data_list):
            try:
                logger.info(f"Saving item {idx+1}/{len(raw_data_list)}: {raw_data.get('id', '')}")
                result = await db.save_raw_data_as_news_blocks(
                    raw_data=raw_data,
                    source_type=source_type,
                    source_id=platform_source_id,
                    source_name=source["source_name"],
                )
                logger.info(f"Save result: {result}")
                if result:
                    saved_count += 1
            except Exception as e:
                logger.error(f"Error saving item {idx+1}: {e}")
        
        await db.update_source(source_id, last_fetched_at=datetime.now(timezone.utc))
        logger.info(f"Manual fetch complete: saved {saved_count}/{len(raw_data_list)} items for source {source_id}")

        return {
            "message": f"Successfully fetched and saved {saved_count}/{len(raw_data_list)} posts for source {source_id}."
        }

    except Exception as e:
        logger.error(f"Error during manual fetch for source {source_id}: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e),
        ) from e


@app.delete("/api/sources/{source_id}")
async def delete_source(
    source_id: str,
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
        news_data = await db.get_latest_news(
            limit=limit,
            offset=offset,
            source_type=source_type,
            source_id=source_id,
            category=category,
        )

        items = [NewsItemResponse(**item) for item in news_data["items"]]
        total_count = news_data["total"]
        has_more = (offset + len(items)) < total_count

        return NewsListResponse(
            items=items,
            total=total_count,
            limit=limit,
            offset=offset,
            has_more=has_more,
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


@app.post("/api/scheduler/config")
async def update_scheduler_config(
    request: SchedulerConfigRequest,
    db: SupabaseNewsClient = Depends(get_database),
):
    """Update scheduler configuration."""
    try:
        update_data = request.dict(exclude_unset=True)
        await db.update_scheduler_config(**update_data)
        return {"message": "Scheduler configuration updated successfully"}

    except Exception as e:
        logger.error(f"Error updating scheduler config: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e),
        ) from e


@app.post("/api/sources/{source_id}/auto-sync")
async def toggle_source_auto_sync(
    source_id: str,
    enabled: bool,
    db: SupabaseNewsClient = Depends(get_database),
):
    """Enable or disable auto-sync for a specific source."""
    try:
        # Update the source's is_active field to control auto-sync
        source = await db.update_source(source_id, is_active=enabled)
        return {
            "message": f"Auto-sync {'enabled' if enabled else 'disabled'} for source",
            "source": SourceResponse(**source)
        }

    except Exception as e:
        logger.error(f"Error updating source auto-sync: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e),
        ) from e


@app.get("/api/debug/clients")
async def debug_clients():
    """Debug endpoint to check client configuration and status."""
    try:
        clients_info = {}
        
        # Check configuration
        clients_info["telegram_configured"] = settings.telegram_configured
        clients_info["vk_configured"] = settings.vk_configured
        
        # Check registered clients
        all_clients = services.client_registry.get_all_clients()
        enabled_clients = services.client_registry.get_enabled_clients()
        auto_sync_clients = services.client_registry.get_auto_sync_clients()
        
        clients_info["registered_clients"] = list(all_clients.keys())
        clients_info["enabled_clients"] = list(enabled_clients.keys())
        clients_info["auto_sync_clients"] = list(auto_sync_clients.keys())
        
        # Check individual client status
        for client_type, client in all_clients.items():
            clients_info[f"{client_type}_status"] = {
                "configured": client.is_configured,
                "initialized": client._initialized,
                "auto_sync_enabled": client.auto_sync_enabled,
            }
        
        return clients_info

    except Exception as e:
        logger.error(f"Error in debug endpoint: {e}")
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


@app.get("/api/supported-sources", response_model=Dict[str, Any])
async def get_supported_sources():
    """Get information about supported source types and URL formats."""
    from src.client_factory import ClientFactory
    from src.registry import ServiceRegistry
    
    factory = ClientFactory(settings, ServiceRegistry())
    
    supported_sources = {
        "telegram": {
            "name": "Telegram",
            "description": "Telegram channels and groups",
            "url_formats": [
                "https://t.me/channel_name",
                "https://telegram.me/channel_name",
                "t.me/channel_name"
            ],
            "examples": [
                "https://t.me/example_channel",
                "https://t.me/s/example_channel"
            ]
        },
        "vk": {
            "name": "VKontakte",
            "description": "VK groups and public pages",
            "url_formats": [
                "https://vk.com/group_name",
                "https://vk.com/public123456",
                "https://vk.com/club123456",
                "vk.com/group_name"
            ],
            "examples": [
                "https://vk.com/example_group",
                "https://vk.com/public123456"
            ]
        },
        "mirea": {
            "name": "MIREA Official",
            "description": "Official MIREA university news",
            "url_formats": [
                "https://www.mirea.ru/news/"
            ],
            "examples": [
                "https://www.mirea.ru/news/"
            ],
            "auto_registered": True
        }
    }
    
    available_types = factory.get_available_client_types()
    enabled_types = factory.get_enabled_client_types()
    
    return {
        "supported_sources": {
            source_type: info 
            for source_type, info in supported_sources.items() 
            if source_type in available_types
        },
        "available_types": available_types,
        "enabled_types": enabled_types,
        "note": "You only need to provide source_url and source_name. The system will automatically detect the source type and extract the source ID. Some sources (like MIREA) are automatically registered when the service starts."
    }


if __name__ == "__main__":
    server_config = settings.get_server_config()
    uvicorn.run(
        "main:app",
        host=server_config["host"],
        port=server_config["port"],
        reload=server_config["debug"],
        log_level="debug" if server_config["debug"] else "info",
    )
