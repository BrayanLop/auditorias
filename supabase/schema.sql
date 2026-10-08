-- Esquema de la base de datos del dashboard de auditorías.
-- Ejecutar una sola vez en Supabase → SQL Editor. Se puede volver a ejecutar sin problema.

create table if not exists public.auditorias (
  -- Identificador estable calculado a partir del contenido del registro (no del número de fila),
  -- para que las ediciones no se pierdan al recargar un Excel renombrado o reordenado.
  id                    text primary key,
  canal                 text not null,
  area                  text not null,
  persona               text not null,
  cliente               text,
  fecha                 date not null,
  criterios             jsonb not null,               -- [{ "name": "...", "val": 0 | 1 }]
  criterios_incumplidos text[] not null default '{}',
  hallazgo              boolean not null,
  retro_realizada       boolean not null default false,
  observacion           text,
  retroalimentacion     text,
  severidad             text not null default 'leve' check (severidad in ('leve', 'moderado', 'grave')),
  archivo_origen        text,
  creado_en             timestamptz not null default now(),
  actualizado_en        timestamptz not null default now(),
  actualizado_por       text
);

create index if not exists ix_auditorias_fecha   on public.auditorias (fecha);
create index if not exists ix_auditorias_persona on public.auditorias (persona);

-- Fecha y usuario de la última modificación
create or replace function public.auditorias_auditar()
returns trigger
language plpgsql
as $$
begin
  new.actualizado_en := now();
  new.actualizado_por := coalesce(auth.jwt() ->> 'email', new.actualizado_por);
  return new;
end;
$$;

drop trigger if exists tr_auditorias_auditar on public.auditorias;
create trigger tr_auditorias_auditar
  before insert or update on public.auditorias
  for each row execute function public.auditorias_auditar();

-- Seguridad: solo usuarios con sesión iniciada pueden leer y escribir.
-- Sin estas políticas cualquiera con la URL y la clave pública podría ver los datos.
alter table public.auditorias enable row level security;

drop policy if exists "auditorias_leer"       on public.auditorias;
drop policy if exists "auditorias_insertar"   on public.auditorias;
drop policy if exists "auditorias_actualizar" on public.auditorias;

create policy "auditorias_leer"       on public.auditorias for select to authenticated using (true);
create policy "auditorias_insertar"   on public.auditorias for insert to authenticated with check (true);
create policy "auditorias_actualizar" on public.auditorias for update to authenticated using (true) with check (true);
-- No hay política de borrado: desde la página no se pueden eliminar registros.
