create index if not exists organizations_parent_id_idx
on core.organizations (parent_id)
where parent_id is not null;
