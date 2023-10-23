namespace API
{
    public class Settings
    {
        /// <summary>
        /// String de conexão com o Postgre
        /// </summary>
        public static string PostgreSQLConnectionString => Environment.GetEnvironmentVariable("POSTGRE_CONNECTION_STRING");
    }
}
