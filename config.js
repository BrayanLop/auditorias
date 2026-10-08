// Datos del proyecto de Supabase (Project Settings → API).
// La "anon public key" está pensada para ir en el navegador: la seguridad la dan las
// políticas RLS de supabase/schema.sql, que exigen sesión iniciada. Nunca pongas aquí la "service_role key".
window.AUDITORIAS_CONFIG = {
  supabaseUrl: 'https://TU-PROYECTO.supabase.co',
  supabaseAnonKey: 'TU_ANON_PUBLIC_KEY',
};
