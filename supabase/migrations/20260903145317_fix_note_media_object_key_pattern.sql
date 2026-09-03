drop policy if exists "users upload own note media" on storage.objects;

create policy "users upload own note media"
on storage.objects for insert to authenticated
with check (
  bucket_id = 'note-media'
  and (storage.foldername(name))[1] = (select auth.uid())::text
  and name ~ (
    '^' || (select auth.uid())::text
    || '/[0-9a-f]{32}\.(jpe?g|png|webp)$'
  )
);
