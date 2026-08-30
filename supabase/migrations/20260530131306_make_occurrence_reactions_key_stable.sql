alter table core.schedule_occurrence_reactions
drop constraint if exists schedule_occurrence_reactions_occurrence_id_fkey;

alter table core.schedule_occurrence_reactions
drop constraint if exists schedule_occurrence_reactions_unique_user;

alter table core.schedule_occurrence_reactions
add column institution_id text references core.institutions(id) on delete cascade,
add column occurrence_key text;

update core.schedule_occurrence_reactions reaction
set
  institution_id = occurrence.institution_id,
  occurrence_key = occurrence.occurrence_key
from core.schedule_occurrences occurrence
where occurrence.id = reaction.occurrence_id;

alter table core.schedule_occurrence_reactions
alter column occurrence_id drop not null,
alter column institution_id set not null,
alter column occurrence_key set not null;

alter table core.schedule_occurrence_reactions
add constraint schedule_occurrence_reactions_occurrence_fkey
foreign key (occurrence_id)
references core.schedule_occurrences(id)
on delete set null;

alter table core.schedule_occurrence_reactions
add constraint schedule_occurrence_reactions_unique_user_key
unique (user_id, institution_id, occurrence_key);

create index schedule_occurrence_reactions_key_idx
on core.schedule_occurrence_reactions (institution_id, occurrence_key);
