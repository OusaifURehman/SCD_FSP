
// Initialize Supabase Client
// We assume the supabase-js library is loaded via CDN in the HTML file
const SUPABASE_URL = 'https://ffaioupyrwvrnkcvpwjb.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZmYWlvdXB5cnd2cm5rY3Zwd2piIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUxODUyNzYsImV4cCI6MjA4MDc2MTI3Nn0.78bFyXxwClhSTa07K0odou-h7fHhUs3FvAKXFSEhQxU';

// Attach to window to ensure global availability across other scripts
window.supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_KEY);

console.log("Supabase Client Initialized");
