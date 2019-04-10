CREATE TABLE [config].[FrameworkCodes] (
    [CodeType]        NVARCHAR (50) NOT NULL,
    [FrameworkCode]   NCHAR (1)     NOT NULL,
    [CodeDescription] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_FrameworkCodes] PRIMARY KEY CLUSTERED ([FrameworkCode] ASC, [CodeType] ASC)
);

