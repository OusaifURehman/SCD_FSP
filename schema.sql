-- CLEANUP (Run this first to reset)
drop trigger if exists on_auth_user_created on auth.users;
drop function if exists public.handle_new_user();
drop table if exists public.cis_profiles;
drop table if exists public.cis_firs;
drop table if exists public.cis_officers;

-- EXTENSION
create extension if not exists "uuid-ossp";

-- 1. PROFILES TABLE
create table public.cis_profiles (
  id uuid references auth.users not null primary key,
  email text,
  first_name text,
  last_name text,
  phone text,
  cnic text,
  age int,
  address text,
  gender text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- RLS for Profiles
alter table public.cis_profiles enable row level security;

create policy "Public profiles are viewable by everyone." 
  on public.cis_profiles for select using ( true );

create policy "Users can update own profile." 
  on public.cis_profiles for update using ( auth.uid() = id );

-- 2. TRIGGER FUNCTION (The Magic Part)
create or replace function public.handle_new_user() 
returns trigger as $$
begin
  insert into public.cis_profiles (
    id, 
    email, 
    first_name, 
    last_name, 
    phone, 
    cnic, 
    age, 
    address, 
    gender
  )
  values (
    new.id, 
    new.email, 
    new.raw_user_meta_data->>'firstname',
    new.raw_user_meta_data->>'lastname',
    new.raw_user_meta_data->>'phone',
    new.raw_user_meta_data->>'cnic',
    (new.raw_user_meta_data->>'age')::int,
    new.raw_user_meta_data->>'address',
    new.raw_user_meta_data->>'gender'
  );
  return new;
end;
$$ language plpgsql security definer;

-- 3. TRIGGER DEFINITION
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();


-- 4. FIRS TABLE
create table public.cis_firs (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references auth.users,
  complainant_name text not null,
  cnic text not null,
  contact text,
  address text,
  crime_type text,
  crime_location text,
  crime_date date,
  crime_time time,
  description text,
  suspect_name text,
  evidence_details text, 
  status text default 'Pending',
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- RLS for FIRs
alter table public.cis_firs enable row level security;

create policy "FIRs are viewable by everyone." 
  on public.cis_firs for select using ( true );

create policy "Anyone can create an FIR." 
  on public.cis_firs for insert with check ( true ); 

-- 5. OFFICERS TABLE
create table public.cis_officers (
  id uuid default uuid_generate_v4() primary key,
  name text not null,
  rank text,
  department text,
  experience_years int,
  contact_email text,
  image_url text, 
  bio text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- RLS for Officers
alter table public.cis_officers enable row level security;

create policy "Officers are viewable by everyone." 
  on public.cis_officers for select using ( true );

-- Insert Data for Officers (Example Data)
insert into public.cis_officers (name, rank, department, experience_years, contact_email, bio, image_url)
values 
('Ahmed Khan', 'Inspector', 'Homicide', 12, 'ahmed.khan@crime.gov', 'Expert in homicide cases with 12 years experience.', 'officer1.jpg'),
('Sara Ali', 'Sub-Inspector', 'Cyber Crime', 8, 'sara.ali@crime.gov', 'Specialist in digital forensics.', 'officer2.jfif'),
('Bilal Raza', 'Forensic Expert', 'Forensics', 10, 'bilal.raza@crime.gov', 'DNA and chemical analysis expert.', 'officer3.jpg');
