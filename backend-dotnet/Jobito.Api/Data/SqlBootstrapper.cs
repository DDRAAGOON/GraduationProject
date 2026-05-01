using Microsoft.EntityFrameworkCore;

namespace Jobito.Api.Data;

public static class SqlBootstrapper
{
    public static async Task EnsureTablesAsync(AppDbContext db)
    {
        // ─── 1. CREATE tables if they don't exist (full correct schema) ───
        const string createSql = """
IF OBJECT_ID(N'[Users]', N'U') IS NULL
BEGIN
    CREATE TABLE [Users](
        [Id]        INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [Email]     NVARCHAR(256)     NOT NULL,
        [Password]  NVARCHAR(128)     NOT NULL DEFAULT '',
        [Role]      NVARCHAR(32)      NOT NULL DEFAULT 'user',
        [Name]      NVARCHAR(128)     NOT NULL DEFAULT '',
        [GoogleId]  NVARCHAR(256)     NULL,
        [PhotoUrl]  NVARCHAR(MAX)     NULL
    );
    CREATE UNIQUE INDEX [IX_Users_Email] ON [Users]([Email]);
END;

IF OBJECT_ID(N'[Jobs]', N'U') IS NULL
BEGIN
    CREATE TABLE [Jobs](
        [Id]                   NVARCHAR(64)    NOT NULL PRIMARY KEY,
        [CompanyId]            INT             NOT NULL DEFAULT 0,
        [Title]                NVARCHAR(256)   NOT NULL,
        [CompanyName]          NVARCHAR(256)   NOT NULL,
        [Location]             NVARCHAR(128)   NOT NULL DEFAULT 'Remote',
        [SalaryRange]          NVARCHAR(128)   NOT NULL DEFAULT 'Negotiable',
        [Type]                 NVARCHAR(64)    NOT NULL DEFAULT 'Full-time',
        [Description]          NVARCHAR(MAX)   NOT NULL DEFAULT '',
        [ResponsibilitiesCsv]  NVARCHAR(MAX)   NOT NULL DEFAULT '',
        [QualificationsCsv]    NVARCHAR(MAX)   NOT NULL DEFAULT '',
        [NiceToHavesCsv]       NVARCHAR(MAX)   NOT NULL DEFAULT '',
        [BenefitsCsv]          NVARCHAR(MAX)   NOT NULL DEFAULT '',
        [Category]             NVARCHAR(128)   NOT NULL DEFAULT '',
        [TagsCsv]              NVARCHAR(1000)  NOT NULL DEFAULT '',
        [CreatedAt]            DATETIME2       NOT NULL,
        [ApplicationCount]     INT             NOT NULL DEFAULT 0,
        [RequiredCount]        INT             NOT NULL DEFAULT 1,
        [AcceptedCount]        INT             NOT NULL DEFAULT 0,
        [Deadline]             DATETIME2       NULL
    );
END;

IF OBJECT_ID(N'[Applications]', N'U') IS NULL
BEGIN
    CREATE TABLE [Applications](
        [Id]        NVARCHAR(64)    NOT NULL PRIMARY KEY,
        [UserId]    INT             NOT NULL DEFAULT 0,
        [UserName]  NVARCHAR(128)   NOT NULL,
        [JobId]     NVARCHAR(64)    NOT NULL,
        [Status]    NVARCHAR(64)    NOT NULL DEFAULT 'Applied',
        [UpdatedAt] DATETIME2       NOT NULL
    );
END;

IF OBJECT_ID(N'[Messages]', N'U') IS NULL
BEGIN
    CREATE TABLE [Messages](
        [Id]          NVARCHAR(64)    NOT NULL PRIMARY KEY,
        [FromCompany] BIT             NOT NULL DEFAULT 0,
        [Text]        NVARCHAR(2000)  NOT NULL,
        [CreatedAt]   DATETIME2       NOT NULL
    );
END;

IF OBJECT_ID(N'[Notifications]', N'U') IS NULL
BEGIN
    CREATE TABLE [Notifications](
        [Id]        NVARCHAR(64)    NOT NULL PRIMARY KEY,
        [Type]      NVARCHAR(64)    NOT NULL,
        [Text]      NVARCHAR(2000)  NOT NULL,
        [CreatedAt] DATETIME2       NOT NULL
    );
END;
""";

        await db.Database.ExecuteSqlRawAsync(createSql);

        // ─── 2. ALTER existing tables to add any missing columns ───────────
        const string alterSql = """
-- Users: add missing columns
IF COL_LENGTH('Users', 'GoogleId') IS NULL
    ALTER TABLE [Users] ADD [GoogleId] NVARCHAR(256) NULL;

IF COL_LENGTH('Users', 'PhotoUrl') IS NULL
    ALTER TABLE [Users] ADD [PhotoUrl] NVARCHAR(MAX) NULL;

IF COL_LENGTH('Users', 'PhotoUrl') IS NOT NULL
    ALTER TABLE [Users] ALTER COLUMN [PhotoUrl] NVARCHAR(MAX) NULL;

-- Jobs: add missing columns
IF COL_LENGTH('Jobs', 'ApplicationCount') IS NULL
    ALTER TABLE [Jobs] ADD [ApplicationCount] INT NOT NULL DEFAULT 0;

IF COL_LENGTH('Jobs', 'RequiredCount') IS NULL
    ALTER TABLE [Jobs] ADD [RequiredCount] INT NOT NULL DEFAULT 1;

IF COL_LENGTH('Jobs', 'AcceptedCount') IS NULL
    ALTER TABLE [Jobs] ADD [AcceptedCount] INT NOT NULL DEFAULT 0;

IF COL_LENGTH('Jobs', 'Description') IS NULL
    ALTER TABLE [Jobs] ADD [Description] NVARCHAR(MAX) NOT NULL DEFAULT '';

IF COL_LENGTH('Jobs', 'ResponsibilitiesCsv') IS NULL
    ALTER TABLE [Jobs] ADD [ResponsibilitiesCsv] NVARCHAR(MAX) NOT NULL DEFAULT '';

IF COL_LENGTH('Jobs', 'QualificationsCsv') IS NULL
    ALTER TABLE [Jobs] ADD [QualificationsCsv] NVARCHAR(MAX) NOT NULL DEFAULT '';

IF COL_LENGTH('Jobs', 'NiceToHavesCsv') IS NULL
    ALTER TABLE [Jobs] ADD [NiceToHavesCsv] NVARCHAR(MAX) NOT NULL DEFAULT '';

IF COL_LENGTH('Jobs', 'BenefitsCsv') IS NULL
    ALTER TABLE [Jobs] ADD [BenefitsCsv] NVARCHAR(MAX) NOT NULL DEFAULT '';

IF COL_LENGTH('Jobs', 'Category') IS NULL
    ALTER TABLE [Jobs] ADD [Category] NVARCHAR(128) NOT NULL DEFAULT '';

IF COL_LENGTH('Jobs', 'Deadline') IS NULL
    ALTER TABLE [Jobs] ADD [Deadline] DATETIME2 NULL;
""";

        await db.Database.ExecuteSqlRawAsync(alterSql);
    }
}
