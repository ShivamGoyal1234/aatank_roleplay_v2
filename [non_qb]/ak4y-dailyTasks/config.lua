-- ak4y dev.

-- IF YOU HAVE ANY PROBLEM OR DO YOU NEED HELP PLS COME TO MY DISCORD SERVER AND CREATE A TICKET
-- IF YOU DONT HAVE ANY PROBLEM YET AGAIN COME TO MY DISCORD :)
-- https://discord.gg/kWwM3Bx

AK4Y = {}

AK4Y.Framework = "qb" -- qb / oldqb | qb = export system | oldqb = triggerevent system
AK4Y.Mysql = "oxmysql" -- Check fxmanifest.lua when you change it! | ghmattimysql / oxmysql / mysql-async
AK4Y.StandartTaskDay = 1 -- ALL TASKS ARE ONE DAY
AK4Y.MenuCommand = "daily" -- open menu command

AK4Y.Language = {
    title1 = "ARP",
    title2 = "DAILY TASK",
    description = "DAILY TASK WHICH GIVE YOU REWARDS.",
    cancelMission = "CANCEL MISSION",
    remaining = "REMAINING TIME",
    received = "Award Received.",
    error = "An error occured during task purchase",
    reward = "REWARD :",
    lock = "LOCK",
    taskStartPrice = "TASK START PRICE",
    getReward = "GET REWARD",
}

AK4Y.Tasks = {
    {
        taskId = 1,
        name = "Stay in play for 1 hour",
        description = "After purchasing the mission, you need to stay in the game for a total of 1 hour within 1 day. If you fail, the money you invested will be lost.",
        reward = 30000,
        taskPrice = 1500,
        neededPlayTime = 60, -- MINUTES
        image = "./images/Group10.png",
    },
    {
        taskId = 2,
        name = "Stay in play for 2 hour",
        description = "After purchasing the mission, you need to stay in the game for a total of 2 hour within 1 day. If you fail, the money you invested will be lost.",
        reward = 40000,
        taskPrice = 2000,
        neededPlayTime = 120, -- MINUTES
        image = "./images/Group11.png",
    },
    {
        taskId = 3,
        name = "Stay in play for 3 hour",
        description = "After purchasing the mission, you need to stay in the game for a total of 3 hour within 1 day. If you fail, the money you invested will be lost.",
        reward = 50000,
        taskPrice = 2500,
        neededPlayTime = 180, -- MINUTES
        image = "./images/Group12.png",
    },
    {
        taskId = 4,
        name = "Stay in play for 4 hour",
        description = "After purchasing the mission, you need to stay in the game for a total of 4 hour within 1 day. If you fail, the money you invested will be lost.",
        reward = 60000,
        taskPrice = 3000,
        neededPlayTime = 240, -- MINUTES
        image = "./images/Group13.png",
    },
    {
        taskId = 5,
        name = "Stay in play for 5 hour",
        description = "After purchasing the mission, you need to stay in the game for a total of 5 hour within 1 day. If you fail, the money you invested will be lost.",
        reward = 70000,
        taskPrice = 3500,
        neededPlayTime = 300, -- MINUTES
        image = "./images/Group14.png",
    },
    {
        taskId = 6,
        name = "Stay in play for 6 hour",
        description = "After purchasing the mission, you need to stay in the game for a total of 6 hour within 1 day. If you fail, the money you invested will be lost.",
        reward = 80000,
        taskPrice = 4000,
        neededPlayTime = 360, -- MINUTES
        image = "./images/Group16.png",
    },
    {
        taskId = 7,
        name = "Stay in play for 7 hour",
        description = "After purchasing the mission, you need to stay in the game for a total of 7 hour within 1 day. If you fail, the money you invested will be lost.",
        reward = 90000,
        taskPrice = 4500,
        neededPlayTime = 420, -- MINUTES
        image = "./images/Group17.png",
    },
    {
        taskId = 8,
        name = "Stay in play for 8 hour",
        description = "After purchasing the mission, you need to stay in the game for a total of 8 hour within 1 day. If you fail, the money you invested will be lost.",
        reward = 100000,
        taskPrice = 5000,
        neededPlayTime = 480, -- MINUTES
        image = "./images/Group18.png",
    },
    {
        taskId = 9,
        name = "Stay in play for 9 hour",
        description = "After purchasing the mission, you need to stay in the game for a total of 9 hour within 1 day. If you fail, the money you invested will be lost.",
        reward = 200000,
        taskPrice = 7500,
        neededPlayTime = 540, -- MINUTES
        image = "./images/Group19.png",
    },
}