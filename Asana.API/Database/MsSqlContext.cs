using System.Data;
using System.Data.SqlTypes;
using Asana.Library.Models;
using Microsoft.Data.SqlClient;
using Newtonsoft.Json;

namespace Asana.API.Database
{
    public class MsSqlContext
    {
        private string _connectionString;

        public MsSqlContext()
        {
            //_connectionString = $"Server=CMILLS;Database=ASANA;Trusted_Connection=True;TrustServerCertificate=True";
            _connectionString = $"Server=(local)\\SQLEXPRESS;Database=Asana;Trusted_Connection=True;TrustServerCertificate=True";
        }

        private List<ToDo> _toDos;
        public List<ToDo> ToDos
        {
            get
            {
                _toDos = new List<ToDo>();
                using (var sqlConnection = new SqlConnection(_connectionString))
                {
                    using (var sqlCmd = sqlConnection.CreateCommand())
                    {
                        sqlCmd.CommandText ="SELECT ToDoId, Title, Description, IsCompleted, Priority, ProjectId, ProjectName FROM dbo.AllToDosDetailed";
                        sqlCmd.CommandType = System.Data.CommandType.Text;

                        sqlConnection.Open();
                        var reader = sqlCmd.ExecuteReader();


                        while (reader.Read())
                        {
                            _toDos.Add(new ToDo
                            {
                                Id = (int)reader["ToDoId"],
                                Name = reader["Title"].ToString()!,
                                Description = reader["Description"]?.ToString() ?? "",
                                IsCompleted = (bool)reader["IsCompleted"],
                                Priority = (int)reader["Priority"],
                                ProjectId = (int)reader["ProjectId"]
                            });
                        }



                        sqlConnection.Close();

                        sqlCmd.Dispose();
                        sqlConnection.Dispose();
                        return _toDos;
                    }
                }

            }
        }

        public ToDo? AddOrUpdateToDo(ToDo? toDo)
        {
            if (toDo == null)
                return null;

            // Only support INSERT (when Id ≤ 0). Implement update later if needed.
            if (toDo.Id <= 0)
            {
                using var connection = new SqlConnection(_connectionString);
                using var cmd = connection.CreateCommand();
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "ToDo.[Insert]";

                // must supply all five parameters your proc expects:
                cmd.Parameters.AddWithValue("@Name", toDo.Name);
                cmd.Parameters.AddWithValue("@Description", toDo.Description);
                cmd.Parameters.AddWithValue("@IsCompleted", toDo.IsCompleted);
                cmd.Parameters.AddWithValue("@Priority", toDo.Priority);
                cmd.Parameters.AddWithValue("@ProjectId", toDo.ProjectId);

                connection.Open();
                var newId = Convert.ToInt32(cmd.ExecuteScalar() ?? 0);
                toDo.Id = newId;
            }

            return toDo;
        }





        public int DeleteToDo(int toDoId)
        {
            using (var connection = new SqlConnection(_connectionString))
            {
                using (var cmd = connection.CreateCommand())
                {
                    //update command
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.CommandText = "[ToDo].[Delete]";
                    cmd.Parameters.Add(new SqlParameter("@id", toDoId));

                    connection.Open();
                    var result = cmd.ExecuteScalar();
                }
            }

            return toDoId;
        }
    }
}
