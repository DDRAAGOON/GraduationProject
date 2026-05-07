-- =====================================================================
--  Jobito - Full Schema Migration Script
--  Database : db49878.databaseasp.net  (MSSQL)
--  Run this script once; it is fully idempotent (safe to re-run).
-- =====================================================================


-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
-- TABLE: Users
-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
IF OBJECT_ID(N'[Users]', N'U') IS NULL
BEGIN
    CREATE TABLE [Users] (
        [Id]       INT           IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [Email]    NVARCHAR(256) NOT NULL,
        [Password] NVARCHAR(128) NOT NULL,
        [Role]     NVARCHAR(32)  NOT NULL,
        [Name]     NVARCHAR(128) NOT NULL,
        [GoogleId] NVARCHAR(256) NULL,
        [PhotoUrl] NVARCHAR(512) NULL
    );
    CREATE UNIQUE INDEX [IX_Users_Email] ON [Users]([Email]);
    PRINT 'TABLE [Users] created.';
END
ELSE
BEGIN
    PRINT 'TABLE [Users] already exists â€“ checking for missing columns...';

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[Users]') AND name = N'GoogleId')
    BEGIN
        ALTER TABLE [Users] ADD [GoogleId] NVARCHAR(256) NULL;
        PRINT '  + Column [GoogleId] added to [Users].';
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[Users]') AND name = N'PhotoUrl')
    BEGIN
        ALTER TABLE [Users] ADD [PhotoUrl] NVARCHAR(512) NULL;
        PRINT '  + Column [PhotoUrl] added to [Users].';
    END
END
GO


-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
-- TABLE: Jobs
-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
IF OBJECT_ID(N'[Jobs]', N'U') IS NULL
BEGIN
    CREATE TABLE [Jobs] (
        [Id]                   NVARCHAR(64)   NOT NULL PRIMARY KEY,
        [CompanyId]            INT            NOT NULL,
        [Title]                NVARCHAR(256)  NOT NULL,
        [CompanyName]          NVARCHAR(256)  NOT NULL,
        [Location]             NVARCHAR(128)  NOT NULL,
        [SalaryRange]          NVARCHAR(128)  NOT NULL,
        [Type]                 NVARCHAR(64)   NOT NULL,
        [Description]          NVARCHAR(MAX)  NOT NULL DEFAULT '',
        [ResponsibilitiesCsv]  NVARCHAR(MAX)  NOT NULL DEFAULT '',
        [QualificationsCsv]    NVARCHAR(MAX)  NOT NULL DEFAULT '',
        [NiceToHavesCsv]       NVARCHAR(MAX)  NOT NULL DEFAULT '',
        [BenefitsCsv]          NVARCHAR(MAX)  NOT NULL DEFAULT '',
        [Category]             NVARCHAR(128)  NOT NULL DEFAULT '',
        [TagsCsv]              NVARCHAR(1000) NOT NULL DEFAULT '',
        [CreatedAt]            DATETIME2      NOT NULL DEFAULT GETUTCDATE(),
        [ApplicationCount]     INT            NOT NULL DEFAULT 0,
        [RequiredCount]        INT            NOT NULL DEFAULT 1,
        [AcceptedCount]        INT            NOT NULL DEFAULT 0,
        [Deadline]             DATETIME2      NULL,
        [Status]               NVARCHAR(64)   NOT NULL DEFAULT 'Open'
    );
    PRINT 'TABLE [Jobs] created.';
END
ELSE
BEGIN
    PRINT 'TABLE [Jobs] already exists â€“ checking for missing columns...';

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[Jobs]') AND name = N'Description')
    BEGIN
        ALTER TABLE [Jobs] ADD [Description] NVARCHAR(MAX) NOT NULL DEFAULT '';
        PRINT '  + Column [Description] added to [Jobs].';
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[Jobs]') AND name = N'ResponsibilitiesCsv')
    BEGIN
        ALTER TABLE [Jobs] ADD [ResponsibilitiesCsv] NVARCHAR(MAX) NOT NULL DEFAULT '';
        PRINT '  + Column [ResponsibilitiesCsv] added to [Jobs].';
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[Jobs]') AND name = N'QualificationsCsv')
    BEGIN
        ALTER TABLE [Jobs] ADD [QualificationsCsv] NVARCHAR(MAX) NOT NULL DEFAULT '';
        PRINT '  + Column [QualificationsCsv] added to [Jobs].';
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[Jobs]') AND name = N'NiceToHavesCsv')
    BEGIN
        ALTER TABLE [Jobs] ADD [NiceToHavesCsv] NVARCHAR(MAX) NOT NULL DEFAULT '';
        PRINT '  + Column [NiceToHavesCsv] added to [Jobs].';
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[Jobs]') AND name = N'BenefitsCsv')
    BEGIN
        ALTER TABLE [Jobs] ADD [BenefitsCsv] NVARCHAR(MAX) NOT NULL DEFAULT '';
        PRINT '  + Column [BenefitsCsv] added to [Jobs].';
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[Jobs]') AND name = N'Category')
    BEGIN
        ALTER TABLE [Jobs] ADD [Category] NVARCHAR(128) NOT NULL DEFAULT '';
        PRINT '  + Column [Category] added to [Jobs].';
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[Jobs]') AND name = N'TagsCsv')
    BEGIN
        ALTER TABLE [Jobs] ADD [TagsCsv] NVARCHAR(1000) NOT NULL DEFAULT '';
        PRINT '  + Column [TagsCsv] added to [Jobs].';
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[Jobs]') AND name = N'ApplicationCount')
    BEGIN
        ALTER TABLE [Jobs] ADD [ApplicationCount] INT NOT NULL DEFAULT 0;
        PRINT '  + Column [ApplicationCount] added to [Jobs].';
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[Jobs]') AND name = N'RequiredCount')
    BEGIN
        ALTER TABLE [Jobs] ADD [RequiredCount] INT NOT NULL DEFAULT 1;
        PRINT '  + Column [RequiredCount] added to [Jobs].';
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[Jobs]') AND name = N'AcceptedCount')
    BEGIN
        ALTER TABLE [Jobs] ADD [AcceptedCount] INT NOT NULL DEFAULT 0;
        PRINT '  + Column [AcceptedCount] added to [Jobs].';
    END

    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'[Jobs]') AND name = N'Status')
    BEGIN
        ALTER TABLE [Jobs] ADD [Status] NVARCHAR(64) NOT NULL DEFAULT 'Open';
        PRINT '  + Column [Status] added to [Jobs].';
    END
END
GO


-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
-- TABLE: Applications
-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
IF OBJECT_ID(N'[Applications]', N'U') IS NULL
BEGIN
    CREATE TABLE [Applications] (
        [Id]        NVARCHAR(64)  NOT NULL PRIMARY KEY,
        [UserId]    INT           NOT NULL,
        [UserName]  NVARCHAR(128) NOT NULL,
        [JobId]     NVARCHAR(64)  NOT NULL,
        [Status]    NVARCHAR(64)  NOT NULL DEFAULT 'Applied',
        [UpdatedAt] DATETIME2     NOT NULL DEFAULT GETUTCDATE()
    );
    PRINT 'TABLE [Applications] created.';
END
ELSE
BEGIN
    PRINT 'TABLE [Applications] already exists â€“ no new columns to add.';
END
GO


-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
-- TABLE: Messages
-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
IF OBJECT_ID(N'[Messages]', N'U') IS NULL
BEGIN
    CREATE TABLE [Messages] (
        [Id]          NVARCHAR(64)   NOT NULL PRIMARY KEY,
        [FromCompany] BIT            NOT NULL DEFAULT 0,
        [Text]        NVARCHAR(2000) NOT NULL,
        [CreatedAt]   DATETIME2      NOT NULL DEFAULT GETUTCDATE()
    );
    PRINT 'TABLE [Messages] created.';
END
ELSE
BEGIN
    PRINT 'TABLE [Messages] already exists â€“ no new columns to add.';
END
GO


-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
-- TABLE: Notifications
-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
IF OBJECT_ID(N'[Notifications]', N'U') IS NULL
BEGIN
    CREATE TABLE [Notifications] (
        [Id]        NVARCHAR(64)   NOT NULL PRIMARY KEY,
        [Type]      NVARCHAR(64)   NOT NULL,
        [Text]      NVARCHAR(2000) NOT NULL,
        [CreatedAt] DATETIME2      NOT NULL DEFAULT GETUTCDATE()
    );
    PRINT 'TABLE [Notifications] created.';
END
ELSE
BEGIN
    PRINT 'TABLE [Notifications] already exists â€“ no new columns to add.';
END
GO


-- =====================================================================
--  UPDATE 2026-04-29  â€“  Schema fixes discovered during deployment
--  Safe to re-run (all checks are idempotent).
-- =====================================================================

-- â”€â”€â”€ [Users] Widen PhotoUrl from 512 â†’ 1024 â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
-- Google profile picture URLs can be very long (512 was too short).
IF EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID(N'[Users]')
      AND name = N'PhotoUrl'
      AND max_length < 2048   -- NVARCHAR(1024) uses max_length = 2048 bytes
)
BEGIN
    ALTER TABLE [Users] ALTER COLUMN [PhotoUrl] NVARCHAR(1024) NULL;
    PRINT '  ~ [Users].[PhotoUrl] widened to NVARCHAR(1024).';
END
ELSE
BEGIN
    PRINT '  [Users].[PhotoUrl] already 1024+ chars â€“ no change.';
END
GO

-- â”€â”€â”€ [Users] Make Password nullable for Google-login users â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
IF EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID(N'[Users]')
      AND name = N'Password'
      AND is_nullable = 0
)
BEGIN
    ALTER TABLE [Users] ALTER COLUMN [Password] NVARCHAR(128) NULL;
    PRINT '  ~ [Users].[Password] changed to NULL (Google-login support).';
END
ELSE
BEGIN
    PRINT '  [Users].[Password] already nullable â€“ no change.';
END
GO

-- â”€â”€â”€ [Jobs] Add DEFAULT 0 on CompanyId if missing â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
IF NOT EXISTS (
    SELECT 1 FROM sys.default_constraints
    WHERE parent_object_id = OBJECT_ID(N'[Jobs]')
      AND COL_NAME(parent_object_id, parent_column_id) = 'CompanyId'
)
BEGIN
    ALTER TABLE [Jobs] ADD CONSTRAINT [DF_Jobs_CompanyId] DEFAULT 0 FOR [CompanyId];
    PRINT '  + DEFAULT(0) added to [Jobs].[CompanyId].';
END
ELSE
BEGIN
    PRINT '  [Jobs].[CompanyId] default already exists â€“ no change.';
END
GO

-- â”€â”€â”€ [Applications] Add DEFAULT 0 on UserId if missing â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
IF NOT EXISTS (
    SELECT 1 FROM sys.default_constraints
    WHERE parent_object_id = OBJECT_ID(N'[Applications]')
      AND COL_NAME(parent_object_id, parent_column_id) = 'UserId'
)
BEGIN
    ALTER TABLE [Applications] ADD CONSTRAINT [DF_Applications_UserId] DEFAULT 0 FOR [UserId];
    PRINT '  + DEFAULT(0) added to [Applications].[UserId].';
END
ELSE
BEGIN
    PRINT '  [Applications].[UserId] default already exists â€“ no change.';
END
GO


-- =====================================================================
--  Done. Final validation â€“ lists all tables and column counts.
-- =====================================================================
SELECT
    t.name             AS TableName,
    COUNT(c.column_id) AS ColumnCount
FROM sys.tables  t
JOIN sys.columns c ON c.object_id = t.object_id
WHERE t.name IN ('Users','Jobs','Applications','Messages','Notifications')
GROUP BY t.name
ORDER BY t.name;
GO


-- ─── [Jobs] Add Deadline if missing ──────────────────────────────────────────
IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID(N'[Jobs]') 
    AND name = N'Deadline'
)
BEGIN
    ALTER TABLE [Jobs] ADD [Deadline] DATETIME2 NULL;
    PRINT '  + Column [Deadline] added to [Jobs].';
END
GO

