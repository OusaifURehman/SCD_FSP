-- Run this in Supabase SQL Editor to manually confirm all users
-- This allows you to login even if you haven't clicked the email link

BEGIN;
  -- Update all users who haven't confirmed their email
  UPDATE auth.users
  SET email_confirmed_at = now()
  WHERE email_confirmed_at IS NULL;
COMMIT;

-- Verify it worked
SELECT email, email_confirmed_at FROM auth.users;
