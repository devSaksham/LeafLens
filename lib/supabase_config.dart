class SupabaseConfig {
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://hmztqyypqvycuoduwvnz.supabase.co',
  );

  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhtenRxeXlwcXZ5Y3VvZHV3dm56Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQ5MDE4MTYsImV4cCI6MjEwMDQ3NzgxNn0.fHFTkFR5BkTs2S7xNON3OBM2-FmRPL_FtqnOdgcf740',
  );
}
