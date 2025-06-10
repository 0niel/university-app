CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;
CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA extensions;

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

    -- Create social_news_sources table
CREATE TABLE IF NOT EXISTS public.social_news_sources (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    source_type VARCHAR NOT NULL,
    source_id VARCHAR NOT NULL,
    source_name VARCHAR NOT NULL,
    source_url VARCHAR,
    category VARCHAR,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    last_fetched_at TIMESTAMPTZ,

    UNIQUE(source_type, source_id)
);

CREATE INDEX IF NOT EXISTS idx_social_news_sources_active 
ON public.social_news_sources (is_active) 
WHERE is_active = true;

CREATE TRIGGER update_social_news_sources_updated_at
    BEFORE UPDATE ON public.social_news_sources
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TABLE IF NOT EXISTS public.social_news_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    external_id VARCHAR NOT NULL,
    source_type VARCHAR NOT NULL,
    source_id VARCHAR NOT NULL,
    source_name VARCHAR NOT NULL,
    title TEXT NOT NULL,
    content TEXT,
    original_url VARCHAR,
    published_at TIMESTAMPTZ NOT NULL,
    image_urls TEXT[],
    video_urls TEXT[],
    tags TEXT[],
    likes_count INTEGER,
    comments_count INTEGER,
    shares_count INTEGER,
    views_count INTEGER,
    raw_data JSONB,
    processed_at TIMESTAMPTZ DEFAULT now(),
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    
    UNIQUE(source_type, source_id, external_id)
);

CREATE INDEX IF NOT EXISTS idx_social_news_items_published 
ON public.social_news_items (published_at DESC);

CREATE INDEX IF NOT EXISTS idx_social_news_items_source 
ON public.social_news_items (source_type, source_id);

CREATE INDEX IF NOT EXISTS idx_social_news_items_tags 
ON public.social_news_items USING gin (tags);

CREATE TRIGGER update_social_news_items_updated_at
    BEFORE UPDATE ON public.social_news_items
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TABLE IF NOT EXISTS public.social_news_scheduler_config (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    is_enabled BOOLEAN DEFAULT false,
    sync_interval_minutes INTEGER DEFAULT 30,
    last_sync_at TIMESTAMPTZ,
    next_sync_at TIMESTAMPTZ,
    total_synced INTEGER DEFAULT 0,
    errors_count INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TRIGGER update_social_news_scheduler_config_updated_at
    BEFORE UPDATE ON public.social_news_scheduler_config
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TABLE IF NOT EXISTS public.social_news_statistics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    source_type VARCHAR NOT NULL,
    source_id VARCHAR NOT NULL,
    source_name VARCHAR NOT NULL,
    total_items INTEGER DEFAULT 0,
    latest_published_at TIMESTAMPTZ,
    last_updated TIMESTAMPTZ DEFAULT now(),
    
    UNIQUE(source_type, source_id)
);

INSERT INTO storage.buckets (id, name, public) 
VALUES 
    ('social-media-images', 'social-media-images', true),
    ('social-media-videos', 'social-media-videos', true)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "Allow public read access to images" ON storage.objects
    FOR SELECT USING (bucket_id = 'social-media-images');

CREATE POLICY "Allow public read access to videos" ON storage.objects
    FOR SELECT USING (bucket_id = 'social-media-videos');

CREATE OR REPLACE FUNCTION clean_expired_cache(days_to_keep INTEGER DEFAULT 7)
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM public.social_news_items
    WHERE processed_at < NOW() - INTERVAL '1 day' * days_to_keep;
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    
    REFRESH MATERIALIZED VIEW IF EXISTS social_news_statistics_view;
    
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

CREATE MATERIALIZED VIEW IF NOT EXISTS social_news_statistics_view AS
SELECT 
    source_type,
    source_id,
    source_name,
    COUNT(*) as total_items,
    MAX(published_at) as latest_published_at,
    NOW() as last_updated
FROM public.social_news_items
GROUP BY source_type, source_id, source_name;

CREATE UNIQUE INDEX IF NOT EXISTS idx_social_news_statistics_view_source
ON social_news_statistics_view (source_type, source_id);

CREATE OR REPLACE FUNCTION refresh_social_news_statistics()
RETURNS VOID AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY social_news_statistics_view;
    
    INSERT INTO public.social_news_statistics (
        source_type, source_id, source_name, total_items, latest_published_at, last_updated
    )
    SELECT 
        source_type, source_id, source_name, total_items, latest_published_at, last_updated
    FROM social_news_statistics_view
    ON CONFLICT (source_type, source_id) 
    DO UPDATE SET
        source_name = EXCLUDED.source_name,
        total_items = EXCLUDED.total_items,
        latest_published_at = EXCLUDED.latest_published_at,
        last_updated = EXCLUDED.last_updated;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_social_news_aggregated_stats()
RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_build_object(
        'total_items', (SELECT COUNT(*) FROM public.social_news_items),
        'total_sources', (SELECT COUNT(*) FROM public.social_news_sources WHERE is_active = true),
        'by_source_type', (
            SELECT json_object_agg(source_type, item_count)
            FROM (
                SELECT source_type, COUNT(*) as item_count
                FROM public.social_news_items
                GROUP BY source_type
            ) grouped
        ),
        'recent_items_24h', (
            SELECT COUNT(*) 
            FROM public.social_news_items 
            WHERE published_at >= NOW() - INTERVAL '24 hours'
        ),
        'last_updated', NOW()
    ) INTO result;
    
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Set up Row Level Security (optional, commented out by default)
-- ALTER TABLE public.social_news_sources ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE public.social_news_items ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE public.social_news_scheduler_config ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE public.social_news_statistics ENABLE ROW LEVEL SECURITY;

GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO anon, authenticated;

GRANT ALL ON storage.objects TO anon, authenticated;
GRANT ALL ON storage.buckets TO anon, authenticated; 