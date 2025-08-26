-- These hooks are fired AUTOMATICALLY by forge-jobs every time a player
-- completes a job action (mine ore, cut a tree, catch a fish, …).
--
-- Leave them EMPTY if you don't want any integration.
-- Add as many exports / SQL / webhooks as you like inside each function.
--
-- USAGE EXAMPLES:
-- 1. Experience Points and Leveling Systems: Add XP to your custom leveling system
-- 2. Achievement Systems: Track progress toward milestones or achievements
-- 3. Economy Effects: Adjust economic values based on resource gathering
-- 4. Environmental Impact: Track ecological footprint with karma/ethics systems
-- 5. Discord Integration: Send resource gathering data to webhooks
-- 6. Admin Logging: Monitor player activities for moderation purposes
--
-- ────────────────────────────────────────────────────────────────────────
-- CLIENT-SIDE HOOK
-- ────────────────────────────────────────────────────────────────────────
-- function JobActionClient(action, amount)
--     @param action  : string   Exact identifier of the action:
--                               "Mining"           – broke a rock
--                               "Lumberjack"       – felled a tree
--                               "Fishing"          – caught a fish
--                               "Hunting"          – skinned an animal
--                               "Farming"          – harvested crops
--                               "Recycling_Trash"  – searched through trash
--                               "Recycling_Scrap"  – scrapped a vehicle
--     @param amount  : number   Units / base XP you decide to send
-- Runs only on the client that performed the action—perfect for season
-- passes or local achievement systems that live purely on the client side.

function JobActionClient(action, amount)
    -- Debug messages - only shown when Config.Debug is true
    if Config.Debug then
        if action == "Mining" then
            print("^2[JOB HOOKS CLIENT]^7 Mining action detected!")
        elseif action == "Lumberjack" then
            print("^2[JOB HOOKS CLIENT]^7 Lumberjack action detected!")
        elseif action == "Fishing" then
            print("^2[JOB HOOKS CLIENT]^7 Fishing action detected!")
        elseif action == "Hunting" then
            print("^2[JOB HOOKS CLIENT]^7 Hunting action detected!")
        elseif action == "Farming" then
            print("^2[JOB HOOKS CLIENT]^7 Farming action detected!")
        elseif action == "Recycling_Trash" then
            print("^2[JOB HOOKS CLIENT]^7 Trash recycled detected!")
        elseif action == "Recycling_Scrap" then
            print("^2[JOB HOOKS CLIENT]^7 Vehicle scrapped detected!")
        else
            print("^2[JOB HOOKS CLIENT]^7 Unknown action: " .. action)
        end
    end
    
    -- EXAMPLES (delete / edit as needed):
    -- exports['seasonpass']:AddXP(action, amount)             -- season pass
    -- exports['local_achievements']:Progress(action, amount) -- achievements
end

-- ────────────────────────────────────────────────────────────────────────
-- SERVER-SIDE HOOK
-- ────────────────────────────────────────────────────────────────────────
-- function JobActionServer(src, action, amount)
--     @param src     : number   Server-side player ID
--     @param action  : string   Same identifiers as above
--     @param amount  : number   Units / XP / points
-- Runs on the server—use it for databases, global leaderboards,
-- ethics/karma scores, Discord webhooks, etc.
function JobActionServer(src, action, amount)
    -- Debug messages - only shown when Config.Debug is true
    if Config.Debug then
        if action == "Mining" then
            print("^3[JOB HOOKS SERVER]^7 Mining action detected from player " .. src)
        elseif action == "Lumberjack" then
            print("^3[JOB HOOKS SERVER]^7 Lumberjack action detected from player " .. src)
        elseif action == "Fishing" then
            print("^3[JOB HOOKS SERVER]^7 Fishing action detected from player " .. src)
        elseif action == "Hunting" then
            print("^3[JOB HOOKS SERVER]^7 Hunting action detected from player " .. src)
        elseif action == "Farming" then
            print("^3[JOB HOOKS SERVER]^7 Farming action detected from player " .. src)
        elseif action == "Recycling_Trash" then
            print("^3[JOB HOOKS SERVER]^7 Trash recycled detected from player " .. src)
        elseif action == "Recycling_Scrap" then
            print("^3[JOB HOOKS SERVER]^7 Vehicle scrapped detected from player " .. src)
        else
            print("^3[JOB HOOKS SERVER]^7 Unknown action: " .. action .. " from player " .. src)
        end
    end
    
    -- EXAMPLES (delete / edit as needed):
    -- exports['ethicscore']:AddPoints(src, action, amount * -5)  -- eco karma
    -- exports['leaderboard']:Update(src, action, amount)         -- ranking
    -- exports['discord_webhooks']:LogJobAction(src, action, amount)
end
