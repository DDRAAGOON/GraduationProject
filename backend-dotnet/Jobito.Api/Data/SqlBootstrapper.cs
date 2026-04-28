using Microsoft.EntityFrameworkCore;

namespace Jobito.Api.Data;

public static class SqlBootstrapper
{
    public static async Task EnsureTablesAsync(AppDbContext db)
    {
        const string sql = """
IF OBJECT_ID(N'[Users]', N'U') IS NULL
BEGIN
    CREATE TABLE [Users](
        [Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [Email] NVARCHAR(256) NOT NULL,
        [Password] NVARCHAR(128) NOT NULL,
        [Role] NVARCHAR(32) NOT NULL,
        [Name] NVARCHAR(128) NOT NULL
    );
    CREATE UNIQUE INDEX [IX_Users_Email] ON [Users]([Email]);
END;

IF OBJECT_ID(N'[Jobs]', N'U') IS NULL
BEGIN
    CREATE TABLE [Jobs](
        [Id] NVARCHAR(64) NOT NULL PRIMARY KEY,
        [CompanyId] INT NOT NULL,
        [Title] NVARCHAR(256) NOT NULL,
        [CompanyName] NVARCHAR(256) NOT NULL,
        [Location] NVARCHAR(128) NOT NULL,
        [SalaryRange] NVARCHAR(128) NOT NULL,
        [Type] NVARCHAR(64) NOT NULL,
        [Description] NVARCHAR(MAX) NOT NULL DEFAULT '',
        [ResponsibilitiesCsv] NVARCHAR(MAX) NOT NULL DEFAULT '',
        [QualificationsCsv] NVARCHAR(MAX) NOT NULL DEFAULT '',
        [NiceToHavesCsv] NVARCHAR(MAX) NOT NULL DEFAULT '',
        [BenefitsCsv] NVARCHAR(MAX) NOT NULL DEFAULT '',
        [Category] NVARCHAR(128) NOT NULL DEFAULT '',
        [TagsCsv] NVARCHAR(1000) NOT NULL,
        [CreatedAt] DATETIME2 NOT NULL
    );
END;

IF OBJECT_ID(N'[Applications]', N'U') IS NULL
BEGIN
    CREATE TABLE [Applications](
        [Id] NVARCHAR(64) NOT NULL PRIMARY KEY,
        [UserId] INT NOT NULL,
        [UserName] NVARCHAR(128) NOT NULL,
        [JobId] NVARCHAR(64) NOT NULL,
        [Status] NVARCHAR(64) NOT NULL,
        [UpdatedAt] DATETIME2 NOT NULL
    );
END;

IF OBJECT_ID(N'[Messages]', N'U') IS NULL
BEGIN
    CREATE TABLE [Messages](
        [Id] NVARCHAR(64) NOT NULL PRIMARY KEY,
        [FromCompany] BIT NOT NULL,
        [Text] NVARCHAR(2000) NOT NULL,
        [CreatedAt] DATETIME2 NOT NULL
    );
END;

IF OBJECT_ID(N'[Notifications]', N'U') IS NULL
BEGIN
    CREATE TABLE [Notifications](
        [Id] NVARCHAR(64) NOT NULL PRIMARY KEY,
        [Type] NVARCHAR(64) NOT NULL,
        [Text] NVARCHAR(2000) NOT NULL,
        [CreatedAt] DATETIME2 NOT NULL
    );
END;
""";

        await db.Database.ExecuteSqlRawAsync(sql);
    }
}
