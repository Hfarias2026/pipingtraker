-- ============================================================
-- PIPING TRACKER — Schema SQL para Supabase
-- Ejecutar en: Supabase Dashboard → SQL Editor → New Query
-- ============================================================

-- 1. PROYECTOS
create table if not exists projects (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  description text,
  client      text,
  location    text,
  start_date  date,
  end_date    date,
  status      text default 'activo' check (status in ('activo','completado','pausado')),
  created_at  timestamptz default now(),
  updated_at  timestamptz default now()
);

-- 2. SOLDADORES
create table if not exists welders (
  id                   uuid primary key default gen_random_uuid(),
  welder_number        text not null,
  full_name            text,
  certification        text,
  certificate_url      text,
  certification_expiry date,
  process              text check (process in ('SMAW','GTAW','GMAW','FCAW','SAW','OTRO')),
  active               boolean default true,
  created_at           timestamptz default now(),
  updated_at           timestamptz default now()
);

-- 3. LÍNEAS DE CAÑERÍA
create table if not exists piping_lines (
  id                   uuid primary key default gen_random_uuid(),
  project_id           uuid references projects(id) on delete set null,
  line_number          text not null,
  isometric_number     text,
  revision             text,
  diameter             text,
  schedule             text,
  material             text,
  fluid                text,
  design_pressure      text,
  design_temperature   text,
  welding_procedure    text,
  area                 text,
  joint_count          integer,
  isometric_pdf_url    text,
  notes                text,
  status               text default 'pendiente' check (status in ('pendiente','en_proceso','aprobado','rechazado')),
  created_at           timestamptz default now(),
  updated_at           timestamptz default now()
);

-- 4. JUNTAS DE SOLDADURA (con 7 ensayos NDT)
create table if not exists welds (
  id             uuid primary key default gen_random_uuid(),
  line_id        uuid not null references piping_lines(id) on delete cascade,
  weld_number    text not null,
  welder_id      uuid references welders(id) on delete set null,
  welder_number  text,

  -- NDT 1: Inspección Visual
  ndt_visual        text default 'pendiente' check (ndt_visual in ('pendiente','en_proceso','aprobado','rechazado','no_aplica')),
  ndt_visual_date   date,
  ndt_visual_report text,

  -- NDT 2: Gammagrafía
  ndt_gammagrafia        text default 'pendiente' check (ndt_gammagrafia in ('pendiente','en_proceso','aprobado','rechazado','no_aplica')),
  ndt_gammagrafia_date   date,
  ndt_gammagrafia_report text,

  -- NDT 3: Líquidos Penetrantes
  ndt_liquidos        text default 'pendiente' check (ndt_liquidos in ('pendiente','en_proceso','aprobado','rechazado','no_aplica')),
  ndt_liquidos_date   date,
  ndt_liquidos_report text,

  -- NDT 4: Tratamiento Térmico
  ndt_termico        text default 'pendiente' check (ndt_termico in ('pendiente','en_proceso','aprobado','rechazado','no_aplica')),
  ndt_termico_date   date,
  ndt_termico_report text,

  -- NDT 5: Dureza
  ndt_dureza        text default 'pendiente' check (ndt_dureza in ('pendiente','en_proceso','aprobado','rechazado','no_aplica')),
  ndt_dureza_date   date,
  ndt_dureza_report text,

  -- NDT 6: Prueba Hidráulica
  ndt_hidraulica        text default 'pendiente' check (ndt_hidraulica in ('pendiente','en_proceso','aprobado','rechazado','no_aplica')),
  ndt_hidraulica_date   date,
  ndt_hidraulica_report text,

  -- NDT 7: Barrido
  ndt_barrido        text default 'pendiente' check (ndt_barrido in ('pendiente','en_proceso','aprobado','rechazado','no_aplica')),
  ndt_barrido_date   date,
  ndt_barrido_report text,

  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- ─── ÍNDICES ────────────────────────────────────────────────────────────────
create index if not exists idx_welds_line_id on welds(line_id);
create index if not exists idx_piping_lines_project_id on piping_lines(project_id);

-- ─── STORAGE BUCKET para PDFs ───────────────────────────────────────────────
-- Ejecutar también en SQL Editor:
insert into storage.buckets (id, name, public)
values ('reports', 'reports', true)
on conflict do nothing;

-- Política: acceso público de lectura
create policy "Public read reports"
  on storage.objects for select
  using (bucket_id = 'reports');

-- Política: cualquier usuario autenticado puede subir
create policy "Auth upload reports"
  on storage.objects for insert
  with check (bucket_id = 'reports');

-- ─── RLS (Row Level Security) — OPCIONAL ────────────────────────────────────
-- Si querés que la app sea pública (sin login), dejá el RLS desactivado.
-- Si querés requerir login, activá RLS y configurá las políticas aquí.
-- alter table projects      enable row level security;
-- alter table welders       enable row level security;
-- alter table piping_lines  enable row level security;
-- alter table welds         enable row level security;
