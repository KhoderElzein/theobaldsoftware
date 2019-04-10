CREATE TABLE [config].[Package] (
    [PackageID]   INT            IDENTITY (1, 1) NOT NULL,
    [PackagePath] NVARCHAR (255) NOT NULL,
    [PackageName] NVARCHAR (255) NOT NULL,
    [IsDisabled]  BIT            CONSTRAINT [DF_Package_IsDisabled] DEFAULT ('0') NOT NULL,
    CONSTRAINT [PK_Package] PRIMARY KEY CLUSTERED ([PackageID] ASC)
);

