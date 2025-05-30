USE [master]
GO
/****** Object:  Database [Аренда]    Script Date: 25.05.2025 21:38:49 ******/
CREATE DATABASE [Аренда]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Аренда', FILENAME = N'D:\Новая папка (2)\MSSQL15.SQLEXPRESS\MSSQL\DATA\Аренда.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Аренда_log', FILENAME = N'D:\Новая папка (2)\MSSQL15.SQLEXPRESS\MSSQL\DATA\Аренда_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Аренда] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Аренда].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Аренда] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Аренда] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Аренда] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Аренда] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Аренда] SET ARITHABORT OFF 
GO
ALTER DATABASE [Аренда] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [Аренда] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Аренда] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Аренда] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Аренда] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Аренда] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Аренда] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Аренда] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Аренда] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Аренда] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Аренда] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Аренда] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Аренда] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Аренда] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Аренда] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Аренда] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Аренда] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Аренда] SET RECOVERY FULL 
GO
ALTER DATABASE [Аренда] SET  MULTI_USER 
GO
ALTER DATABASE [Аренда] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Аренда] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Аренда] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Аренда] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Аренда] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Аренда] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Аренда] SET QUERY_STORE = OFF
GO
USE [Аренда]
GO
/****** Object:  User [менеджер]    Script Date: 25.05.2025 21:38:49 ******/
CREATE USER [менеджер] FOR LOGIN [user_managers] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [гость]    Script Date: 25.05.2025 21:38:49 ******/
CREATE USER [гость] FOR LOGIN [user_Guests] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [бухгалтер]    Script Date: 25.05.2025 21:38:49 ******/
CREATE USER [бухгалтер] FOR LOGIN [user_accountants] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [админ]    Script Date: 25.05.2025 21:38:49 ******/
CREATE USER [админ] FOR LOGIN [user_admin] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [Managers]    Script Date: 25.05.2025 21:38:49 ******/
CREATE ROLE [Managers]
GO
/****** Object:  DatabaseRole [Guests]    Script Date: 25.05.2025 21:38:49 ******/
CREATE ROLE [Guests]
GO
/****** Object:  DatabaseRole [Administrators]    Script Date: 25.05.2025 21:38:49 ******/
CREATE ROLE [Administrators]
GO
/****** Object:  DatabaseRole [Accountants]    Script Date: 25.05.2025 21:38:49 ******/
CREATE ROLE [Accountants]
GO
ALTER ROLE [Managers] ADD MEMBER [менеджер]
GO
ALTER ROLE [Guests] ADD MEMBER [гость]
GO
ALTER ROLE [Accountants] ADD MEMBER [бухгалтер]
GO
ALTER ROLE [Administrators] ADD MEMBER [админ]
GO
/****** Object:  Table [dbo].[Недвижимость]    Script Date: 25.05.2025 21:38:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Недвижимость](
	[id_недвижимости] [int] IDENTITY(1,1) NOT NULL,
	[id_владельца] [int] NOT NULL,
	[id_типа] [int] NOT NULL,
	[id_статуса] [int] NOT NULL,
	[Адрес] [nvarchar](200) NOT NULL,
	[Площадь] [decimal](10, 2) NOT NULL,
	[КоличествоКомнат] [int] NOT NULL,
	[Этаж] [int] NULL,
	[Описание] [nvarchar](max) NULL,
	[Цена] [decimal](15, 2) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id_недвижимости] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[AvailableProperties]    Script Date: 25.05.2025 21:38:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[AvailableProperties]
AS
SELECT id_недвижимости, id_владельца, id_типа, id_статуса, Адрес, Площадь, КоличествоКомнат, Этаж, Описание, Цена
FROM   dbo.Недвижимость
WHERE (id_статуса = 1)
GO
/****** Object:  Table [dbo].[Владельцы]    Script Date: 25.05.2025 21:38:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Владельцы](
	[id_владельца] [int] IDENTITY(1,1) NOT NULL,
	[Фамилия] [nvarchar](50) NOT NULL,
	[Имя] [nvarchar](50) NOT NULL,
	[Отчество] [nvarchar](50) NULL,
	[Телефон] [nvarchar](20) NOT NULL,
	[ЭлектроннаяПочта] [nvarchar](50) NULL,
	[ПаспортныеДанные] [nvarchar](100) NOT NULL,
	[ДатаРегистрации] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_владельца] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Арендаторы]    Script Date: 25.05.2025 21:38:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Арендаторы](
	[id_арендатора] [int] IDENTITY(1,1) NOT NULL,
	[Фамилия] [nvarchar](50) NOT NULL,
	[Имя] [nvarchar](50) NOT NULL,
	[Отчество] [nvarchar](50) NULL,
	[Телефон] [nvarchar](20) NOT NULL,
	[ЭлектроннаяПочта] [nvarchar](50) NULL,
	[ПаспортныеДанные] [nvarchar](100) NOT NULL,
	[ДатаРегистрации] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_арендатора] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ТипыНедвижимости]    Script Date: 25.05.2025 21:38:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ТипыНедвижимости](
	[id_типа] [int] IDENTITY(1,1) NOT NULL,
	[НазваниеТипа] [nvarchar](50) NOT NULL,
	[Описание] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_типа] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ДоговорыАренды]    Script Date: 25.05.2025 21:38:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ДоговорыАренды](
	[id_договора] [int] IDENTITY(1,1) NOT NULL,
	[id_недвижимости] [int] NOT NULL,
	[id_арендатора] [int] NOT NULL,
	[ДатаНачала] [date] NOT NULL,
	[ДатаОкончания] [date] NOT NULL,
	[ЕжемесячнаяПлата] [decimal](15, 2) NOT NULL,
	[Залог] [decimal](15, 2) NULL,
	[Условия] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_договора] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[АктивныеДоговоры]    Script Date: 25.05.2025 21:38:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[АктивныеДоговоры]
AS
SELECT д.id_договора, н.Адрес, т.НазваниеТипа AS ТипНедвижимости, а.Фамилия + ' ' + а.Имя + ISNULL(' ' + а.Отчество, '') AS Арендатор, а.Телефон AS ТелефонАрендатора, д.ДатаНачала AS Дата_начала, д.ДатаОкончания AS Дата_окончания, 
             д.ЕжемесячнаяПлата AS Арендная_плата, DATEDIFF(DAY, GETDATE(), д.ДатаОкончания) AS Дней_до_окончания, в.Фамилия + ' ' + в.Имя + ISNULL(' ' + в.Отчество, '') AS Владелец
FROM   dbo.ДоговорыАренды AS д INNER JOIN
             dbo.Недвижимость AS н ON д.id_недвижимости = н.id_недвижимости INNER JOIN
             dbo.ТипыНедвижимости AS т ON н.id_типа = т.id_типа INNER JOIN
             dbo.Арендаторы AS а ON д.id_арендатора = а.id_арендатора INNER JOIN
             dbo.Владельцы AS в ON н.id_владельца = в.id_владельца
WHERE (д.ДатаОкончания >= GETDATE())
GO
/****** Object:  View [dbo].[ИстекшиеДоговоры]    Script Date: 25.05.2025 21:38:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ИстекшиеДоговоры]
AS
SELECT д.id_договора, н.Адрес, а.Фамилия + ' ' + а.Имя AS Арендатор, д.ДатаНачала, д.ДатаОкончания, д.ЕжемесячнаяПлата, DATEDIFF(DAY, д.ДатаОкончания, GETDATE()) AS Дней_после_окончания
FROM   dbo.ДоговорыАренды AS д INNER JOIN
             dbo.Недвижимость AS н ON д.id_недвижимости = н.id_недвижимости INNER JOIN
             dbo.Арендаторы AS а ON д.id_арендатора = а.id_арендатора
WHERE (д.ДатаОкончания < GETDATE())
GO
/****** Object:  Table [dbo].[ИсторияСтатусов]    Script Date: 25.05.2025 21:38:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ИсторияСтатусов](
	[id_записи] [int] IDENTITY(1,1) NOT NULL,
	[id_недвижимости] [int] NOT NULL,
	[id_старогоСтатуса] [int] NULL,
	[id_новогоСтатуса] [int] NOT NULL,
	[ДатаИзменения] [datetime] NOT NULL,
	[ИзмененоПользователем] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_записи] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Платежи]    Script Date: 25.05.2025 21:38:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Платежи](
	[id_платежа] [int] IDENTITY(1,1) NOT NULL,
	[id_договора] [int] NOT NULL,
	[ДатаПлатежа] [date] NOT NULL,
	[Сумма] [decimal](15, 2) NOT NULL,
	[id_типа] [int] NOT NULL,
	[id_статуса] [int] NOT NULL,
	[Описание] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_платежа] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[СтатусыНедвижимости]    Script Date: 25.05.2025 21:38:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[СтатусыНедвижимости](
	[id_статуса] [int] IDENTITY(1,1) NOT NULL,
	[НазваниеСтатуса] [nvarchar](50) NOT NULL,
	[Описание] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_статуса] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[СтатусыПлатежей]    Script Date: 25.05.2025 21:38:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[СтатусыПлатежей](
	[id_статуса] [int] IDENTITY(1,1) NOT NULL,
	[НазваниеСтатуса] [nvarchar](50) NOT NULL,
	[Описание] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_статуса] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ТипыПлатежей]    Script Date: 25.05.2025 21:38:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ТипыПлатежей](
	[id_типа] [int] IDENTITY(1,1) NOT NULL,
	[НазваниеТипа] [nvarchar](50) NOT NULL,
	[Описание] [nvarchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_типа] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Арендаторы] ON 

INSERT [dbo].[Арендаторы] ([id_арендатора], [Фамилия], [Имя], [Отчество], [Телефон], [ЭлектроннаяПочта], [ПаспортныеДанные], [ДатаРегистрации]) VALUES (1, N'Смирнов', N'Дмитрий', N'Анатольевич', N'+79163334455', N'smirnov@mail.com', N'4520 334455', CAST(N'2025-05-22T22:28:04.690' AS DateTime))
INSERT [dbo].[Арендаторы] ([id_арендатора], [Фамилия], [Имя], [Отчество], [Телефон], [ЭлектроннаяПочта], [ПаспортныеДанные], [ДатаРегистрации]) VALUES (2, N'Федорова', N'Елена', N'Викторовна', N'+79164445566', N'fedorova@mail.com', N'4521 445566', CAST(N'2025-05-22T22:28:04.690' AS DateTime))
INSERT [dbo].[Арендаторы] ([id_арендатора], [Фамилия], [Имя], [Отчество], [Телефон], [ЭлектроннаяПочта], [ПаспортныеДанные], [ДатаРегистрации]) VALUES (3, N'Николаев', N'Сергей', N'Олегович', N'+79165556677', N'nikolaev@mail.com', N'4522 556677', CAST(N'2025-05-22T22:28:04.690' AS DateTime))
INSERT [dbo].[Арендаторы] ([id_арендатора], [Фамилия], [Имя], [Отчество], [Телефон], [ЭлектроннаяПочта], [ПаспортныеДанные], [ДатаРегистрации]) VALUES (4, N'Павлова', N'Анна', N'Михайловна', N'+79166667788', N'pavlova@mail.com', N'4523 667788', CAST(N'2025-05-22T22:28:04.690' AS DateTime))
INSERT [dbo].[Арендаторы] ([id_арендатора], [Фамилия], [Имя], [Отчество], [Телефон], [ЭлектроннаяПочта], [ПаспортныеДанные], [ДатаРегистрации]) VALUES (5, N'Григорьев', N'Максим', N'Александрович', N'+79167778899', N'grigoriev@mail.com', N'4524 778899', CAST(N'2025-05-22T22:28:04.690' AS DateTime))
INSERT [dbo].[Арендаторы] ([id_арендатора], [Фамилия], [Имя], [Отчество], [Телефон], [ЭлектроннаяПочта], [ПаспортныеДанные], [ДатаРегистрации]) VALUES (6, N'1', N'1', N'1', N'1', N'1', N'1', CAST(N'2025-05-22T23:30:40.750' AS DateTime))
SET IDENTITY_INSERT [dbo].[Арендаторы] OFF
GO
SET IDENTITY_INSERT [dbo].[Владельцы] ON 

INSERT [dbo].[Владельцы] ([id_владельца], [Фамилия], [Имя], [Отчество], [Телефон], [ЭлектроннаяПочта], [ПаспортныеДанные], [ДатаРегистрации]) VALUES (1, N'Иванов', N'Иван', N'Иванович', N'+79161234567', N'ivanov@mail.com', N'4510 123456', CAST(N'2025-05-22T22:28:04.690' AS DateTime))
INSERT [dbo].[Владельцы] ([id_владельца], [Фамилия], [Имя], [Отчество], [Телефон], [ЭлектроннаяПочта], [ПаспортныеДанные], [ДатаРегистрации]) VALUES (2, N'Петрова', N'Мария', N'Сергеевна', N'+79167654321', N'petrova@mail.com', N'4511 654321', CAST(N'2025-05-22T22:28:04.690' AS DateTime))
INSERT [dbo].[Владельцы] ([id_владельца], [Фамилия], [Имя], [Отчество], [Телефон], [ЭлектроннаяПочта], [ПаспортныеДанные], [ДатаРегистрации]) VALUES (3, N'Сидоров', N'Алексей', N'Владимирович', N'+79169998877', N'sidorov@mail.com', N'4512 987654', CAST(N'2025-05-22T22:28:04.690' AS DateTime))
INSERT [dbo].[Владельцы] ([id_владельца], [Фамилия], [Имя], [Отчество], [Телефон], [ЭлектроннаяПочта], [ПаспортныеДанные], [ДатаРегистрации]) VALUES (4, N'Кузнецова', N'Ольга', N'Дмитриевна', N'+79161112233', N'kuznetsova@mail.com', N'4513 112233', CAST(N'2025-05-22T22:28:04.690' AS DateTime))
INSERT [dbo].[Владельцы] ([id_владельца], [Фамилия], [Имя], [Отчество], [Телефон], [ЭлектроннаяПочта], [ПаспортныеДанные], [ДатаРегистрации]) VALUES (5, N'Васильев', N'Андрей', N'Игоревич', N'+79162223344', N'vasilev@mail.com', N'4514 223344', CAST(N'2025-05-22T22:28:04.690' AS DateTime))
SET IDENTITY_INSERT [dbo].[Владельцы] OFF
GO
SET IDENTITY_INSERT [dbo].[ДоговорыАренды] ON 

INSERT [dbo].[ДоговорыАренды] ([id_договора], [id_недвижимости], [id_арендатора], [ДатаНачала], [ДатаОкончания], [ЕжемесячнаяПлата], [Залог], [Условия]) VALUES (9, 23, 2, CAST(N'2023-01-15' AS Date), CAST(N'2025-12-14' AS Date), CAST(45000.00 AS Decimal(15, 2)), CAST(90000.00 AS Decimal(15, 2)), N'Коммунальные платежи включены в стоимость аренды')
INSERT [dbo].[ДоговорыАренды] ([id_договора], [id_недвижимости], [id_арендатора], [ДатаНачала], [ДатаОкончания], [ЕжемесячнаяПлата], [Залог], [Условия]) VALUES (10, 24, 3, CAST(N'2023-03-01' AS Date), CAST(N'2024-02-29' AS Date), CAST(80000.00 AS Decimal(15, 2)), CAST(160000.00 AS Decimal(15, 2)), N'Арендатор оплачивает коммунальные услуги отдельно')
INSERT [dbo].[ДоговорыАренды] ([id_договора], [id_недвижимости], [id_арендатора], [ДатаНачала], [ДатаОкончания], [ЕжемесячнаяПлата], [Залог], [Условия]) VALUES (11, 25, 4, CAST(N'2023-02-10' AS Date), CAST(N'2023-08-09' AS Date), CAST(120000.00 AS Decimal(15, 2)), CAST(240000.00 AS Decimal(15, 2)), N'Офисное помещение с ежедневной уборкой')
INSERT [dbo].[ДоговорыАренды] ([id_договора], [id_недвижимости], [id_арендатора], [ДатаНачала], [ДатаОкончания], [ЕжемесячнаяПлата], [Залог], [Условия]) VALUES (12, 22, 5, CAST(N'2023-04-01' AS Date), CAST(N'2023-09-30' AS Date), CAST(95000.00 AS Decimal(15, 2)), CAST(190000.00 AS Decimal(15, 2)), N'Коттедж с обслуживанием территории')
SET IDENTITY_INSERT [dbo].[ДоговорыАренды] OFF
GO
SET IDENTITY_INSERT [dbo].[Недвижимость] ON 

INSERT [dbo].[Недвижимость] ([id_недвижимости], [id_владельца], [id_типа], [id_статуса], [Адрес], [Площадь], [КоличествоКомнат], [Этаж], [Описание], [Цена]) VALUES (22, 1, 1, 1, N'г. Москва, ул. Ленина, д. 10, кв. 25', CAST(45.50 AS Decimal(10, 2)), 2, 5, N'Квартира с евроремонтом, мебелью и техникой', CAST(35000.00 AS Decimal(15, 2)))
INSERT [dbo].[Недвижимость] ([id_недвижимости], [id_владельца], [id_типа], [id_статуса], [Адрес], [Площадь], [КоличествоКомнат], [Этаж], [Описание], [Цена]) VALUES (23, 2, 1, 2, N'г. Москва, ул. Пушкина, д. 15, кв. 12', CAST(60.00 AS Decimal(10, 2)), 3, 2, N'Просторная трехкомнатная квартира с ремонтом', CAST(45000.00 AS Decimal(15, 2)))
INSERT [dbo].[Недвижимость] ([id_недвижимости], [id_владельца], [id_типа], [id_статуса], [Адрес], [Площадь], [КоличествоКомнат], [Этаж], [Описание], [Цена]) VALUES (24, 3, 2, 1, N'Московская обл., г. Красногорск, ул. Центральная, д. 5', CAST(120.00 AS Decimal(10, 2)), 5, NULL, N'Частный дом с участком 6 соток', CAST(80000.00 AS Decimal(15, 2)))
INSERT [dbo].[Недвижимость] ([id_недвижимости], [id_владельца], [id_типа], [id_статуса], [Адрес], [Площадь], [КоличествоКомнат], [Этаж], [Описание], [Цена]) VALUES (25, 1, 3, 1, N'г. Москва, ул. Тверская, д. 20, оф. 305', CAST(80.00 AS Decimal(10, 2)), 1, 3, N'Офисное помещение в центре с отделкой', CAST(120000.00 AS Decimal(15, 2)))
INSERT [dbo].[Недвижимость] ([id_недвижимости], [id_владельца], [id_типа], [id_статуса], [Адрес], [Площадь], [КоличествоКомнат], [Этаж], [Описание], [Цена]) VALUES (26, 4, 1, 3, N'г. Москва, ул. Гагарина, д. 42, кв. 18', CAST(55.00 AS Decimal(10, 2)), 2, 7, N'Квартира после черновой отделки, требуется ремонт', CAST(30000.00 AS Decimal(15, 2)))
INSERT [dbo].[Недвижимость] ([id_недвижимости], [id_владельца], [id_типа], [id_статуса], [Адрес], [Площадь], [КоличествоКомнат], [Этаж], [Описание], [Цена]) VALUES (27, 5, 2, 1, N'Московская обл., г. Химки, ул. Ленинградская, д. 12', CAST(90.00 AS Decimal(10, 2)), 4, NULL, N'Коттедж в закрытом поселке', CAST(95000.00 AS Decimal(15, 2)))
INSERT [dbo].[Недвижимость] ([id_недвижимости], [id_владельца], [id_типа], [id_статуса], [Адрес], [Площадь], [КоличествоКомнат], [Этаж], [Описание], [Цена]) VALUES (28, 2, 4, 1, N'Московская обл., Ленинский р-н, 25 км от МКАД', CAST(10.00 AS Decimal(10, 2)), 3, NULL, N'Земельный участок ИЖС, коммуникации по границе', CAST(5000000.00 AS Decimal(15, 2)))
INSERT [dbo].[Недвижимость] ([id_недвижимости], [id_владельца], [id_типа], [id_статуса], [Адрес], [Площадь], [КоличествоКомнат], [Этаж], [Описание], [Цена]) VALUES (29, 3, 5, 1, N'Московская обл., д. Заречье', CAST(60.00 AS Decimal(10, 2)), 3, NULL, N'Дача с баней и участком 8 соток', CAST(40000.00 AS Decimal(15, 2)))
SET IDENTITY_INSERT [dbo].[Недвижимость] OFF
GO
SET IDENTITY_INSERT [dbo].[Платежи] ON 

INSERT [dbo].[Платежи] ([id_платежа], [id_договора], [ДатаПлатежа], [Сумма], [id_типа], [id_статуса], [Описание]) VALUES (8, 9, CAST(N'2023-01-15' AS Date), CAST(90000.00 AS Decimal(15, 2)), 2, 2, N'Залог за квартиру на ул. Пушкина')
INSERT [dbo].[Платежи] ([id_платежа], [id_договора], [ДатаПлатежа], [Сумма], [id_типа], [id_статуса], [Описание]) VALUES (9, 9, CAST(N'2023-02-10' AS Date), CAST(45000.00 AS Decimal(15, 2)), 1, 2, N'Аренда за февраль')
INSERT [dbo].[Платежи] ([id_платежа], [id_договора], [ДатаПлатежа], [Сумма], [id_типа], [id_статуса], [Описание]) VALUES (10, 9, CAST(N'2023-03-10' AS Date), CAST(45000.00 AS Decimal(15, 2)), 1, 2, N'Аренда за март')
INSERT [dbo].[Платежи] ([id_платежа], [id_договора], [ДатаПлатежа], [Сумма], [id_типа], [id_статуса], [Описание]) VALUES (11, 9, CAST(N'2023-04-10' AS Date), CAST(45000.00 AS Decimal(15, 2)), 1, 3, N'Аренда за апрель')
INSERT [dbo].[Платежи] ([id_платежа], [id_договора], [ДатаПлатежа], [Сумма], [id_типа], [id_статуса], [Описание]) VALUES (12, 10, CAST(N'2023-03-01' AS Date), CAST(160000.00 AS Decimal(15, 2)), 2, 2, N'Залог за частный дом')
INSERT [dbo].[Платежи] ([id_платежа], [id_договора], [ДатаПлатежа], [Сумма], [id_типа], [id_статуса], [Описание]) VALUES (13, 10, CAST(N'2023-04-01' AS Date), CAST(80000.00 AS Decimal(15, 2)), 1, 2, N'Аренда за апрель')
INSERT [dbo].[Платежи] ([id_платежа], [id_договора], [ДатаПлатежа], [Сумма], [id_типа], [id_статуса], [Описание]) VALUES (14, 10, CAST(N'2023-05-01' AS Date), CAST(80000.00 AS Decimal(15, 2)), 1, 2, N'Аренда за май')
INSERT [dbo].[Платежи] ([id_платежа], [id_договора], [ДатаПлатежа], [Сумма], [id_типа], [id_статуса], [Описание]) VALUES (15, 11, CAST(N'2023-02-10' AS Date), CAST(240000.00 AS Decimal(15, 2)), 2, 2, N'Залог за офис')
INSERT [dbo].[Платежи] ([id_платежа], [id_договора], [ДатаПлатежа], [Сумма], [id_типа], [id_статуса], [Описание]) VALUES (16, 11, CAST(N'2023-03-10' AS Date), CAST(120000.00 AS Decimal(15, 2)), 1, 2, N'Аренда за март')
INSERT [dbo].[Платежи] ([id_платежа], [id_договора], [ДатаПлатежа], [Сумма], [id_типа], [id_статуса], [Описание]) VALUES (17, 12, CAST(N'2023-05-01' AS Date), CAST(95000.00 AS Decimal(15, 2)), 1, 2, N'Аренда за май')
SET IDENTITY_INSERT [dbo].[Платежи] OFF
GO
SET IDENTITY_INSERT [dbo].[СтатусыНедвижимости] ON 

INSERT [dbo].[СтатусыНедвижимости] ([id_статуса], [НазваниеСтатуса], [Описание]) VALUES (1, N'Свободна', N'Недвижимость доступна для аренды или продажи')
INSERT [dbo].[СтатусыНедвижимости] ([id_статуса], [НазваниеСтатуса], [Описание]) VALUES (2, N'Арендована', N'Недвижимость сдана в аренду')
INSERT [dbo].[СтатусыНедвижимости] ([id_статуса], [НазваниеСтатуса], [Описание]) VALUES (3, N'На ремонте', N'Проводятся ремонтные работы')
INSERT [dbo].[СтатусыНедвижимости] ([id_статуса], [НазваниеСтатуса], [Описание]) VALUES (4, N'Продана', N'Недвижимость продана и снята с учета')
INSERT [dbo].[СтатусыНедвижимости] ([id_статуса], [НазваниеСтатуса], [Описание]) VALUES (5, N'Забронирована', N'Недвижимость временно забронирована')
SET IDENTITY_INSERT [dbo].[СтатусыНедвижимости] OFF
GO
SET IDENTITY_INSERT [dbo].[СтатусыПлатежей] ON 

INSERT [dbo].[СтатусыПлатежей] ([id_статуса], [НазваниеСтатуса], [Описание]) VALUES (1, N'Ожидает оплаты', N'Платеж ожидает оплаты')
INSERT [dbo].[СтатусыПлатежей] ([id_статуса], [НазваниеСтатуса], [Описание]) VALUES (2, N'Оплачен', N'Платеж успешно проведен')
INSERT [dbo].[СтатусыПлатежей] ([id_статуса], [НазваниеСтатуса], [Описание]) VALUES (3, N'Просрочен', N'Платеж не произведен в срок')
INSERT [dbo].[СтатусыПлатежей] ([id_статуса], [НазваниеСтатуса], [Описание]) VALUES (4, N'Отменен', N'Платеж отменен')
INSERT [dbo].[СтатусыПлатежей] ([id_статуса], [НазваниеСтатуса], [Описание]) VALUES (5, N'Частично оплачен', N'Оплачена только часть суммы')
SET IDENTITY_INSERT [dbo].[СтатусыПлатежей] OFF
GO
SET IDENTITY_INSERT [dbo].[ТипыНедвижимости] ON 

INSERT [dbo].[ТипыНедвижимости] ([id_типа], [НазваниеТипа], [Описание]) VALUES (1, N'Квартира', N'Жилая квартира в многоквартирном доме')
INSERT [dbo].[ТипыНедвижимости] ([id_типа], [НазваниеТипа], [Описание]) VALUES (2, N'Частный дом', N'Отдельно стоящий жилой дом')
INSERT [dbo].[ТипыНедвижимости] ([id_типа], [НазваниеТипа], [Описание]) VALUES (3, N'Коммерческое помещение', N'Офис, магазин или другое нежилое помещение')
INSERT [dbo].[ТипыНедвижимости] ([id_типа], [НазваниеТипа], [Описание]) VALUES (4, N'Земельный участок', N'Участок земли под застройку или сельхозназначения')
INSERT [dbo].[ТипыНедвижимости] ([id_типа], [НазваниеТипа], [Описание]) VALUES (5, N'Дача', N'Загородный дом для сезонного проживания')
SET IDENTITY_INSERT [dbo].[ТипыНедвижимости] OFF
GO
SET IDENTITY_INSERT [dbo].[ТипыПлатежей] ON 

INSERT [dbo].[ТипыПлатежей] ([id_типа], [НазваниеТипа], [Описание]) VALUES (1, N'Арендная плата', N'Ежемесячный платеж за аренду')
INSERT [dbo].[ТипыПлатежей] ([id_типа], [НазваниеТипа], [Описание]) VALUES (2, N'Залог', N'Залоговый платеж при заключении договора')
INSERT [dbo].[ТипыПлатежей] ([id_типа], [НазваниеТипа], [Описание]) VALUES (3, N'Коммунальные платежи', N'Оплата ЖКХ услуг')
INSERT [dbo].[ТипыПлатежей] ([id_типа], [НазваниеТипа], [Описание]) VALUES (4, N'Штраф', N'Штрафные санкции за нарушения')
INSERT [dbo].[ТипыПлатежей] ([id_типа], [НазваниеТипа], [Описание]) VALUES (5, N'Дополнительные услуги', N'Оплата дополнительных услуг')
SET IDENTITY_INSERT [dbo].[ТипыПлатежей] OFF
GO
ALTER TABLE [dbo].[Арендаторы] ADD  DEFAULT (getdate()) FOR [ДатаРегистрации]
GO
ALTER TABLE [dbo].[Владельцы] ADD  DEFAULT (getdate()) FOR [ДатаРегистрации]
GO
ALTER TABLE [dbo].[ДоговорыАренды] ADD  DEFAULT ((0)) FOR [Залог]
GO
ALTER TABLE [dbo].[ИсторияСтатусов] ADD  DEFAULT (getdate()) FOR [ДатаИзменения]
GO
ALTER TABLE [dbo].[ДоговорыАренды]  WITH CHECK ADD FOREIGN KEY([id_арендатора])
REFERENCES [dbo].[Арендаторы] ([id_арендатора])
GO
ALTER TABLE [dbo].[ДоговорыАренды]  WITH CHECK ADD FOREIGN KEY([id_недвижимости])
REFERENCES [dbo].[Недвижимость] ([id_недвижимости])
GO
ALTER TABLE [dbo].[ИсторияСтатусов]  WITH CHECK ADD FOREIGN KEY([id_недвижимости])
REFERENCES [dbo].[Недвижимость] ([id_недвижимости])
GO
ALTER TABLE [dbo].[ИсторияСтатусов]  WITH CHECK ADD FOREIGN KEY([id_новогоСтатуса])
REFERENCES [dbo].[СтатусыНедвижимости] ([id_статуса])
GO
ALTER TABLE [dbo].[ИсторияСтатусов]  WITH CHECK ADD FOREIGN KEY([id_старогоСтатуса])
REFERENCES [dbo].[СтатусыНедвижимости] ([id_статуса])
GO
ALTER TABLE [dbo].[Недвижимость]  WITH CHECK ADD FOREIGN KEY([id_владельца])
REFERENCES [dbo].[Владельцы] ([id_владельца])
GO
ALTER TABLE [dbo].[Недвижимость]  WITH CHECK ADD FOREIGN KEY([id_статуса])
REFERENCES [dbo].[СтатусыНедвижимости] ([id_статуса])
GO
ALTER TABLE [dbo].[Недвижимость]  WITH CHECK ADD FOREIGN KEY([id_типа])
REFERENCES [dbo].[ТипыНедвижимости] ([id_типа])
GO
ALTER TABLE [dbo].[Платежи]  WITH CHECK ADD FOREIGN KEY([id_договора])
REFERENCES [dbo].[ДоговорыАренды] ([id_договора])
GO
ALTER TABLE [dbo].[Платежи]  WITH CHECK ADD FOREIGN KEY([id_статуса])
REFERENCES [dbo].[СтатусыПлатежей] ([id_статуса])
GO
ALTER TABLE [dbo].[Платежи]  WITH CHECK ADD FOREIGN KEY([id_типа])
REFERENCES [dbo].[ТипыПлатежей] ([id_типа])
GO
ALTER TABLE [dbo].[ДоговорыАренды]  WITH CHECK ADD  CONSTRAINT [CHK_Аренда] CHECK  (([ЕжемесячнаяПлата]>(0)))
GO
ALTER TABLE [dbo].[ДоговорыАренды] CHECK CONSTRAINT [CHK_Аренда]
GO
ALTER TABLE [dbo].[ДоговорыАренды]  WITH CHECK ADD  CONSTRAINT [CHK_Даты] CHECK  (([ДатаОкончания]>[ДатаНачала]))
GO
ALTER TABLE [dbo].[ДоговорыАренды] CHECK CONSTRAINT [CHK_Даты]
GO
ALTER TABLE [dbo].[Недвижимость]  WITH CHECK ADD  CONSTRAINT [CHK_Комнаты] CHECK  (([КоличествоКомнат]>=(0)))
GO
ALTER TABLE [dbo].[Недвижимость] CHECK CONSTRAINT [CHK_Комнаты]
GO
ALTER TABLE [dbo].[Недвижимость]  WITH CHECK ADD  CONSTRAINT [CHK_Площадь] CHECK  (([Площадь]>(0)))
GO
ALTER TABLE [dbo].[Недвижимость] CHECK CONSTRAINT [CHK_Площадь]
GO
ALTER TABLE [dbo].[Недвижимость]  WITH CHECK ADD  CONSTRAINT [CHK_Цена] CHECK  (([Цена]>=(0)))
GO
ALTER TABLE [dbo].[Недвижимость] CHECK CONSTRAINT [CHK_Цена]
GO
ALTER TABLE [dbo].[Платежи]  WITH CHECK ADD  CONSTRAINT [CHK_Сумма] CHECK  (([Сумма]>(0)))
GO
ALTER TABLE [dbo].[Платежи] CHECK CONSTRAINT [CHK_Сумма]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[30] 4[24] 2[10] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Недвижимость"
            Begin Extent = 
               Top = 9
               Left = 57
               Bottom = 206
               Right = 316
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AvailableProperties'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'AvailableProperties'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[33] 4[28] 2[22] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "д"
            Begin Extent = 
               Top = 9
               Left = 57
               Bottom = 206
               Right = 316
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "н"
            Begin Extent = 
               Top = 9
               Left = 343
               Bottom = 206
               Right = 602
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "т"
            Begin Extent = 
               Top = 21
               Left = 631
               Bottom = 191
               Right = 859
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "а"
            Begin Extent = 
               Top = 16
               Left = 1175
               Bottom = 213
               Right = 1443
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "в"
            Begin Extent = 
               Top = 17
               Left = 871
               Bottom = 214
               Right = 1139
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 11
         Width = 284
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Ali' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'АктивныеДоговоры'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'as = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'АктивныеДоговоры'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'АктивныеДоговоры'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[29] 4[27] 2[19] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "д"
            Begin Extent = 
               Top = 9
               Left = 57
               Bottom = 206
               Right = 316
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "н"
            Begin Extent = 
               Top = 4
               Left = 342
               Bottom = 201
               Right = 601
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "а"
            Begin Extent = 
               Top = 6
               Left = 622
               Bottom = 199
               Right = 890
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1780
         Width = 1850
         Width = 2680
         Width = 1000
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ИстекшиеДоговоры'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ИстекшиеДоговоры'
GO
USE [master]
GO
ALTER DATABASE [Аренда] SET  READ_WRITE 
GO
