create table if not exists public.app_state (
  id smallint primary key default 1 check (id = 1),
  public_state jsonb not null default '{"acolytes":[],"schedules":[],"rotationHistory":[]}'::jsonb,
  initialized boolean not null default false,
  updated_at timestamptz not null default now()
);

create table if not exists public.acolyte_contacts (
  acolyte_id text primary key,
  phone text not null default ''
);

alter table public.app_state enable row level security;
alter table public.acolyte_contacts enable row level security;

grant usage on schema public to anon, authenticated;
revoke all on public.app_state from public, anon, authenticated;
revoke all on public.acolyte_contacts from public, anon, authenticated;

grant select on public.app_state to anon, authenticated;
grant insert, update on public.app_state to authenticated;
grant select, insert, update, delete on public.acolyte_contacts to authenticated;

drop policy if exists "Public can read shared schedules" on public.app_state;
create policy "Public can read shared schedules"
  on public.app_state for select to anon, authenticated
  using (true);

drop policy if exists "Administrator can create shared state" on public.app_state;
create policy "Administrator can create shared state"
  on public.app_state for insert to authenticated
  with check ((auth.jwt() ->> 'email') = 'acolitossaofrancisco@gmail.com');

drop policy if exists "Administrator can update shared state" on public.app_state;
create policy "Administrator can update shared state"
  on public.app_state for update to authenticated
  using ((auth.jwt() ->> 'email') = 'acolitossaofrancisco@gmail.com')
  with check ((auth.jwt() ->> 'email') = 'acolitossaofrancisco@gmail.com');

drop policy if exists "Administrator can manage acolyte contacts" on public.acolyte_contacts;
create policy "Administrator can manage acolyte contacts"
  on public.acolyte_contacts for all to authenticated
  using ((auth.jwt() ->> 'email') = 'acolitossaofrancisco@gmail.com')
  with check ((auth.jwt() ->> 'email') = 'acolitossaofrancisco@gmail.com');

insert into public.app_state (id)
values (1)
on conflict (id) do nothing;

do $$
begin
  if not exists (
    select 1
    from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'app_state'
  ) then
    alter publication supabase_realtime add table public.app_state;
  end if;
end
$$;
