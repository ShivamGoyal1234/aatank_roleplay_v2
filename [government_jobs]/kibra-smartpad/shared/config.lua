---------------------------------------------------------------------------
-----------------------------FOR SETUP ------------------------------------
---https://docs.0resmon.org/0resmon/kibra-resources/kibra-smartpad---------
---------------------------------------------------------------------------

Shared = {}

Shared.Tablets = {}

Shared.Lang = 'en' -- Script Local Language

Shared.LangData = {} -- Language File

Shared.MetaDataSystem = true
-- Metadata is the ability for players to give their tablets to each other. 
-- To use this feature, you must have one of the following inventory list. See the documentation for more: https://docs.0resmon.org/0resmon/kibra-resources/kibra-smartpad

-- @Inventory List 
-- qb-inventory
-- ox_inventory
-- origen_inventory
-- qs-inventory
-- ls-inventory
-- lj-inventory
-- ps-inventory

Shared.ChargeDrainInterval = 1200000
-- Determines how often the tablet's battery level decreases (in milliseconds).
-- Example: 60000 = battery drops by 1% every 60 seconds.

Shared.MaxNoteNumber = 10 
-- Maximum number of notes players can create on the tablet.

Shared.DispatchSystem = 'kibra-dispatch'
-- || ps-dispatch || kibra-dispatch 

Shared.OpenTabletCommand = 'opentablet'
-- If Shared.MetaDataSystem is false, you can access the tablet using this command.

Shared.TabletItemName = 'smartpad'
-- This item name must be added to your server's item list. You can check the codes by checking the document.

Shared.WeaponLicenseItemName = 'wlicense'
-- This item name must be added to your server's item list. You can check the codes by checking the document.

Shared.TabletNotificationLocationInCloseTablet = 'top-right'
-- top-right
-- top-left
-- top-center
-- bottom-center
-- bottom-left
-- bottom-right

Shared.JudicialMode = "DOJ" -- "DOJ" or "POLICE"
-- If Judicial Mode is set to ‘POLICE’, dojapp will not work. 
-- All offences and decisions are made by the police. 
-- But if it is set as ‘DOJ’, the police cannot decide alone. The offence records created are forwarded to the DOJ and reviewed by them.

Shared.CourtRooms = {
    [1] = {
        RoomName = 'Saloon 1',
        Coords = vec3(100.0, 200.0, 30.0)
    },
    [2] = {
        RoomName = 'Saloon 2',
        Coords = vec3(120.0, 300.0, 40.0)
    },
    [3] = {
        RoomName = 'Saloon 3',
        Coords = vec3(80.0, 150.0, 25.0)
    }
}

Shared.DojAppJobs = {
    lawyers = {
        ["lawyer"] = {0,1,2},
        ["police"] = {8}
    },

    prosecutors = {
        ["prosecutor"] = {0,1,2},
        ["police"] = {8}
    },

    judges = {
        ["judge"] = {0,1,2},
        ["police"] = {8}
    },
}

Shared.Domain = 'aatank.com'
-- The server name of the e-mail addresses of the players. You can give any name you want.

Shared.MDTMail = {
    Mail = 'lossantospd@aatank.com',
    AccountName = 'Los Santos Police Department'
}

Shared.DOJAppMail = {
    Mail = 'dojapp@aatank.com',
    AccountName = 'Department of Justice'
}

Shared.WeazelAppMail = {
    Mail = 'weazelnews@aatank.com',
    AccountName = 'Weazel News'
}

Shared.BillingCompanies = {
    ["police"] = {AccountName = 'Los Santos Police Department', Mail = 'lossantospd@aatank.com'},
    ["ambulance"] = {AccountName = 'Emergency Medical Services', Mail = 'emergencyservices@aatank.com'},
    ["mechanic"] = {AccountName = 'Los Santos Custom Workshop', Mail = 'lsworkshop@aatank.com'}
}

Shared.PoliceFinesDueDate = 5
-- The fines issued by the police officers via the MDT will be considered unpaid if they are not paid after the day specified here.

Shared.TabletProp = 'prop_cs_tablet'

Shared.GiveTabletCommandName = 'givetablet' -- Usage: /givetablet ID

Shared.PowerBankItemName = 'powerbank'
-- A device that functions as a portable charger for charging the tablet.

Shared.PowerBankChargeValue = 90
-- When using Powerbank, it is the value that determines how much the tablet will charge.

Shared.TabletChargeUsageTime = 10
-- 

Shared.TemperatureUnit = 'C' 
-- 'C' indicates °C, 'F' indicates °F

Shared.Backgrounds = {
    { label = "default", url = "/web/build/default-background.jpg" },
    { label = "res", url = "/web/build/res-background.jpg" },
    { label = "blue", url = "/web/build/blue-background.jpg" },
    { label = "city", url = "/web/build/city-background.jpg" },
    { label = "colorful", url = "/web/build/colorful-background.jpg" },
    { label = 'lspd', url = "/web/build/lspd-background.jpg", job = Shared.MDTOfficers}
}

Shared.Languages = {
    ["en"] = "English",
    ["tr"] = "Türkçe",
    ["ru"] = 'Русский',
    ["plk"] = 'Polski',
    ["es"] = 'Español',
    ["fr"] = 'French'
}

Shared.InvoiceAllowedJobs = {
    ["mechanic"] = {4}
}

Shared.ShownOnMDTMap = {
    ["police"] = true
}

Shared.ShownOnEMSMap = {
    ["ambulance"] = true
}

Shared.MDTAppBossGradeLevels = {10}

Shared.EMSAppBossGradeLevels = {8}

Shared.EMSParamedics = {
    'ambulance'
}

Shared.SalesmanData = {
    PedCoords = vec4(82.90, -225.18, 54.63, 249.38),
    PedHash = `a_m_m_business_01`,
    Name = 'Tablet',
    TabletPrice = 10000
}

Shared.UnemployedJobData = {
    name = 'unemployed',
    grade = 0
}

Shared.MDTOfficers = {
    'police',
    'sheriff'
}

Shared.JournalistJob = 'reporter'
