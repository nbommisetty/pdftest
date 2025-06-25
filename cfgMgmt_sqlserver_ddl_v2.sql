-- Drop Foreign Key Constraints
ALTER TABLE [dbo].[FeatureApplication] DROP CONSTRAINT IF EXISTS FK_FeatureApplication_ApplicationId;
ALTER TABLE [dbo].[FeatureApplication] DROP CONSTRAINT IF EXISTS FK_FeatureApplication_FeatureId;
ALTER TABLE [dbo].[Page] DROP CONSTRAINT IF EXISTS FK_Page_FeatureId;
ALTER TABLE [dbo].[Form] DROP CONSTRAINT IF EXISTS FK_Form_PageId;
ALTER TABLE [dbo].[Field] DROP CONSTRAINT IF EXISTS FK_Field_FormId;
ALTER TABLE [dbo].[TenantApplicationFeatureConfig] DROP CONSTRAINT IF EXISTS FK_TenantApplicationFeatureConfig_TenantId;
ALTER TABLE [dbo].[TenantApplicationFeatureConfig] DROP CONSTRAINT IF EXISTS FK_TenantApplicationFeatureConfig_ApplicationId;
ALTER TABLE [dbo].[TenantApplicationFeatureConfig] DROP CONSTRAINT IF EXISTS FK_TenantApplicationFeatureConfig_RoleId;
ALTER TABLE [dbo].[TenantApplicationFeatureConfig] DROP CONSTRAINT IF EXISTS FK_TenantApplicationFeatureConfig_FeatureId;
ALTER TABLE [dbo].[TenantApplicationFeatureConfig] DROP CONSTRAINT IF EXISTS FK_TenantApplicationFeatureConfig_ThemeId;
ALTER TABLE [dbo].[TenantApplicationFieldConfig] DROP CONSTRAINT IF EXISTS FK_TenantApplicationFieldConfig_TenantId;
ALTER TABLE [dbo].[TenantApplicationFieldConfig] DROP CONSTRAINT IF EXISTS FK_TenantApplicationFieldConfig_ApplicationId;
ALTER TABLE [dbo].[TenantApplicationFieldConfig] DROP CONSTRAINT IF EXISTS FK_TenantApplicationFieldConfig_FieldId;
ALTER TABLE [dbo].[Tenant] DROP CONSTRAINT IF EXISTS FK_Tenant_ThemeId;
ALTER TABLE [dbo].[TenantApplicationConfig] DROP CONSTRAINT IF EXISTS FK_TenantApplicationConfig_TenantId;
ALTER TABLE [dbo].[TenantApplicationConfig] DROP CONSTRAINT IF EXISTS FK_TenantApplicationConfig_ApplicationId;
ALTER TABLE [dbo].[TenantApplicationConfig] DROP CONSTRAINT IF EXISTS FK_TenantApplicationConfig_ThemeId;
GO

-- Drop Tables
DROP TABLE IF EXISTS [dbo].[TenantApplicationConfig];
DROP TABLE IF EXISTS [dbo].[TenantApplicationFieldConfig];
DROP TABLE IF EXISTS [dbo].[TenantApplicationFeatureConfig];
DROP TABLE IF EXISTS [dbo].[FeatureApplication];
DROP TABLE IF EXISTS [dbo].[Theme];
DROP TABLE IF EXISTS [dbo].[Field];
DROP TABLE IF EXISTS [dbo].[Form];
DROP TABLE IF EXISTS [dbo].[Page];
DROP TABLE IF EXISTS [dbo].[UserRole];
DROP TABLE IF EXISTS [dbo].[Feature];
DROP TABLE IF EXISTS [dbo].[Application];
DROP TABLE IF EXISTS [dbo].[Tenant];
GO

CREATE TABLE [dbo].[Tenant] (
  [TenantId] BIGINT PRIMARY KEY IDENTITY(1,1),
  [TenantName] VARCHAR(100) UNIQUE NOT NULL,
  [ThemeId] BIGINT,
  [CreatedAt] DATETIME NOT NULL,
  [UpdatedAt] DATETIME NOT NULL,
  [CreatedBy] VARCHAR(100),
  [UpdatedBy] VARCHAR(100)
)
GO

CREATE TABLE [dbo].[Application] (
  [ApplicationId] BIGINT PRIMARY KEY IDENTITY(1,1),
  [ApplicationName] VARCHAR(100) UNIQUE NOT NULL,
  [ApplicationDescription] TEXT,
  [CreatedAt] DATETIME NOT NULL,
  [UpdatedAt] DATETIME NOT NULL,
  [CreatedBy] VARCHAR(100),
  [UpdatedBy] VARCHAR(100)
)
GO

CREATE TABLE [dbo].[Feature] (
  [FeatureId] BIGINT PRIMARY KEY IDENTITY(1,1),
  [FeatureName] VARCHAR(100) UNIQUE NOT NULL,
  [FeatureDescription] TEXT,
  [CreatedAt] DATETIME NOT NULL,
  [UpdatedAt] DATETIME NOT NULL,
  [CreatedBy] VARCHAR(100),
  [UpdatedBy] VARCHAR(100)
)
GO

CREATE TABLE [dbo].[UserRole] (
  [RoleId] BIGINT PRIMARY KEY IDENTITY(1,1),
  [RoleName] VARCHAR(50) UNIQUE NOT NULL,
  [RoleDescription] TEXT,
  [CreatedAt] DATETIME NOT NULL,
  [UpdatedAt] DATETIME NOT NULL,
  [CreatedBy] VARCHAR(100),
  [UpdatedBy] VARCHAR(100)
)
GO

CREATE TABLE [dbo].[Page] (
  [PageId] BIGINT PRIMARY KEY IDENTITY(1,1),
  [FeatureId] BIGINT NOT NULL,
  [PageName] VARCHAR(100) NOT NULL,
  [PageOrder] INT NOT NULL,
  [CreatedAt] DATETIME NOT NULL,
  [UpdatedAt] DATETIME NOT NULL,
  [CreatedBy] VARCHAR(100),
  [UpdatedBy] VARCHAR(100)
)
GO

CREATE TABLE [dbo].[Form] (
  [FormId] BIGINT PRIMARY KEY IDENTITY(1,1),
  [PageId] BIGINT NOT NULL,
  [FormName] VARCHAR(100) NOT NULL,
  [FormOrder] INT NOT NULL,
  [CreatedAt] DATETIME NOT NULL,
  [UpdatedAt] DATETIME NOT NULL,
  [CreatedBy] VARCHAR(100),
  [UpdatedBy] VARCHAR(100)
)
GO

CREATE TABLE [dbo].[Field] (
  [FieldId] BIGINT PRIMARY KEY IDENTITY(1,1),
  [FormId] BIGINT NOT NULL,
  [FieldName] VARCHAR(100) NOT NULL,
  [FieldType] VARCHAR(50) NOT NULL,
  [InputType] VARCHAR(50) NOT NULL,
  [DefaultLabel] VARCHAR(255) NOT NULL,
  [DefaultValidationRules] NVARCHAR(MAX),
  [CreatedAt] DATETIME NOT NULL,
  [UpdatedAt] DATETIME NOT NULL,
  [CreatedBy] VARCHAR(100),
  [UpdatedBy] VARCHAR(100)
)
GO

CREATE TABLE [dbo].[Theme] (
  [ThemeId] BIGINT PRIMARY KEY IDENTITY(1,1),
  [ThemeName] VARCHAR(100) UNIQUE NOT NULL,
  [ThemeDescription] TEXT,
  [ThemeData] NVARCHAR(MAX),
  [CreatedAt] DATETIME NOT NULL,
  [UpdatedAt] DATETIME NOT NULL,
  [CreatedBy] VARCHAR(100),
  [UpdatedBy] VARCHAR(100)
)
GO

CREATE TABLE [dbo].[FeatureApplication] (
  [FeatureApplicationId] BIGINT PRIMARY KEY IDENTITY(1,1),
  [FeatureId] BIGINT NOT NULL,
  [ApplicationId] BIGINT NOT NULL,
  [CreatedAt] DATETIME NOT NULL,
  [UpdatedAt] DATETIME NOT NULL,
  [CreatedBy] VARCHAR(100),
  [UpdatedBy] VARCHAR(100)
)
GO

CREATE TABLE [dbo].[TenantApplicationFeatureConfig] (
  [ConfigId] BIGINT PRIMARY KEY IDENTITY(1,1),
  [TenantId] BIGINT NOT NULL,
  [ApplicationId] BIGINT NOT NULL,
  [RoleId] BIGINT,
  [FeatureId] BIGINT NOT NULL,
  [IsEnabled] BIT NOT NULL,
  [ThemeId] BIGINT,
  [CreatedAt] DATETIME NOT NULL,
  [UpdatedAt] DATETIME NOTETIME NOT NULL,
  [CreatedBy] VARCHAR(100),
  [UpdatedBy] VARCHAR(100)
)
GO

CREATE TABLE [dbo].[TenantApplicationFieldConfig] (
  [ConfigId] BIGINT PRIMARY KEY IDENTITY(1,1),
  [TenantId] BIGINT NOT NULL,
  [ApplicationId] BIGINT NOT NULL,
  [FieldId] BIGINT NOT NULL,
  [IsEnabled] BIT NOT NULL,
  [CustomLabel] VARCHAR(255),
  [CustomValidationRules] NVARCHAR(MAX),
  [CreatedAt] DATETIME NOT NULL,
  [UpdatedAt] DATETIME NOT NULL,
  [CreatedBy] VARCHAR(100),
  [UpdatedBy] VARCHAR(100)
)
GO

CREATE TABLE [dbo].[TenantApplicationConfig] (
  [ConfigId] BIGINT PRIMARY KEY IDENTITY(1,1),
  [TenantId] BIGINT NOT NULL,
  [ApplicationId] BIGINT NOT NULL,
  [ThemeId] BIGINT NOT NULL,
  [CreatedAt] DATETIME NOT NULL,
  [UpdatedAt] DATETIME NOT NULL,
  [CreatedBy] VARCHAR(100),
  [UpdatedBy] VARCHAR(100)
)
GO

CREATE UNIQUE INDEX [Page_index_0] ON [dbo].[Page] ("FeatureId", "PageName")
GO

CREATE UNIQUE INDEX [Form_index_1] ON [dbo].[Form] ("PageId", "FormName")
GO

CREATE UNIQUE INDEX [Field_index_2] ON [dbo].[Field] ("FormId", "FieldName")
GO

CREATE UNIQUE INDEX [FeatureApplication_index_3] ON [dbo].[FeatureApplication] ("FeatureId", "ApplicationId")
GO

CREATE UNIQUE INDEX [TenantApplicationFeatureConfig_index_4] ON [dbo].[TenantApplicationFeatureConfig] ("TenantId", "ApplicationId", "RoleId", "FeatureId")
GO

CREATE UNIQUE INDEX [TenantApplicationFieldConfig_index_5] ON [dbo].[TenantApplicationFieldConfig] ("TenantId", "ApplicationId", "FieldId")
GO

CREATE UNIQUE INDEX [TenantApplicationConfig_index_6] ON [dbo].[TenantApplicationConfig] ("TenantId", "ApplicationId")
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Primary key for tenants. Auto-incrementing mechanism handled by specific DB DDL (e.g., IDENTITY in SQL Server).',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Tenant',
@level2type = N'Column', @level2name = 'TenantId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Unique name for each tenant.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Tenant',
@level2type = N'Column', @level2name = 'TenantName';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Foreign key to Theme. The default UI theme for this tenant.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Tenant',
@level2type = N'Column', @level2name = 'ThemeId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Username of the user who created this tenant.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Tenant',
@level2type = N'Column', @level2name = 'CreatedBy';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Username of the user who last updated this tenant.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Tenant',
@level2type = N'Column', @level2name = 'UpdatedBy';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Primary key for applications. Auto-incrementing mechanism handled by specific DB DDL.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Application',
@level2type = N'Column', @level2name = 'ApplicationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'e.g., OnlineBanking(Web), MobileBanking, OnlineAccountOpening.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Application',
@level2type = N'Column', @level2name = 'ApplicationName';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Username of the user who created this application.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Application',
@level2type = N'Column', @level2name = 'CreatedBy';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Username of the user who last updated this application.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Application',
@level2type = N'Column', @level2name = 'UpdatedBy';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Primary key for features. Auto-incrementing mechanism handled by specific DB DDL.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Feature',
@level2type = N'Column', @level2name = 'FeatureId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'e.g., Wire Transfers, Direct Deposits.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Feature',
@level2type = N'Column', @level2name = 'FeatureName';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Username of the user who created this feature.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Feature',
@level2type = N'Column', @level2name = 'CreatedBy';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Username of the user who last updated this feature.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Feature',
@level2type = N'Column', @level2name = 'UpdatedBy';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Primary key for user roles. Auto-incrementing mechanism handled by specific DB DDL.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UserRole',
@level2type = N'Column', @level2name = 'RoleId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'e.g., business-admin, business-subuser, readonly.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UserRole',
@level2type = N'Column', @level2name = 'RoleName';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Username of the user who created this role.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UserRole',
@level2type = N'Column', @level2name = 'CreatedBy';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Username of the user who last updated this role.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'UserRole',
@level2type = N'Column', @level2name = 'UpdatedBy';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Primary key for pages. Auto-incrementing mechanism handled by specific DB DDL.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Page',
@level2type = N'Column', @level2name = 'PageId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'e.g., Initiate Transfer, Review Transfer.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Page',
@level2type = N'Column', @level2name = 'PageName';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Display order of pages within a feature.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Page',
@level2type = N'Column', @level2name = 'PageOrder';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Username of the user who created this page.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Page',
@level2type = N'Column', @level2name = 'CreatedBy';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Username of the user who last updated this page.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Page',
@level2type = N'Column', @level2name = 'UpdatedBy';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Primary key for forms. Auto-incrementing mechanism handled by specific DB DDL.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Form',
@level2type = N'Column', @level2name = 'FormId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'e.g., Recipient Details, Amount Input.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Form',
@level2type = N'Column', @level2name = 'FormName';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Display order of forms within a page.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Form',
@level2type = N'Column', @level2name = 'FormOrder';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Username of the user who created this form.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Form',
@level2type = N'Column', @level2name = 'CreatedBy';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Username of the user who last updated this form.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Form',
@level2type = N'Column', @level2name = 'UpdatedBy';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Primary key for fields. Auto-incrementing mechanism handled by specific DB DDL.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Field',
@level2type = N'Column', @level2name = 'FieldId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Foreign key to Form. Every field must belong to a form.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Field',
@level2type = N'Column', @level2name = 'FormId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'System name for the field (e.g., recipient_account_number).',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Field',
@level2type = N'Column', @level2name = 'FieldName';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'e.g., TEXT_INPUT, NUMBER_INPUT, DATE_PICKER, DROPDOWN.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Field',
@level2type = N'Column', @level2name = 'FieldType';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Defines the HTML input type or logical input control for the field.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Field',
@level2type = N'Column', @level2name = 'InputType';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Default display label for the field.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Field',
@level2type = N'Column', @level2name = 'DefaultLabel';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Default validation rules in JSON format.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Field',
@level2type = N'Column', @level2name = 'DefaultValidationRules';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Username of the user who created this field.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Field',
@level2type = N'Column', @level2name = 'CreatedBy';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Username of the user who last updated this field.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Field',
@level2type = N'Column', @level2name = 'UpdatedBy';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Primary key for themes. Auto-incrementing mechanism handled by specific DB DDL.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Theme',
@level2type = N'Column', @level2name = 'ThemeId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'e.g., dark, classic, modern.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Theme',
@level2type = N'Column', @level2name = 'ThemeName';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'JSON object containing theme variables (e.g., colors, fonts, CSS properties).',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Theme',
@level2type = N'Column', @level2name = 'ThemeData';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Username of the user who created this theme.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Theme',
@level2type = N'Column', @level2name = 'CreatedBy';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Username of the user who last updated this theme.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'Theme',
@level2type = N'Column', @level2name = 'UpdatedBy';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Primary key. Auto-incrementing mechanism handled by specific DB DDL.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'FeatureApplication',
@level2type = N'Column', @level2name = 'FeatureApplicationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Username of the user who created this association.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'FeatureApplication',
@level2type = N'Column', @level2name = 'CreatedBy';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Username of the user who last updated this association.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'FeatureApplication',
@level2type = N'Column', @level2name = 'UpdatedBy';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Primary key. Auto-incrementing mechanism handled by specific DB DDL.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TenantApplicationFeatureConfig',
@level2type = N'Column', @level2name = 'ConfigId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Foreign key to Application. Allows tenant-specific feature configurations to vary by Application.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TenantApplicationFeatureConfig',
@level2type = N'Column', @level2name = 'ApplicationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Foreign key to UserRole. Nullable to support applications without explicit user roles.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TenantApplicationFeatureConfig',
@level2type = N'Column', @level2name = 'RoleId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'True if feature is enabled for the tenant within this specific application and for this role.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TenantApplicationFeatureConfig',
@level2type = N'Column', @level2name = 'IsEnabled';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Foreign key to Theme. The theme for this tenant in this specific application for this feature. Nullable if no specific theme override.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TenantApplicationFeatureConfig',
@level2type = N'Column', @level2name = 'ThemeId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Username of the user who created this config.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TenantApplicationFeatureConfig',
@level2type = N'Column', @level2name = 'CreatedBy';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Username of the user who last updated this config.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TenantApplicationFeatureConfig',
@level2type = N'Column', @level2name = 'UpdatedBy';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Primary key. Auto-incrementing mechanism handled by specific DB DDL.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TenantApplicationFieldConfig',
@level2type = N'Column', @level2name = 'ConfigId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Foreign key to Application. Allows tenant-specific field configurations to vary by Application.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TenantApplicationFieldConfig',
@level2type = N'Column', @level2name = 'ApplicationId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'True if field is enabled for the tenant within its feature/application context.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TenantApplicationFieldConfig',
@level2type = N'Column', @level2name = 'IsEnabled';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Tenant-specific override for field label.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TenantApplicationFieldConfig',
@level2type = N'Column', @level2name = 'CustomLabel';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Tenant-specific override for field validation rules.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TenantApplicationFieldConfig',
@level2type = N'Column', @level2name = 'CustomValidationRules';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Username of the user who created this config.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TenantApplicationFieldConfig',
@level2type = N'Column', @level2name = 'CreatedBy';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Username of the user who last updated this config.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TenantApplicationFieldConfig',
@level2type = N'Column', @level2name = 'UpdatedBy';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Primary key. Auto-incrementing mechanism handled by specific DB DDL.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TenantApplicationConfig',
@level2type = N'Column', @level2name = 'ConfigId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Foreign key to Theme. The theme for this tenant in this specific application.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TenantApplicationConfig',
@level2type = N'Column', @level2name = 'ThemeId';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Username of the user who created this config.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TenantApplicationConfig',
@level2type = N'Column', @level2name = 'CreatedBy';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Username of the user who last updated this config.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'TenantApplicationConfig',
@level2type = N'Column', @level2name = 'UpdatedBy';
GO

ALTER TABLE [dbo].[FeatureApplication] ADD CONSTRAINT FK_FeatureApplication_ApplicationId FOREIGN KEY ([ApplicationId]) REFERENCES [dbo].[Application] ([ApplicationId]);
ALTER TABLE [dbo].[FeatureApplication] ADD CONSTRAINT FK_FeatureApplication_FeatureId FOREIGN KEY ([FeatureId]) REFERENCES [dbo].[Feature] ([FeatureId]);
ALTER TABLE [dbo].[Page] ADD CONSTRAINT FK_Page_FeatureId FOREIGN KEY ([FeatureId]) REFERENCES [dbo].[Feature] ([FeatureId]);
ALTER TABLE [dbo].[Form] ADD CONSTRAINT FK_Form_PageId FOREIGN KEY ([PageId]) REFERENCES [dbo].[Page] ([PageId]);
ALTER TABLE [dbo].[Field] ADD CONSTRAINT FK_Field_FormId FOREIGN KEY ([FormId]) REFERENCES [dbo].[Form] ([FormId]);
ALTER TABLE [dbo].[TenantApplicationFeatureConfig] ADD CONSTRAINT FK_TenantApplicationFeatureConfig_TenantId FOREIGN KEY ([TenantId]) REFERENCES [dbo].[Tenant] ([TenantId]);
ALTER TABLE [dbo].[TenantApplicationFeatureConfig] ADD CONSTRAINT FK_TenantApplicationFeatureConfig_ApplicationId FOREIGN KEY ([ApplicationId]) REFERENCES [dbo].[Application] ([ApplicationId]);
ALTER TABLE [dbo].[TenantApplicationFeatureConfig] ADD CONSTRAINT FK_TenantApplicationFeatureConfig_RoleId FOREIGN KEY ([RoleId]) REFERENCES [dbo].[UserRole] ([RoleId]);
ALTER TABLE [dbo].[TenantApplicationFeatureConfig] ADD CONSTRAINT FK_TenantApplicationFeatureConfig_FeatureId FOREIGN KEY ([FeatureId]) REFERENCES [dbo].[Feature] ([FeatureId]);
ALTER TABLE [dbo].[TenantApplicationFeatureConfig] ADD CONSTRAINT FK_TenantApplicationFeatureConfig_ThemeId FOREIGN KEY ([ThemeId]) REFERENCES [dbo].[Theme] ([ThemeId]);
ALTER TABLE [dbo].[TenantApplicationFieldConfig] ADD CONSTRAINT FK_TenantApplicationFieldConfig_TenantId FOREIGN KEY ([TenantId]) REFERENCES [dbo].[Tenant] ([TenantId]);
ALTER TABLE [dbo].[TenantApplicationFieldConfig] ADD CONSTRAINT FK_TenantApplicationFieldConfig_ApplicationId FOREIGN KEY ([ApplicationId]) REFERENCES [dbo].[Application] ([ApplicationId]);
ALTER TABLE [dbo].[TenantApplicationFieldConfig] ADD CONSTRAINT FK_TenantApplicationFieldConfig_FieldId FOREIGN KEY ([FieldId]) REFERENCES [dbo].[Field] ([FieldId]);
ALTER TABLE [dbo].[Tenant] ADD CONSTRAINT FK_Tenant_ThemeId FOREIGN KEY ([ThemeId]) REFERENCES [dbo].[Theme] ([ThemeId]);
ALTER TABLE [dbo].[TenantApplicationConfig] ADD CONSTRAINT FK_TenantApplicationConfig_TenantId FOREIGN KEY ([TenantId]) REFERENCES [dbo].[Tenant] ([TenantId]);
ALTER TABLE [dbo].[TenantApplicationConfig] ADD CONSTRAINT FK_TenantApplicationConfig_ApplicationId FOREIGN KEY ([ApplicationId]) REFERENCES [dbo].[Application] ([ApplicationId]);
ALTER TABLE [dbo].[TenantApplicationConfig] ADD CONSTRAINT FK_TenantApplicationConfig_ThemeId FOREIGN KEY ([ThemeId]) REFERENCES [dbo].[Theme] ([ThemeId]);
GO