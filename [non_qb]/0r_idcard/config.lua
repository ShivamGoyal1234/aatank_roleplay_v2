Config = {
    Framework = "qb", -- qb, esx
    ProgressBarType = "qb_progressbar", -- qb_progressbar, ox_progressbar, custom_progressbar
    BorrowOfVehicle = true, -- Can a player take a ped's vehicle with player work ID Card
    Locale = "en",
    IdCard = "id_card", -- Item name for ID Card
    JobCard = "job_card", -- Item name for Job Card
    FakeIdCard = "fake_id_card", -- Item name for Fake Id Card
    FakeJobCard = "fake_job_card", -- Item name for Fake Job Card
    DriverLicense = "driver_license", -- Item name for Driver License
    WeaponLicense = "weapons_license", -- Item name for Weapon License
    Inventory = 'quasar-inventory', -- [ 'qb-inventory' / 'ox_inventory' / 'quasar-inventory' / 'codem-inventory' ]
    InteractType = 'qb-target', -- = [ 'drawtext' / 'ox_target' / 'qb-target' ]

    UseQbLicense = true,
    UseEsxLicense = false,

    FakeCardPrice = 1000,

    BadgeAnimation = {
        dict = "paper_1_rcm_alt1-9",
        anim = "player_one_dual-9",
        prop = "prop_fib_badge",
    },

    FakeCardPed = {
        model = "s_m_y_cop_01",
        coords = vector4(0, 0, 0, 0),
    },

    JobCardPed = {
        model = "s_m_y_cop_01",
        coords = vector4(-554.39, -189.61, 38.22, 197.60),
    },
    
    Jobs = { -- you can add jobs here to open Job Card Create
        'police',
        'ambulance',
		'government',
    },

    GeneralCardPed = {
        model = "s_m_y_cop_01",
        coords = vector4(-553.59, -189.38, 38.22, 204.64),
    },

    BorrowWhitelist = {
        ["police"] = true,
    },

    GiveVehicleKey = function(plate)
        if Config.Framework == "qb" then
            TriggerEvent("vehiclekeys:client:SetOwner", plate)
        elseif Config.Framework == "esx" then
            TriggerServerEvent("esx_vehicleshop:giveVehicleKeys", plate)
        end
    end,

    CoreExport = function()
        if Config.Framework == "qb" then
            return exports["qb-core"]:GetCoreObject()
        elseif Config.Framework == "esx" then
            return exports["es_extended"]:getSharedObject()
        end
    end,

    Notify = function(message, type)
        if Config.Framework == "qb" then
            TriggerEvent('QBCore:Notify', message, type, 5000)
        else
            Framework.ShowNotification(message)
        end
    end,
    
    -- These are the card types that will be shown depend on the grade.
    CardTypes = {
        ["citizen"] = { -- This will be selected if player has non of the jobs below.
            job = "citizen", -- dont change this
            grades = {
                [0] = {
                    cardType = "one",
                    textColor = "#555555",
                    text = "Citizen Card",
                },
            }
        },
        ["driver"] = {
            job = "driver", -- dont change this
            grades = {
                [0] = {
                    cardType = "one",
                    textColor = "#555555",
                    text = "Drivers License",
                },
            }
        },
      --  ["weapon"] = {
         --   job = "weapon", -- dont change this
          --  grades = {
           --     [0] = {
                --    cardType = "one",
                --    textColor = "#FFFFFF",
                --    text = "Weapon License",
             --   },
        --    }
     --   },
        ["cardealer"] = { -- This will be selected if player has non of the jobs below.
            job = "cardealer", -- dont change this
            grades = {
                [0] = {
                    cardType = "one",
                    textColor = "#555555",
                    text = "PDM Card",
                },
            }
        },
        ["police"] = {
            job = "police",
            grades = {
                [0] = {
                    cardType = "one",
                    textColor = "#FFFFFF",
                    text = "Police Officer Card",
                },
                [1] = {
                    cardType = "one",
                    textColor = "#FFFFFF",
                    text = "Police Officer Card",
                },
                [2] = {
                    cardType = "two",
                    textColor = "#FFFFFF",
                    text = "Police Officer Card",
                },
                [3] = {
                    cardType = "two",
                    textColor = "#FFFFFF",
                    text = "Police Officer Card",
                },
                [4] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "Police Officer Card",
                },
                [5] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "Police Cheff Card",
                },
                [6] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "Police Cheff Card",
                },
            }
        },
        ["ambulance"] = {
            job = "ambulance",
            grades = {
                [0] = {
                    cardType = "one",
                    textColor = "#FFFFFF",
                    text = "Doctor Card",
                },
                [1] = {
                    cardType = "one",
                    textColor = "#FFFFFF",
                    text = "Doctor Card",
                },
                [2] = {
                    cardType = "two",
                    textColor = "#FFFFFF",
                    text = "Doctor Card",
                },
                [3] = {
                    cardType = "two",
                    textColor = "#FFFFFF",
                    text = "Doctor Card",
                },
                [4] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "Doctor Card",
                },
                [5] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "Doctor Card",
                },
                [6] = {
                    cardType = "four",
                    textColor = "#FFFFFF",
                    text = "Doctor Card",
                },
            }
        },
        ["government"] = {
            job = "government",
            grades = {
                [0] = {
                    cardType = "one",
                    textColor = "#FFFFFF",
                    text = "Government Card",
                },
                [1] = {
                    cardType = "one",
                    textColor = "#FFFFFF",
                    text = "Government Card",
                },
                [2] = {
                    cardType = "two",
                    textColor = "#FFFFFF",
                    text = "Government Card",
                },
                [3] = {
                    cardType = "two",
                    textColor = "#FFFFFF",
                    text = "Government Card",
                },
                [4] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "Government Card",
                },
                [5] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "Government Card",
                },
                [6] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "Government Card",
                },
            }
        },
        ["justice"] = {
            job = "justice",
            grades = {
                [0] = {
                    cardType = "one",
                    textColor = "#FFFFFF",
                    text = "Justice Card",
                },
                [1] = {
                    cardType = "one",
                    textColor = "#FFFFFF",
                    text = "Justice Card",
                },
                [2] = {
                    cardType = "two",
                    textColor = "#FFFFFF",
                    text = "Justice Card",
                },
                [3] = {
                    cardType = "two",
                    textColor = "#FFFFFF",
                    text = "Justice Card",
                },
                [4] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "Justice Card",
                },
                [5] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "Justice Card",
                },
                [6] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "Justice Card",
                },
            }
        },
        ["fib"] = {
            job = "fib",
            grades = {
                [0] = {
                    cardType = "one",
                    textColor = "#FFFFFF",
                    text = "F.I.B Card",
                },
                [1] = {
                    cardType = "one",
                    textColor = "#FFFFFF",
                    text = "F.I.B Card",
                },
                [2] = {
                    cardType = "two",
                    textColor = "#FFFFFF",
                    text = "F.I.B Card",
                },
                [3] = {
                    cardType = "two",
                    textColor = "#FFFFFF",
                    text = "F.I.B Card",
                },
                [4] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "F.I.B Card",
                },
                [5] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "F.I.B Card",
                },
                [6] = {
                    cardType = "three",
                    textColor = "#FFFFFF",
                    text = "F.I.B Card",
                },
            }
        },
    }
}