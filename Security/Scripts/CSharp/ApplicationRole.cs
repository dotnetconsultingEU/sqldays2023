// Disclaimer
// Dieser Quellcode ist als Vorlage oder als Ideengeber gedacht. Er kann frei und ohne 
// Auflagen oder Einschränkungen verwendet oder verändert werden.
// Jedoch wird keine Garantie übernommen, das eine Funktionsfähigkeit mit aktuellen und 
// zukünftigen API-Versionen besteht. Der Autor übernimmt daher keine direkte oder indirekte 
// Verantwortung, wenn dieser Code gar nicht oder nur fehlerhaft ausgeführt wird.
// Für Anregungen und Fragen stehe ich jedoch gerne zur Verfügung.
// Thorsten Kansy, www.dotnetconsulting.eu

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data;

namespace DataTable_To_SQLServer
{
    class ApplicationRole
    {
        private const string AppRoleName = "MyAppRole";
        private const string AppRolePassword = "Pa$$w0rd";

        /// <summary>
        /// Aktiviert die Anwedungsrolle für die übergebene Verbindung.
        /// </summary>
        /// <param name="cn">Das gültige SqlConnection-Objekt.</param>
        /// <returns>Cookie für das zurücksetzen der Anwendungsrolle.</returns>
        private static object setAppRole(SqlConnection cn)
        {
            // Parameter prüfen
            if (cn == null)
                throw new ArgumentNullException("cn");

            if (cn.State != ConnectionState.Open)
                throw new InvalidOperationException("cn.State != Open");

            // SqlCommand-Objekt erzeugen
            using (SqlCommand cmdSetAppRole = new SqlCommand("sp_setapprole", cn) { CommandType = CommandType.StoredProcedure })
            {
                // Parameter übergeben
                cmdSetAppRole.Parameters.AddWithValue("rolename", AppRoleName);
                cmdSetAppRole.Parameters.AddWithValue("password", AppRolePassword);
                cmdSetAppRole.Parameters.AddWithValue("fCreateCookie", true);

                // Rückgabewert
                SqlParameter paramCookie = new SqlParameter("@cookie", SqlDbType.VarBinary) { Size = 8000, Direction = ParameterDirection.Output };

                cmdSetAppRole.Parameters.Add(paramCookie);

                // SqlCommand ausführen
                cmdSetAppRole.ExecuteNonQuery();

                // Cookie zurückgeben
                return paramCookie.Value;
            }
        }

        /// <summary>
        /// Deaktivert die Anwendungsrolle für die übergeben Verbindung.
        /// </summary>
        /// <param name="cn">Das gültige SqlConnection-Objekt.</param>
        /// <param name="cookie">Der Cookie-Wert des setAppRole()-Aufrufes.</param>
        /// <param name="closeConnection">Soll die Verbindung am Ende geschlossen werden?</param>
        /// <return>-</return>
        private static void unsetAppRole(SqlConnection cn, object cookie, bool closeConnection = false)
        {
            // Parameter prüfen
            if (cn == null)
                throw new ArgumentNullException("cn");

            if (cn.State != ConnectionState.Open)
                throw new InvalidOperationException("cn.State != Open");

            // Wurde ein Cookie übergeben?
            if (cookie != null)
                // SqlCommand-Objekt erzeugen
                using (SqlCommand cmdUnsetAppRole = new SqlCommand("sp_unsetapprole", cn) { CommandType = CommandType.StoredProcedure })
                {
                    // Parameter übergeben
                    SqlParameter paramCookieUnset = new SqlParameter("cookie", SqlDbType.VarBinary) { Size = 8000, Value = cookie };

                    cmdUnsetAppRole.Parameters.Add(paramCookieUnset);

                    // Ausführen
                    cmdUnsetAppRole.ExecuteNonQuery();
                }

            // Verbindung schließen?
            if (closeConnection)
                cn.Close();
        }
    }
}