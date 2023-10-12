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
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dotnetconsulting.AlwaysEncrypted
{
    class Program
    {
        static void Main(string[] args)
        {
            // Dieses einfache Beispielt zeigt wie das ab SQL Server 2016 und ADO.NET 4.
            // neue Always Encryted Feature von Code Seite aus benutzt wird.
            // Alle auf ADO.NET basierenden Technologien (EntityFramework, etc.)
            // können von diesem Feature verwenden

            Console.WriteLine("(c) dotnetconsulting by Thorsten Kansy");
            string sqlConString = dotnetconsulting.AlwaysEncrypted.Properties.Settings.Default.ConString;
            Console.WriteLine("sqlConString = {0}", sqlConString);

            createData(sqlConString);
            updateData(sqlConString);
            readData(sqlConString);

            Console.WriteLine("== Fertig ==");
            Console.ReadKey();
        }

        static void createData(string conString)
        {
            Console.WriteLine("createData");
            using (SqlConnection con = new SqlConnection(conString))
            {
                con.Open();

                using (SqlCommand cmd = con.CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = @"INSERT [dbo].[Secrets]([User], [Secret], [Unwichtig]) 
                                        VALUES(@User, @Secret, @Unwichtig);";
                    cmd.Parameters.Add("User", SqlDbType.NVarChar, 50);
                    cmd.Parameters.Add("Secret", SqlDbType.NVarChar, 50);
                    cmd.Parameters.Add("Unwichtig", SqlDbType.NVarChar, 100);

                    cmd.Prepare();

                    // Ein paar Zeilen einfügen
                    for (int i = 0; i < 10; i++)
                    {
                        cmd.Parameters["User"].Value = string.Format("User:{0}", i);
                        cmd.Parameters["Secret"].Value = string.Format("Secret:{0}", i);
                        cmd.Parameters["Unwichtig"].Value = string.Format("Unwichtig:{0}", i);

                        cmd.ExecuteNonQuery();
                    }
                }
            }
        }

        static void updateData(string conString)
        {
            Console.WriteLine("updateData");
            using (SqlConnection con = new SqlConnection(conString))
            {
                con.Open();

                using (SqlCommand cmd = con.CreateCommand())
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = 
                        "UPDATE [dbo].[Secrets] SET [User] = @newUser WHERE [User]=@oldUser;";

                    cmd.Parameters.AddWithValue("oldUser", "User:0");
                    cmd.Parameters.AddWithValue("newUser", "Thorsten Kansy");
                    cmd.ExecuteNonQuery();
                }
            }
        }

        static void readData(string conString)
        {
            Console.WriteLine("readData");
            using (SqlConnection con = new SqlConnection(conString))
            {
                con.Open();

                using (SqlCommand cmd = con.CreateCommand())
                {
                    cmd.CommandType = System.Data.CommandType.Text;
                    cmd.CommandText = "SELECT [User], [Secret], [Unwichtig] FROM [dbo].[Secrets];";

                    using (SqlDataReader dr = cmd.ExecuteReader(CommandBehavior.SequentialAccess))
                    {
                        while (dr.Read())
                        {
                            string user = dr.GetString(0);
                            string secret = dr.GetString(1);
                            string unwichtig = dr.GetString(2);

                            Console.WriteLine("user={0} / secret={1}, / unwichtig={2}", user, secret, unwichtig);
                        }
                    }
                }
            }
        }
    }
}