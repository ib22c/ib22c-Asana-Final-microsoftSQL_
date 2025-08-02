USE [master]
GO
/****** Object:  Database [Asana]    Script Date: 8/1/2025 7:50:18 PM ******/
CREATE DATABASE [Asana]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Asana', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Asana.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Asana_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Asana_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [Asana] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Asana].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Asana] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Asana] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Asana] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Asana] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Asana] SET ARITHABORT OFF 
GO
ALTER DATABASE [Asana] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Asana] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Asana] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Asana] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Asana] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Asana] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Asana] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Asana] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Asana] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Asana] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Asana] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Asana] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Asana] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Asana] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Asana] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Asana] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Asana] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Asana] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Asana] SET  MULTI_USER 
GO
ALTER DATABASE [Asana] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Asana] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Asana] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Asana] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Asana] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Asana] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Asana] SET QUERY_STORE = ON
GO
ALTER DATABASE [Asana] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [Asana]
GO
/****** Object:  Schema [ToDo]    Script Date: 8/1/2025 7:50:18 PM ******/
CREATE SCHEMA [ToDo]
GO
/****** Object:  Table [dbo].[Projects]    Script Date: 8/1/2025 7:50:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Projects](
	[ProjectId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ToDos]    Script Date: 8/1/2025 7:50:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ToDos](
	[ToDoId] [int] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](255) NOT NULL,
	[Description] [varchar](max) NULL,
	[IsCompleted] [bit] NOT NULL,
	[Priority] [int] NOT NULL,
	[ProjectId] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ToDoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [ToDo].[View]    Script Date: 8/1/2025 7:50:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 2.2 Custom view your code is calling
CREATE VIEW [ToDo].[View] AS
SELECT
  t.ToDoId       AS id,
  t.Title        AS name,
  /* t.Description, */      -- uncomment if you added Description above
  /* t.Priority, */         -- uncomment if you added Priority above
  /* t.IsCompleted, */      -- uncomment if you added IsCompleted above
  t.ProjectId,
  p.Name        AS projectName
FROM dbo.ToDos    AS t
JOIN dbo.Projects AS p
  ON t.ProjectId = p.ProjectId;
GO
/****** Object:  View [dbo].[AllToDosDetailed]    Script Date: 8/1/2025 7:50:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 2) Flattened view
CREATE VIEW [dbo].[AllToDosDetailed] AS
SELECT
  t.ToDoId,
  t.Title,
  t.Description,
  t.IsCompleted,
  t.Priority,
  t.ProjectId,
  p.Name AS ProjectName
FROM dbo.ToDos t
JOIN dbo.Projects p ON t.ProjectId = p.ProjectId;
GO
ALTER TABLE [dbo].[ToDos] ADD  DEFAULT ((0)) FOR [IsCompleted]
GO
ALTER TABLE [dbo].[ToDos] ADD  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[ToDos]  WITH CHECK ADD  CONSTRAINT [FK_ToDos_Project] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([ProjectId])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ToDos] CHECK CONSTRAINT [FK_ToDos_Project]
GO
/****** Object:  StoredProcedure [dbo].[spDeleteProject]    Script Date: 8/1/2025 7:50:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spDeleteProject] @ProjectId INT AS
BEGIN
  SET NOCOUNT ON;
  DELETE FROM dbo.Projects WHERE ProjectId=@ProjectId;
END;
GO
/****** Object:  StoredProcedure [dbo].[spDeleteToDo]    Script Date: 8/1/2025 7:50:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spDeleteToDo] @ToDoId INT AS
BEGIN
  SET NOCOUNT ON;
  DELETE FROM dbo.ToDos WHERE ToDoId=@ToDoId;
END;
GO
/****** Object:  StoredProcedure [dbo].[spGetAllToDos]    Script Date: 8/1/2025 7:50:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 4) ToDo procs
CREATE PROCEDURE [dbo].[spGetAllToDos] AS
BEGIN
  SET NOCOUNT ON;
  SELECT ToDoId, Title, Description, IsCompleted, Priority, ProjectId, ProjectName
    FROM dbo.AllToDosDetailed;
END;
GO
/****** Object:  StoredProcedure [dbo].[spGetProjects]    Script Date: 8/1/2025 7:50:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 3) Project procs
CREATE PROCEDURE [dbo].[spGetProjects] AS
BEGIN
  SET NOCOUNT ON;
  SELECT ProjectId, Name FROM dbo.Projects;
END;
GO
/****** Object:  StoredProcedure [dbo].[spInsertProject]    Script Date: 8/1/2025 7:50:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spInsertProject] @Name VARCHAR(100) AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO dbo.Projects (Name) VALUES (@Name);
  SELECT SCOPE_IDENTITY() AS NewProjectId;
END;
GO
/****** Object:  StoredProcedure [dbo].[spInsertToDo]    Script Date: 8/1/2025 7:50:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Create the new insert proc
CREATE PROCEDURE [dbo].[spInsertToDo]
  @Title     VARCHAR(255),
  @ProjectId INT
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO dbo.ToDos (Title, ProjectId)
  VALUES (@Title, @ProjectId);

  -- Return the newly generated ID
  SELECT SCOPE_IDENTITY() AS NewToDoId;
END;
GO
/****** Object:  StoredProcedure [ToDo].[Delete]    Script Date: 8/1/2025 7:50:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 5) Create the Delete proc in ToDo schema
CREATE PROCEDURE [ToDo].[Delete]
  @Id INT
AS
BEGIN
  SET NOCOUNT ON;
  DELETE FROM dbo.ToDos
   WHERE ToDoId = @Id;
END;
GO
/****** Object:  StoredProcedure [ToDo].[Insert]    Script Date: 8/1/2025 7:50:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 3) Create the new Insert proc with exactly 5 parameters
CREATE PROCEDURE [ToDo].[Insert]
  @Name        VARCHAR(255),
  @Description VARCHAR(MAX),
  @IsCompleted BIT,
  @Priority    INT,
  @ProjectId   INT
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO dbo.ToDos
    (Title, Description, IsCompleted, Priority, ProjectId)
  VALUES
    (@Name, @Description, @IsCompleted, @Priority, @ProjectId);

  -- return the new identity
  SELECT SCOPE_IDENTITY() AS NewToDoId;
END;
GO
/****** Object:  StoredProcedure [ToDo].[Update]    Script Date: 8/1/2025 7:50:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- 4) (Optional) Create an Update proc in ToDo schema
--    you can wire this up later if you need full AddOrUpdate
CREATE PROCEDURE [ToDo].[Update]
  @Id         INT,
  @Name       VARCHAR(255),
  @ProjectId  INT,
  @IsCompleted BIT,
  @Priority    INT
AS
BEGIN
  SET NOCOUNT ON;

  UPDATE dbo.ToDos
    SET Title       = @Name,
        ProjectId   = @ProjectId,
        IsCompleted = @IsCompleted,
        Priority    = @Priority
  WHERE ToDoId = @Id;
END;
GO
USE [master]
GO
ALTER DATABASE [Asana] SET  READ_WRITE 
GO
