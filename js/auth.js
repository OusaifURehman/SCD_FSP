
window.auth = {
    // Sign Up
    async signUp(email, password, userDetails) {
        // We pass userDetails as 'options.data' so the Postgres Trigger can access them
        // and create the cis_profiles row automatically.
        const { data, error } = await window.supabaseClient.auth.signUp({
            email: email,
            password: password,
            options: {
                data: {
                    firstname: userDetails.firstname,
                    lastname: userDetails.lastname,
                    phone: userDetails.phone,
                    cnic: userDetails.cnic,
                    age: userDetails.age,
                    address: userDetails.address,
                    gender: userDetails.gender
                }
            }
        });

        if (error) {
            console.error('Error signing up:', error);
            return { error };
        }

        // Success! The database trigger handled the profile creation.
        return { data };
    },

    // Sign In
    async signIn(email, password) {
        const { data, error } = await window.supabaseClient.auth.signInWithPassword({
            email: email,
            password: password,
        });

        if (error) {
            console.error('Error signing in:', error);
            return { error };
        }

        return { data };
    },

    // Sign Out
    async signOut() {
        const { error } = await window.supabaseClient.auth.signOut();
        if (error) {
            console.error('Error signing out:', error);
            return { error };
        }
        return { success: true };
    },

    // Get Current User
    async getCurrentUser() {
        // Safer check
        if (!window.supabaseClient) return null;
        const { data: { session } } = await window.supabaseClient.auth.getSession();
        if (!session) return null;
        return session.user;
    },

    // Check Session & Redirect
    async checkSession(protectedPage = true) {
        if (!window.supabaseClient) return;

        const { data: { session } } = await window.supabaseClient.auth.getSession();

        if (protectedPage) {
            // If page is protected and NO session, go to login
            if (!session) {
                window.location.href = 'index.html';
            }
        } else {
            // If login page and YES session, go to main
            if (session) {
                window.location.href = 'main.html';
            }
        }
    }
};
