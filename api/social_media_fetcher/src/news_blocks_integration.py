"""Integration module for news_blocks with social media fetcher."""

import os
import asyncio
from typing import List, Dict, Any, Optional
from pathlib import Path

from .supabase_client import SupabaseNewsClient

# Try to import generated news_blocks (will be generated on first run)
try:
    from .news_blocks import generate_models_from_dart, NewsBlockAdapter
    from .news_blocks.models import NewsBlock
    BLOCKS_AVAILABLE = True
except ImportError:
    BLOCKS_AVAILABLE = False
    NewsBlock = None
    NewsBlockAdapter = None


class NewsBlocksManager:
    """Manager for news blocks generation and integration."""
    
    def __init__(self, supabase_client: SupabaseNewsClient):
        """Initialize manager."""
        self.supabase_client = supabase_client
        self.blocks_generated = BLOCKS_AVAILABLE
        
    async def ensure_blocks_generated(self) -> bool:
        """Ensure news blocks models are generated."""
        if self.blocks_generated:
            return True
            
        try:
            # Path to Dart package (relative to this file)
            current_dir = Path(__file__).parent
            dart_package_path = current_dir.parent.parent / "packages" / "news_blocks"
            output_path = current_dir / "news_blocks"
            
            if dart_package_path.exists():
                print("🔄 Generating news blocks models from Dart...")
                
                # Generate models
                from .news_blocks import generate_models_from_dart
                generate_models_from_dart(
                    dart_package_path=str(dart_package_path),
                    output_path=str(output_path)
                )
                
                print("✅ News blocks models generated successfully")
                self.blocks_generated = True
                return True
            else:
                print(f"⚠️  Dart package not found at {dart_package_path}")
                return False
                
        except Exception as e:
            print(f"❌ Failed to generate news blocks: {e}")
            return False
    
    async def get_news_as_blocks(self, 
                                limit: int = 20, 
                                offset: int = 0,
                                source_type: Optional[str] = None) -> List[Dict[str, Any]]:
        """Get news items as news blocks using the enhanced Supabase client."""
        if not await self.ensure_blocks_generated():
            return []
            
        try:
            # Use the enhanced Supabase client method
            return await self.supabase_client.get_news_as_blocks(
                limit=limit,
                offset=offset,
                source_type=source_type
            )
            
        except Exception as e:
            print(f"❌ Error fetching news blocks: {e}")
            return []
    
    async def get_news_blocks_by_type(self,
                                     block_type: str,
                                     limit: int = 20,
                                     offset: int = 0) -> List[Dict[str, Any]]:
        """Get news items containing specific block types."""
        if not await self.ensure_blocks_generated():
            return []
            
        try:
            return await self.supabase_client.get_news_blocks_by_type(
                block_type=block_type,
                limit=limit,
                offset=offset
            )
            
        except Exception as e:
            print(f"❌ Error fetching news blocks by type {block_type}: {e}")
            return []
    
    async def regenerate_news_blocks_for_item(self, item_id: str) -> bool:
        """Regenerate news blocks for a specific item."""
        if not await self.ensure_blocks_generated():
            return False
            
        try:
            return await self.supabase_client.regenerate_news_blocks_for_item(item_id)
            
        except Exception as e:
            print(f"❌ Error regenerating news blocks for item {item_id}: {e}")
            return False
    
    async def regenerate_all_news_blocks(self) -> int:
        """Regenerate news blocks for all existing news items using database function."""
        if not await self.ensure_blocks_generated():
            return 0
            
        try:
            print("🔄 Regenerating news blocks for all items...")
            
            # Use the database function for efficient bulk regeneration
            processed_count = await self.supabase_client.regenerate_all_news_blocks()
            
            print(f"✅ Regenerated news blocks for {processed_count} items")
            return processed_count
            
        except Exception as e:
            print(f"❌ Error during regeneration: {e}")
            return 0

    async def get_news_blocks_statistics(self) -> Dict[str, Any]:
        """Get statistics about news blocks coverage."""
        try:
            stats = await self.supabase_client.get_statistics()
            
            # Extract news blocks specific statistics
            return {
                "total_items": stats.get("total_items", 0),
                "items_with_news_blocks": stats.get("items_with_news_blocks", 0),
                "news_blocks_coverage": stats.get("news_blocks_coverage", {}),
                "coverage_percentage": (
                    (stats.get("items_with_news_blocks", 0) / stats.get("total_items", 1)) * 100
                    if stats.get("total_items", 0) > 0 else 0
                ),
                "by_source_type": stats.get("by_source_type", {}),
                "last_updated": stats.get("last_updated"),
            }
            
        except Exception as e:
            print(f"❌ Error getting news blocks statistics: {e}")
            return {}


# Auto-generation function for startup
async def auto_generate_news_blocks() -> bool:
    """Auto-generate news blocks on startup if needed."""
    try:
        # Check if models directory exists
        current_dir = Path(__file__).parent
        models_dir = current_dir / "news_blocks"
        
        if models_dir.exists() and (models_dir / "models.py").exists():
            print("✅ News blocks models already exist")
            return True
        
        # Generate models
        dart_package_path = current_dir.parent.parent / "packages" / "news_blocks"
        
        if dart_package_path.exists():
            print("🔄 Auto-generating news blocks models...")
            
            from .news_blocks import generate_models_from_dart
            generate_models_from_dart(
                dart_package_path=str(dart_package_path),
                output_path=str(models_dir)
            )
            
            print("✅ News blocks auto-generation completed")
            return True
        else:
            print("⚠️  Dart package not found, skipping auto-generation")
            return False
            
    except Exception as e:
        print(f"❌ Auto-generation failed: {e}")
        return False


# Enhanced Supabase client that automatically handles news blocks
class EnhancedSupabaseNewsClient(SupabaseNewsClient):
    """Enhanced Supabase client with automatic news blocks support."""
    
    def __init__(self, settings):
        """Initialize enhanced client."""
        super().__init__(settings)
        self.news_blocks_manager = None
    
    async def initialize(self):
        """Initialize with news blocks support."""
        await super().initialize()
        
        # Initialize news blocks manager
        self.news_blocks_manager = NewsBlocksManager(self)
        
        # Auto-generate models if needed
        await auto_generate_news_blocks()
    
    async def get_news_blocks(self, **kwargs) -> List[Dict[str, Any]]:
        """Get news items as news blocks."""
        if not self.news_blocks_manager:
            return []
        
        return await self.news_blocks_manager.get_news_as_blocks(**kwargs)
    
    async def get_news_blocks_by_type(self, block_type: str, **kwargs) -> List[Dict[str, Any]]:
        """Get news items containing specific block types."""
        if not self.news_blocks_manager:
            return []
        
        return await self.news_blocks_manager.get_news_blocks_by_type(block_type, **kwargs)
    
    async def regenerate_all_news_blocks(self) -> int:
        """Regenerate news blocks for all items."""
        if not self.news_blocks_manager:
            return 0
        
        return await self.news_blocks_manager.regenerate_all_news_blocks()
    
    async def get_news_blocks_statistics(self) -> Dict[str, Any]:
        """Get news blocks statistics."""
        if not self.news_blocks_manager:
            return {}
        
        return await self.news_blocks_manager.get_news_blocks_statistics() 
