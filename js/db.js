
window.db = {
    // Generic Fetch (Read)
    async fetchTable(tableName, selectQuery = '*') {
        const { data, error } = await window.supabaseClient
            .from(tableName)
            .select(selectQuery);

        if (error) {
            console.error(`Error fetching ${tableName}:`, error);
            return null;
        }
        return data;
    },

    // Generic Insert (Create)
    async insertRow(tableName, rowData) {
        const { data, error } = await window.supabaseClient
            .from(tableName)
            .insert([rowData])
            .select();

        if (error) {
            console.error(`Error inserting into ${tableName}:`, error);
            return { error };
        }
        return { data };
    },

    // Generic Update
    async updateRow(tableName, id, updates) {
        const { data, error } = await window.supabaseClient
            .from(tableName)
            .update(updates)
            .eq('id', id)
            .select();

        if (error) {
            console.error(`Error updating ${tableName}:`, error);
            return { error };
        }
        return { data };
    },

    // Generic Delete
    async deleteRow(tableName, id) {
        const { error } = await window.supabaseClient
            .from(tableName)
            .delete()
            .eq('id', id);

        if (error) {
            console.error(`Error deleting from ${tableName}:`, error);
            return { error };
        }
        return { success: true };
    }
};
