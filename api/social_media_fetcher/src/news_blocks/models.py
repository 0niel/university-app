"""Generated Python models for news blocks."""

# This file is auto-generated. Do not edit manually.
# Generated on: 2025-06-12T20:23:15.194213

from __future__ import annotations

from datetime import datetime
from typing import ClassVar
from typing import List


from .base import *


class ArticleIntroductionBlock(NewsBlock):
    """Python model for ArticleIntroductionBlock."""
    
    IDENTIFIER: ClassVar[str] = "__article_introduction__"
    
    categoryId: str = Field(..., alias="category_id", description="Categoryid - String")
    author: str = Field(..., alias="author", description="Author - String")
    publishedAt: datetime = Field(..., alias="published_at", description="Publishedat - DateTime")
    imageUrl: str = Field(None, alias="image_url", description="Imageurl - String")
    title: str = Field(..., alias="title", description="Title - String")
    
    
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
    
    model_config = ConfigDict(populate_by_name=True)


class BannerAdBlock(NewsBlock):
    """Python model for BannerAdBlock."""
    
    IDENTIFIER: ClassVar[str] = "__banner_ad__"
    
    size: BannerSize = Field(..., alias="size", description="Size - BannerSize")
    
    
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
    
    model_config = ConfigDict(populate_by_name=True)


class Category(NewsBlock):
    """Python model for Category."""
    
    id: str = Field(..., alias="id", description="Id - String")
    name: str = Field(..., alias="name", description="Name - String")
    
    
    model_config = ConfigDict(populate_by_name=True)


class DividerHorizontalBlock(NewsBlock):
    """Python model for DividerHorizontalBlock."""
    
    IDENTIFIER: ClassVar[str] = "__divider_horizontal__"
    
    
    
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
    
    model_config = ConfigDict(populate_by_name=True)


class HtmlBlock(NewsBlock):
    """Python model for HtmlBlock."""
    
    IDENTIFIER: ClassVar[str] = "__html__"
    
    content: str = Field(..., alias="content", description="Content - String")
    
    
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
    
    model_config = ConfigDict(populate_by_name=True)


class ImageBlock(NewsBlock):
    """Python model for ImageBlock."""
    
    IDENTIFIER: ClassVar[str] = "__image__"
    
    imageUrl: str = Field(..., alias="image_url", description="Imageurl - String")
    
    
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
    
    model_config = ConfigDict(populate_by_name=True)


class NewsletterBlock(NewsBlock):
    """Python model for NewsletterBlock."""
    
    IDENTIFIER: ClassVar[str] = "__newsletter__"
    
    
    
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
    
    model_config = ConfigDict(populate_by_name=True)


class PostGridGroupBlock(NewsBlock):
    """Python model for PostGridGroupBlock."""
    
    IDENTIFIER: ClassVar[str] = "__post_grid_group__"
    
    categoryId: str = Field(..., alias="category_id", description="Categoryid - String")
    tiles: List[PostGridTileBlock] = Field(..., alias="tiles", description="Tiles - List of PostGridTileBlock")
    
    
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
    
    model_config = ConfigDict(populate_by_name=True)


class PostGridTileBlock(PostBlock):
    """Python model for PostGridTileBlock."""
    
    IDENTIFIER: ClassVar[str] = "__post_grid_tile__"
    
    
    
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
    
    model_config = ConfigDict(populate_by_name=True)


class PostLargeBlock(PostBlock):
    """Python model for PostLargeBlock."""
    
    IDENTIFIER: ClassVar[str] = "__post_large__"
    
    
    
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
    
    model_config = ConfigDict(populate_by_name=True)


class PostMediumBlock(PostBlock):
    """Python model for PostMediumBlock."""
    
    IDENTIFIER: ClassVar[str] = "__post_medium__"
    
    
    
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
    
    model_config = ConfigDict(populate_by_name=True)


class PostSmallBlock(PostBlock):
    """Python model for PostSmallBlock."""
    
    IDENTIFIER: ClassVar[str] = "__post_small__"
    
    
    
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
    
    model_config = ConfigDict(populate_by_name=True)


class SectionHeaderBlock(NewsBlock):
    """Python model for SectionHeaderBlock."""
    
    IDENTIFIER: ClassVar[str] = "__section_header__"
    
    title: str = Field(..., alias="title", description="Title - String")
    action: BlockAction = Field(None, alias="action", description="Action - BlockAction")
    
    
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
    
    model_config = ConfigDict(populate_by_name=True)


class SlideshowBlock(NewsBlock):
    """Python model for SlideshowBlock."""
    
    IDENTIFIER: ClassVar[str] = "__slideshow__"
    
    title: str = Field(..., alias="title", description="Title - String")
    slides: List[SlideBlock] = Field(..., alias="slides", description="Slides - List of SlideBlock")
    
    
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
    
    model_config = ConfigDict(populate_by_name=True)


class SlideshowIntroductionBlock(NewsBlock):
    """Python model for SlideshowIntroductionBlock."""
    
    IDENTIFIER: ClassVar[str] = "__slideshow_introduction__"
    
    title: str = Field(..., alias="title", description="Title - String")
    coverImageUrl: str = Field(..., alias="cover_image_url", description="Coverimageurl - String")
    action: BlockAction = Field(None, alias="action", description="Action - BlockAction")
    
    
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
    
    model_config = ConfigDict(populate_by_name=True)


class SlideBlock(NewsBlock):
    """Python model for SlideBlock."""
    
    IDENTIFIER: ClassVar[str] = "__slide_block__"
    
    caption: str = Field(..., alias="caption", description="Caption - String")
    description: str = Field(..., alias="description", description="Description - String")
    photoCredit: str = Field(..., alias="photo_credit", description="Photocredit - String")
    imageUrl: str = Field(..., alias="image_url", description="Imageurl - String")
    
    
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
    
    model_config = ConfigDict(populate_by_name=True)


class SpacerBlock(NewsBlock):
    """Python model for SpacerBlock."""
    
    IDENTIFIER: ClassVar[str] = "__spacer__"
    
    spacing: Spacing = Field(..., alias="spacing", description="Spacing - Spacing")
    
    
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
    
    model_config = ConfigDict(populate_by_name=True)


class TextCaptionBlock(NewsBlock):
    """Python model for TextCaptionBlock."""
    
    IDENTIFIER: ClassVar[str] = "__text_caption__"
    
    color: TextCaptionColor = Field(..., alias="color", description="Color - TextCaptionColor")
    text: str = Field(..., alias="text", description="Text - String")
    
    
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
    
    model_config = ConfigDict(populate_by_name=True)


class TextHeadlineBlock(NewsBlock):
    """Python model for TextHeadlineBlock."""
    
    IDENTIFIER: ClassVar[str] = "__text_headline__"
    
    text: str = Field(..., alias="text", description="Text - String")
    
    
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
    
    model_config = ConfigDict(populate_by_name=True)


class TextLeadParagraphBlock(NewsBlock):
    """Python model for TextLeadParagraphBlock."""
    
    IDENTIFIER: ClassVar[str] = "__text_lead_paragraph__"
    
    text: str = Field(..., alias="text", description="Text - String")
    
    
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
    
    model_config = ConfigDict(populate_by_name=True)


class TextParagraphBlock(NewsBlock):
    """Python model for TextParagraphBlock."""
    
    IDENTIFIER: ClassVar[str] = "__text_paragraph__"
    
    text: str = Field(..., alias="text", description="Text - String")
    
    
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
    
    model_config = ConfigDict(populate_by_name=True)


class TrendingStoryBlock(NewsBlock):
    """Python model for TrendingStoryBlock."""
    
    IDENTIFIER: ClassVar[str] = "__trending_story__"
    
    content: PostSmallBlock = Field(..., alias="content", description="Content - PostSmallBlock")
    
    
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
    
    model_config = ConfigDict(populate_by_name=True)


class VideoBlock(NewsBlock):
    """Python model for VideoBlock."""
    
    IDENTIFIER: ClassVar[str] = "__video__"
    
    videoUrl: str = Field(..., alias="video_url", description="Videourl - String")
    
    
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
    
    model_config = ConfigDict(populate_by_name=True)


class VideoIntroductionBlock(NewsBlock):
    """Python model for VideoIntroductionBlock."""
    
    IDENTIFIER: ClassVar[str] = "__video_introduction__"
    
    categoryId: str = Field(..., alias="category_id", description="Categoryid - String")
    title: str = Field(..., alias="title", description="Title - String")
    videoUrl: str = Field(..., alias="video_url", description="Videourl - String")
    
    
    @classmethod
    def get_identifier(cls) -> str:
        """Get the block type identifier."""
        return cls.IDENTIFIER
    
    model_config = ConfigDict(populate_by_name=True)


# Factory function
def create_news_block_from_json(data: Dict[str, Any]) -> NewsBlock:
    """Create a news block instance from JSON data."""
    block_type = data.get("type")
    
    if block_type == "__article_introduction__":
        return ArticleIntroductionBlock(**data)
    if block_type == "__banner_ad__":
        return BannerAdBlock(**data)
    if block_type == "__divider_horizontal__":
        return DividerHorizontalBlock(**data)
    if block_type == "__html__":
        return HtmlBlock(**data)
    if block_type == "__image__":
        return ImageBlock(**data)
    if block_type == "__newsletter__":
        return NewsletterBlock(**data)
    if block_type == "__post_grid_group__":
        return PostGridGroupBlock(**data)
    if block_type == "__post_grid_tile__":
        return PostGridTileBlock(**data)
    if block_type == "__post_large__":
        return PostLargeBlock(**data)
    if block_type == "__post_medium__":
        return PostMediumBlock(**data)
    if block_type == "__post_small__":
        return PostSmallBlock(**data)
    if block_type == "__section_header__":
        return SectionHeaderBlock(**data)
    if block_type == "__slideshow__":
        return SlideshowBlock(**data)
    if block_type == "__slideshow_introduction__":
        return SlideshowIntroductionBlock(**data)
    if block_type == "__slide_block__":
        return SlideBlock(**data)
    if block_type == "__spacer__":
        return SpacerBlock(**data)
    if block_type == "__text_caption__":
        return TextCaptionBlock(**data)
    if block_type == "__text_headline__":
        return TextHeadlineBlock(**data)
    if block_type == "__text_lead_paragraph__":
        return TextLeadParagraphBlock(**data)
    if block_type == "__text_paragraph__":
        return TextParagraphBlock(**data)
    if block_type == "__trending_story__":
        return TrendingStoryBlock(**data)
    if block_type == "__video__":
        return VideoBlock(**data)
    if block_type == "__video_introduction__":
        return VideoIntroductionBlock(**data)
    
    
    # Return unknown block for unrecognized types
    return UnknownBlock(type=block_type or "__unknown__")


# Registry mapping
BLOCK_TYPE_REGISTRY = {
    "__article_introduction__": ArticleIntroductionBlock,
    "__banner_ad__": BannerAdBlock,
    "__divider_horizontal__": DividerHorizontalBlock,
    "__html__": HtmlBlock,
    "__image__": ImageBlock,
    "__newsletter__": NewsletterBlock,
    "__post_grid_group__": PostGridGroupBlock,
    "__post_grid_tile__": PostGridTileBlock,
    "__post_large__": PostLargeBlock,
    "__post_medium__": PostMediumBlock,
    "__post_small__": PostSmallBlock,
    "__section_header__": SectionHeaderBlock,
    "__slideshow__": SlideshowBlock,
    "__slideshow_introduction__": SlideshowIntroductionBlock,
    "__slide_block__": SlideBlock,
    "__spacer__": SpacerBlock,
    "__text_caption__": TextCaptionBlock,
    "__text_headline__": TextHeadlineBlock,
    "__text_lead_paragraph__": TextLeadParagraphBlock,
    "__text_paragraph__": TextParagraphBlock,
    "__trending_story__": TrendingStoryBlock,
    "__video__": VideoBlock,
    "__video_introduction__": VideoIntroductionBlock,
    
}