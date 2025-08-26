local QBCore = exports['qb-core']:GetCoreObject()
local Accounts = {}
local Statements = {}

-- Functions

local function getPlayerAndCitizenId(playerId)
    local Player = QBCore.Functions.GetPlayer(playerId)
    if not Player then return nil, nil end
    return Player, Player.PlayerData.citizenid
end

local function GetNumberOfAccounts(citizenid)
    local numberOfAccounts = 0
    for _, account in pairs(Accounts) do
        if account.citizenid == citizenid then
            numberOfAccounts = numberOfAccounts + 1
        end
    end
    return numberOfAccounts
end

-- Exported Functions

local function CreatePlayerAccount(playerId, accountName, accountBalance, accountUsers)
    local Player, citizenid = getPlayerAndCitizenId(playerId)
    if not Player or not citizenid then return false end

    if Accounts[accountName] then
        return false
    end

    Accounts[accountName] = {
        citizenid = citizenid,
        account_name = accountName,
        account_balance = accountBalance,
        account_type = 'shared',
        users = accountUsers
    }

    local insertSuccess = MySQL.insert.await('INSERT INTO bank_accounts (citizenid, account_name, account_balance, account_type, users) VALUES (?, ?, ?, ?, ?)', { citizenid, accountName, accountBalance, 'shared', accountUsers })
    return insertSuccess
end
exports('CreatePlayerAccount', CreatePlayerAccount)

local function CreateJobAccount(accountName, accountBalance)
    Accounts[accountName] = {
        account_name = accountName,
        account_balance = accountBalance,
        account_type = 'job'
    }
    local insertSuccess = MySQL.insert.await('INSERT INTO bank_accounts (account_name, account_balance, account_type) VALUES (?, ?, ?)', { accountName, accountBalance, 'job' })
    return insertSuccess
end
exports('CreateJobAccount', CreateJobAccount)

local function CreateGangAccount(accountName, accountBalance)
    Accounts[accountName] = {
        account_name = accountName,
        account_balance = accountBalance,
        account_type = 'gang'
    }
    local insertSuccess = MySQL.insert.await('INSERT INTO bank_accounts (account_name, account_balance, account_type) VALUES (?, ?, ?)', { accountName, accountBalance, 'gang' })
    return insertSuccess
end
exports('CreateGangAccount', CreateGangAccount)

local function CreateBankStatement(playerId, account, amount, reason, statementType, accountType)
    local Player, citizenid = getPlayerAndCitizenId(playerId)
    if not Player or not citizenid then return false end

    local newStatement = {
        citizenid = citizenid,
        amount = amount,
        reason = reason,
        date = os.time() * 1000,
        statement_type = statementType
    }
    if accountType == 'player' or accountType == 'shared' then
        if accountType == 'player' then account = 'personal account' end
        if not Statements[citizenid] then Statements[citizenid] = {} end
        if not Statements[citizenid][account] then Statements[citizenid][account] = {} end
        Statements[citizenid][account][#Statements[citizenid][account] + 1] = newStatement
    else
        if not Statements[account] then Statements[account] = {} end
        Statements[account][#Statements[account] + 1] = newStatement
    end

    local insertSuccess = MySQL.insert.await('INSERT INTO bank_statements (citizenid, account_name, amount, reason, statement_type) VALUES (?, ?, ?, ?, ?)', { citizenid, account, amount, reason, statementType })
    if not insertSuccess then return false end
    return true
end
exports('CreateBankStatement', CreateBankStatement)

local function AddMoney(accountName, amount, reason)
    if not reason then reason = 'External Deposit' end
    local newStatement = {
        amount = amount,
        reason = reason,
        date = os.time() * 1000,
        statement_type = 'deposit'
    }
    if Accounts[accountName] then
        local accountToUpdate = Accounts[accountName]
        accountToUpdate.account_balance = accountToUpdate.account_balance + amount
        if not Statements[accountName] then Statements[accountName] = {} end
        Statements[accountName][#Statements[accountName] + 1] = newStatement
        MySQL.insert.await('INSERT INTO bank_statements (account_name, amount, reason, statement_type) VALUES (?, ?, ?, ?)', { accountName, amount, reason, 'deposit' })
        local updateSuccess = MySQL.update.await('UPDATE bank_accounts SET account_balance = account_balance + ? WHERE account_name = ?', { amount, accountName })
        return updateSuccess
    end
    return false
end
exports('AddMoney', AddMoney)
exports('AddGangMoney', AddMoney)

local function RemoveMoney(accountName, amount, reason)
    if not reason then reason = 'External Withdrawal' end
    local newStatement = {
        amount = amount,
        reason = reason,
        date = os.time() * 1000,
        statement_type = 'withdraw'
    }
    if Accounts[accountName] then
        local accountToUpdate = Accounts[accountName]
        accountToUpdate.account_balance = accountToUpdate.account_balance - amount
        if not Statements[accountName] then Statements[accountName] = {} end
        Statements[accountName][#Statements[accountName] + 1] = newStatement
        MySQL.insert.await('INSERT INTO bank_statements (account_name, amount, reason, statement_type) VALUES (?, ?, ?, ?)', { accountName, amount, reason, 'withdraw' })
        local updateSuccess = MySQL.update.await('UPDATE bank_accounts SET account_balance = account_balance - ? WHERE account_name = ?', { amount, accountName })
        return updateSuccess
    end
    return false
end
exports('RemoveMoney', RemoveMoney)
exports('RemoveGangMoney', RemoveMoney)

local function GetAccount(accountName)
    if Accounts[accountName] then
        return Accounts[accountName]
    end
    return nil
end
exports('GetAccount', GetAccount)
exports('GetGangAccount', GetAccount)

local function GetAccountBalance(accountName)
    local account = GetAccount(accountName)
    return account and account.account_balance or 0
end
exports('GetAccountBalance', GetAccountBalance)

-- Callbacks

QBCore.Functions.CreateCallback('qb-banking:server:openBank', function(source, cb)
    local src = source
    local Player, citizenid = getPlayerAndCitizenId(src)
    if not Player or not citizenid then return end
    local job = Player.PlayerData.job
    local gang = Player.PlayerData.gang
    local accounts = {}
    local statements = {}
    local debitCardResult = MySQL.query.await('SELECT card_number, card_pin, card_holder_name FROM debit_cards WHERE citizenid = ? AND account_name = ?', { citizenid, 'personal account' })
    local cardToSend = nil
    if debitCardResult and #debitCardResult > 0 then
        cardToSend = debitCardResult[1]
    end
    Player.PlayerData.debitCard = cardToSend -- Attach debit card data to PlayerData

    if job.name ~= 'unemployed' and not Accounts[job.name] then CreateJobAccount(job.name, 0) end
    if gang.name ~= 'none' and not Accounts[gang.name] then CreateGangAccount(gang.name, 0) end
    accounts[#accounts + 1] = { account_name = 'personal account', account_type = 'checking', account_balance = Player.PlayerData.money.bank }
    statements['personal account'] = Statements[citizenid] and Statements[citizenid]['personal account'] or {}
    for accountName, accountInfo in pairs(Accounts) do
        if accountInfo.citizenid == citizenid then
            accounts[#accounts + 1] = accountInfo
            if Statements[accountName] then statements[accountName] = Statements[accountName] end
        end
        if accountInfo.users and type(accountInfo.users) == 'string' then
            local sharedUsers = json.decode(accountInfo.users)
            local hasAccess = false
            for _, user in ipairs(sharedUsers) do
                if user == citizenid then
                    hasAccess = true
                    break
                end
            end
            if hasAccess then
                accounts[#accounts + 1] = accountInfo
                if Statements[accountName] then statements[accountName] = Statements[accountName] end
            end
        end
        if (accountName == job.name and job.isboss) or (accountName == gang.name and gang.isboss) then
            accounts[#accounts + 1] = accountInfo
            if Statements[accountName] then statements[accountName] = Statements[accountName] end
        end
    end
    cb(accounts, statements, Player.PlayerData)
end)

QBCore.Functions.CreateCallback('qb-banking:server:openATM', function(source, cb)
    local src = source
    local Player, citizenid = getPlayerAndCitizenId(src)
    if not Player or not citizenid then return end

    -- Check for debit card possession instead of any bank card
    local debitCardItem = Player.Functions.GetItemByName('bank_card')
    if not debitCardItem then
        
        return cb({ success = false, message = Lang:t('error.card') })
    end


    -- Retrieve card_pin from the debit_cards table using the card_number from item.info
    local debitCardResult = MySQL.query.await('SELECT card_number, card_pin, card_holder_name FROM debit_cards WHERE card_number = ?', { debitCardItem.info.cardNumber })
    local cardData = nil
    if debitCardResult and #debitCardResult > 0 then
        cardData = debitCardResult[1]
     
    else
        
    end

    local job = Player.PlayerData.job
    local gang = Player.PlayerData.gang
    local accounts = {}

    -- Only allow personal account for ATM operations as per user request
    accounts[#accounts + 1] = { account_name = 'personal account', account_type = 'checking', account_balance = Player.PlayerData.money.bank }

    cb({ accounts = accounts, playerData = Player.PlayerData, success = true, cardData = cardData })
end)

-- New Server Callback to verify PIN from card data
QBCore.Functions.CreateCallback('qb-banking:server:verifyCardPin', function(source, cb, data)
    local src = source
    local Player, citizenid = getPlayerAndCitizenId(src)

    if not Player or not citizenid then

        return cb({ success = false, message = Lang:t('error.error') })
    end

    local cardPinFromClient = data.cardPin -- This is the PIN from the client-side card metadata
    local cardNumber = data.cardNumber

    

    if not cardPinFromClient or not cardNumber then
        
        return cb({ success = false, message = Lang:t('error.error') })
    end

    local debitCardResult = MySQL.query.await('SELECT card_pin FROM debit_cards WHERE citizenid = ? AND card_number = ?', { citizenid, cardNumber })
    if debitCardResult and #debitCardResult > 0 then
        local storedPin = debitCardResult[1].card_pin
       
        if tostring(storedPin) == tostring(cardPinFromClient) then -- Ensure both are strings for comparison
           
            cb({ success = true })
        else
           
            cb({ success = false, message = Lang:t('error.pin') })
        end
    else
      
        cb({ success = false, message = Lang:t('error.card') })
    end
end)

QBCore.Functions.CreateCallback('qb-banking:server:verifyPin', function(source, cb, data)
    local src = source
    local Player, citizenid = getPlayerAndCitizenId(src)
   
    if not Player or not citizenid then

        return cb({ success = false, message = Lang:t('error.error') })
    end

    local enteredPin = data.enteredPin
    local cardPin = data.cardPin -- This is the PIN from the client-side card metadata
    local cardNumber = data.cardNumber

   

    if not enteredPin or not cardPin or not cardNumber then
        
        return cb({ success = false, message = Lang:t('error.error') })
    end

    local debitCardResult = MySQL.query.await('SELECT card_pin FROM debit_cards WHERE citizenid = ? AND card_number = ?', { citizenid, cardNumber })
    if debitCardResult and #debitCardResult > 0 then
        local storedPin = debitCardResult[1].card_pin
        
        if storedPin == enteredPin then
            
            cb({ success = true })
        else
           
            cb({ success = false, message = Lang:t('error.pin') })
        end
    else
       
        cb({ success = false, message = Lang:t('error.card') })
    end
end)

QBCore.Functions.CreateCallback('qb-banking:server:withdraw', function(source, cb, data)
    local src = source
    local Player, citizenid = getPlayerAndCitizenId(src)
    if not Player or not citizenid then return cb({ success = false, message = Lang:t('error.error') }) end
    local accountName = data.accountName
    local withdrawAmount = tonumber(data.amount)
    local reason = (data.reason ~= '' and data.reason) or 'Bank Withdrawal'
    if accountName == 'personal account' then
        local accountBalance = Player.PlayerData.money.bank
        if accountBalance < withdrawAmount then return cb({ success = false, message = Lang:t('error.money') }) end
        Player.Functions.RemoveMoney('bank', withdrawAmount, 'bank withdrawal')
        Player.Functions.AddMoney('cash', withdrawAmount, 'bank withdrawal')
        if not CreateBankStatement(src, 'personal account', withdrawAmount, reason, 'withdraw', 'player') then return cb({ success = false, message = Lang:t('error.error') }) end
        cb({ success = true, message = Lang:t('success.withdraw') })
    end
    if Accounts[accountName] then
        local job = Player.PlayerData.job
        local gang = Player.PlayerData.gang
        if Accounts[accountName].account_type == 'job' and job.name ~= accountName and not job.isboss then return cb({ success = false, message = Lang:t('error.access') }) end
        if Accounts[accountName].account_type == 'gang' and gang.name ~= accountName and not gang.isboss then return cb({ success = false, message = Lang:t('error.access') }) end
        local accountBalance = GetAccountBalance(accountName)
        if accountBalance < withdrawAmount then return cb({ success = false, message = Lang:t('error.money') }) end
        if not RemoveMoney(accountName, withdrawAmount) then return cb({ success = false, message = Lang:t('error.error') }) end
        Player.Functions.AddMoney('cash', withdrawAmount, 'bank account: ' .. accountName .. ' withdrawal')
        if not CreateBankStatement(src, accountName, withdrawAmount, reason, 'withdraw', Accounts[accountName].account_type) then return cb({ success = false, message = Lang:t('error.error') }) end
        cb({ success = true, message = Lang:t('success.withdraw') })
    end
end)

QBCore.Functions.CreateCallback('qb-banking:server:deposit', function(source, cb, data)
    local src = source
    local Player, citizenid = getPlayerAndCitizenId(src)
    if not Player or not citizenid then return cb({ success = false, message = Lang:t('error.error') }) end

    local accountName = data.accountName
    local depositAmount = tonumber(data.amount)
    local reason = (data.reason ~= '' and data.reason) or 'Bank Deposit'
    local cashAmount = Player.PlayerData.money.cash

    local taxAmount = 0
    if Config.DepositTaxPercentage and Config.DepositTaxPercentage > 0 then
        taxAmount = math.floor((depositAmount * Config.DepositTaxPercentage) / 100)
    end
    local amountAfterTax = depositAmount - taxAmount

    -- Check if player has enough cash for the gross deposit amount (including what will be taxed)
    if cashAmount < depositAmount then
        return cb({ success = false, message = Lang:t('error.money') })
    end
    
    -- Check if the amount after tax is still positive
    if amountAfterTax <= 0 then
        return cb({ success = false, message = Lang:t('error.error') }) -- or a more specific message if available
    end

    -- Remove the full intended deposit amount from cash (tax included in this removal)
    Player.Functions.RemoveMoney('cash', depositAmount, 'bank deposit - gross')

    if accountName == 'personal account' then
        Player.Functions.AddMoney('bank', amountAfterTax, reason) -- Add net amount to bank
        CreateBankStatement(src, 'personal account', amountAfterTax, reason, 'deposit', 'player')
        cb({ success = true, message = Lang:t('success.deposit') .. (taxAmount > 0 and ' (Tax deducted: $' .. taxAmount .. ')' or '') })
    elseif Accounts[accountName] then
        local job = Player.PlayerData.job
        local gang = Player.PlayerData.gang
        if Accounts[accountName].account_type == 'job' and job.name ~= accountName and not job.isboss then
            Player.Functions.AddMoney('cash', depositAmount, 'deposit failed refund') -- Refund if access denied
            return cb({ success = false, message = Lang:t('error.access') })
        end
        if Accounts[accountName].account_type == 'gang' and gang.name ~= accountName and not gang.isboss then
            Player.Functions.AddMoney('cash', depositAmount, 'deposit failed refund') -- Refund if access denied
            return cb({ success = false, message = Lang:t('error.access') })
        end

        if not AddMoney(accountName, amountAfterTax, reason) then -- Add net amount to shared/job/gang account
            Player.Functions.AddMoney('cash', depositAmount, 'deposit failed refund') -- Refund on DB error
            return cb({ success = false, message = Lang:t('error.error') })
        end
        CreateBankStatement(src, accountName, amountAfterTax, reason, 'deposit', Accounts[accountName].account_type)
        cb({ success = true, message = Lang:t('success.deposit') .. (taxAmount > 0 and ' (Tax deducted: $' .. taxAmount .. ')' or '') })
    else
        Player.Functions.AddMoney('cash', depositAmount, 'deposit failed refund') -- Refund for invalid account
        cb({ success = false, message = Lang:t('error.error') }) -- Specific error message is better but not in Lang:t yet.
    end
end)

QBCore.Functions.CreateCallback('qb-banking:server:internalTransfer', function(source, cb, data)
    local src = source
    local Player, citizenid = getPlayerAndCitizenId(src)
    if not Player or not citizenid then return cb({ success = false, message = Lang:t('error.error') }) end
    local job = Player.PlayerData.job
    local gang = Player.PlayerData.gang
    local fromAccountName = data.fromAccountName
    local toAccountName = data.toAccountName
    local transferAmount = tonumber(data.amount)
    local reason = (data.reason ~= '' and data.reason) or 'Internal transfer'
    if fromAccountName == 'personal account' then
        if Player.PlayerData.money.bank < transferAmount then return cb({ success = false, message = Lang:t('error.money') }) end
        Player.Functions.RemoveMoney('bank', transferAmount, reason)
        if toAccountName == 'personal account' then
            Player.Functions.AddMoney('bank', transferAmount, reason)
        else
            if not AddMoney(toAccountName, transferAmount) then return cb({ success = false, message = Lang:t('error.error') }) end
        end
        if not CreateBankStatement(src, 'personal account', transferAmount, reason, 'withdraw', 'player') then return cb({ success = false, message = Lang:t('error.error') }) end
        cb({ success = true, message = Lang:t('success.transfer') })
    elseif toAccountName == 'personal account' then
        if Accounts[fromAccountName].account_type == 'job' and job.name ~= fromAccountName and not job.isboss then return cb({ success = false, message = Lang:t('error.access') }) end
        if Accounts[fromAccountName].account_type == 'gang' and gang.name ~= fromAccountName and not gang.isboss then return cb({ success = false, message = Lang:t('error.access') }) end
        local fromAccountBalance = GetAccountBalance(fromAccountName)
        if fromAccountBalance < transferAmount then return cb({ success = false, message = Lang:t('error.money') }) end
        if not RemoveMoney(fromAccountName, transferAmount) then return cb({ success = false, message = Lang:t('error.error') }) end
        Player.Functions.AddMoney('bank', transferAmount, reason)
        if not CreateBankStatement(src, 'personal account', transferAmount, reason, 'deposit', 'player') then return cb({ success = false, message = Lang:t('error.error') }) end
        cb({ success = true, message = Lang:t('success.transfer') })
    else
        if Accounts[fromAccountName].account_type == 'job' and job.name ~= fromAccountName and not job.isboss then return cb({ success = false, message = Lang:t('error.access') }) end
        if Accounts[fromAccountName].account_type == 'gang' and gang.name ~= fromAccountName and not gang.isboss then return cb({ success = false, message = Lang:t('error.access') }) end
        local fromAccountBalance = GetAccountBalance(fromAccountName)
        if fromAccountBalance < transferAmount then return cb({ success = false, message = Lang:t('error.money') }) end
        if not RemoveMoney(fromAccountName, transferAmount) then return cb({ success = false, message = Lang:t('error.error') }) end
        if not AddMoney(toAccountName, transferAmount) then return cb({ success = false, message = Lang:t('error.error') }) end
        cb({ success = true, message = Lang:t('success.transfer') })
    end
end)

QBCore.Functions.CreateCallback('qb-banking:server:externalTransfer', function(source, cb, data)
    local src = source
    local Player, citizenid = getPlayerAndCitizenId(src)
    if not Player or not citizenid then return cb({ success = false, message = Lang:t('error.error') }) end
    local job = Player.PlayerData.job
    local gang = Player.PlayerData.gang
    local toAccountName = data.toAccountNumber
    local toPlayer = QBCore.Functions.GetPlayerByCitizenId(toAccountName)
    if not toPlayer then return cb({ success = false, message = Lang:t('error.error') }) end
    local fromAccountName = data.fromAccountName
    local transferAmount = tonumber(data.amount)
    local reason = (data.reason ~= '' and data.reason) or 'External transfer'
    if fromAccountName == 'personal account' then
        if Player.PlayerData.money.bank < transferAmount then return cb({ success = false, message = Lang:t('error.money') }) end
        Player.Functions.RemoveMoney('bank', transferAmount, reason)
        toPlayer.Functions.AddMoney('bank', transferAmount, reason)
        if not CreateBankStatement(src, 'personal account', transferAmount, reason, 'withdraw', 'player') then return cb({ success = false, message = Lang:t('error.error') }) end
        if not CreateBankStatement(toPlayer.PlayerData.source, 'personal account', transferAmount, reason, 'deposit', 'player') then return cb({ success = false, message = Lang:t('error.error') }) end
        cb({ success = true, message = Lang:t('success.transfer') })
    else
        if Accounts[fromAccountName].account_type == 'job' and job.name ~= fromAccountName and not job.isboss then return cb({ success = false, message = Lang:t('error.access') }) end
        if Accounts[fromAccountName].account_type == 'gang' and gang.name ~= fromAccountName and not gang.isboss then return cb({ success = false, message = Lang:t('error.access') }) end
        local fromAccountBalance = GetAccountBalance(fromAccountName)
        if fromAccountBalance < transferAmount then return cb({ success = false, message = Lang:t('error.money') }) end
        if not RemoveMoney(fromAccountName, transferAmount) then return cb({ success = false, message = Lang:t('error.error') }) end
        toPlayer.Functions.AddMoney('bank', transferAmount, reason)
        if not CreateBankStatement(toPlayer.PlayerData.source, 'personal account', transferAmount, reason, 'deposit', 'player') then return cb({ success = false, message = Lang:t('error.error') }) end
        cb({ success = true, message = Lang:t('success.transfer') })
    end
end)

QBCore.Functions.CreateCallback('qb-banking:server:orderCard', function(source, cb, data)
    local src = source
    local Player, citizenid = getPlayerAndCitizenId(src)
    if not Player or not citizenid then return cb({ success = false, message = Lang:t('error.error') }) end
    local pinNumber = tonumber(data.pin)
    local accountName = data.accountName

    

    if not pinNumber or #tostring(pinNumber) ~= 4 then return cb({ success = false, message = Lang:t('error.pin') }) end
    if accountName ~= 'personal account' then return cb({ success = false, message = Lang:t('error.card_personal_account') }) end

    local cardPrice = Config.CardOrderPrice
    if Player.PlayerData.money.bank < cardPrice then return cb({ success = false, message = Lang:t('error.not_enough_money_card') }) end

    -- Check if player already has a debit card for this account
    local existingCard = MySQL.query.await('SELECT * FROM debit_cards WHERE citizenid = ? AND account_name = ?', { citizenid, accountName })
    if existingCard and #existingCard > 0 then
        return cb({ success = false, message = Lang:t('error.already_have_card') })
    end

    Player.Functions.RemoveMoney('bank', cardPrice, 'debit card order')
    if not CreateBankStatement(src, accountName, cardPrice, 'Debit Card Order', 'withdraw', 'player') then return cb({ success = false, message = Lang:t('error.error') }) end

    local cardNumber = tostring(math.random(1000000000000000, 9999999999999999))
    local cardHolderName = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname

    local insertSuccess = MySQL.insert.await('INSERT INTO debit_cards (citizenid, card_number, card_pin, card_holder_name, account_name) VALUES (?, ?, ?, ?, ?)', { citizenid, cardNumber, pinNumber, cardHolderName, accountName })

    if not insertSuccess then
        Player.Functions.AddMoney('bank', cardPrice, 'debit card order refund') -- Refund if insert fails
        CreateBankStatement(src, accountName, cardPrice, 'Debit Card Order Refund', 'deposit', 'player')
        return cb({ success = false, message = Lang:t('error.error') })
    end

    local info = {
        citizenid = citizenid,
        name = cardHolderName,
        cardNumber = cardNumber,
        cardPin = pinNumber,
        accountName = accountName,
    }
    exports['qs-inventory']:AddItem(src, 'bank_card', 1, false, info)
   
    cb({ success = true, message = Lang:t('success.card') })
end)

QBCore.Functions.CreateCallback('qb-banking:server:openAccount', function(source, cb, data)
    local src = source
    local Player, citizenid = getPlayerAndCitizenId(src)
    if not Player or not citizenid then return cb({ success = false, message = Lang:t('error.error') }) end
    local accountName = data.accountName
    local initialAmount = tonumber(data.amount)
    if GetNumberOfAccounts(citizenid) >= Config.maxAccounts then return cb({ success = false, message = Lang:t('error.accounts') }) end
    if Player.PlayerData.money.bank < initialAmount then return cb({ success = false, message = Lang:t('error.money') }) end
    Player.Functions.RemoveMoney('bank', initialAmount, 'Opened account ' .. accountName)
    if not CreatePlayerAccount(src, accountName, initialAmount, json.encode({})) then return cb({ success = false, message = Lang:t('error.error') }) end
    if not CreateBankStatement(src, accountName, initialAmount, 'Initial deposit', 'deposit', 'shared') then return cb({ success = false, message = Lang:t('error.error') }) end
    if not CreateBankStatement(src, 'personal account', initialAmount, 'Initial deposit for ' .. accountName, 'withdraw', 'player') then return cb({ success = false, message = Lang:t('error.error') }) end
    TriggerEvent('qb-log:server:CreateLog', 'banking', 'Account Opened', 'green', string.format('**%s** opened account **%s** with an initial deposit of **$%s**', GetPlayerName(src), accountName, initialAmount))
    cb({ success = true, message = Lang:t('success.account') })
end)

QBCore.Functions.CreateCallback('qb-banking:server:renameAccount', function(source, cb, data)
    local src = source
    local Player, citizenid = getPlayerAndCitizenId(src)
    if not Player or not citizenid then return cb({ success = false, message = Lang:t('error.error') }) end
    local oldName = data.oldName
    local newName = data.newName
    if not Accounts[oldName] then return cb({ success = false, message = Lang:t('error.error') }) end
    if Accounts[oldName].citizenid ~= citizenid then return cb({ success = false, message = Lang:t('error.access') }) end
    Accounts[newName] = Accounts[oldName]
    Accounts[newName].account_name = newName
    Accounts[oldName] = nil
    local result = MySQL.update.await('UPDATE bank_accounts SET account_name = ? WHERE account_name = ? AND citizenid = ?', { newName, oldName, citizenid })
    if not result then return cb({ success = false, message = Lang:t('error.error') }) end
    TriggerEvent('qb-log:server:CreateLog', 'banking', 'Account Renamed', 'red', string.format('**%s** renamed **%s** to **%s**', GetPlayerName(src), oldName, newName))
    cb({ success = true, message = Lang:t('success.rename') })
end)

QBCore.Functions.CreateCallback('qb-banking:server:deleteAccount', function(source, cb, data)
    local src = source
    local Player, citizenid = getPlayerAndCitizenId(src)
    if not Player or not citizenid then return cb({ success = false, message = Lang:t('error.error') }) end
    local accountName = data.accountName
    if not Accounts[accountName] then return cb({ success = false, message = Lang:t('error.account') }) end

    -- Only allow the account owner to delete shared accounts
    if Accounts[accountName].account_type == 'shared' and Accounts[accountName].citizenid ~= citizenid then
        return cb({ success = false, message = Lang:t('error.access') })
    end

    -- Do not allow deletion of personal or job/gang accounts through this function
    if Accounts[accountName].account_type == 'player' or Accounts[accountName].account_type == 'job' or Accounts[accountName].account_type == 'gang' then
        return cb({ success = false, message = "You can only delete shared accounts through this option." })
    end

    Accounts[accountName] = nil
    local result = MySQL.rawExecute.await('DELETE FROM bank_accounts WHERE account_name = ? AND citizenid = ?', { accountName, citizenid })
    if not result then return cb({ success = false, message = Lang:t('error.error') }) end

    -- Also delete associated statements
    MySQL.rawExecute.await('DELETE FROM bank_statements WHERE account_name = ? AND citizenid = ?', { accountName, citizenid })
    Statements[accountName] = nil -- Clear statements in memory as well

    TriggerEvent('qb-log:server:CreateLog', 'banking', 'Account Deleted', 'red', string.format('**%s** deleted account **%s**', GetPlayerName(src), accountName))
    
    -- Re-fetch accounts and statements to send back to client for UI refresh
    local updatedAccounts = {}
    local updatedStatements = {}
    local debitCardResult = MySQL.query.await('SELECT card_number, card_pin, card_holder_name FROM debit_cards WHERE citizenid = ? AND account_name = ?', { citizenid, 'personal account' })
    local cardToSend = nil
    if debitCardResult and #debitCardResult > 0 then
        cardToSend = debitCardResult[1]
    end
    Player.PlayerData.debitCard = cardToSend -- Attach debit card data to PlayerData

    local job = Player.PlayerData.job
    local gang = Player.PlayerData.gang

    updatedAccounts[#updatedAccounts + 1] = { account_name = 'personal account', account_type = 'checking', account_balance = Player.PlayerData.money.bank }
    updatedStatements['personal account'] = Statements[citizenid] and Statements[citizenid]['personal account'] or {}
    for accName, accountInfo in pairs(Accounts) do
        if accountInfo.citizenid == citizenid then
            updatedAccounts[#updatedAccounts + 1] = accountInfo
            if Statements[accName] then updatedStatements[accName] = Statements[accName] end
        end
        if accountInfo.users and type(accountInfo.users) == 'string' then
            local sharedUsers = json.decode(accountInfo.users)
            local hasAccess = false
            for _, user in ipairs(sharedUsers) do
                if user == citizenid then
                    hasAccess = true
                    break
                end
            end
            if hasAccess then
                updatedAccounts[#updatedAccounts + 1] = accountInfo
                if Statements[accName] then updatedStatements[accName] = Statements[accName] end
            end
        end
        if (accName == job.name and job.isboss) or (accName == gang.name and gang.isboss) then
            updatedAccounts[#updatedAccounts + 1] = accountInfo
            if Statements[accName] then updatedStatements[accName] = Statements[accName] end
        end
    end

    cb({ success = true, message = Lang:t('success.delete'), deletedAccountName = accountName, accounts = updatedAccounts, statements = updatedStatements, playerData = Player.PlayerData })
end)

QBCore.Functions.CreateCallback('qb-banking:server:getNearbyPlayers', function(source, cb, data)
    local src = source
    local players = QBCore.Functions.GetPlayers()
    local nearbyPlayers = {}
    local playerPed = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(playerPed)

    local existingUsers = data.existingUsers or {}
    
    for i = 1, #players do
        local targetSrc = players[i]
        if targetSrc ~= src then -- Exclude self
            local targetPlayer = QBCore.Functions.GetPlayer(targetSrc)
            if targetPlayer then
                if targetPlayer.PlayerData and targetPlayer.PlayerData.charinfo then
                    local targetCitizenId = targetPlayer.PlayerData.citizenid
                    local targetName = targetPlayer.PlayerData.charinfo.firstname .. " " .. targetPlayer.PlayerData.charinfo.lastname

                    local alreadyExists = false
                    for _, existingUser in ipairs(existingUsers) do
                        if existingUser == targetCitizenId or existingUser == targetName then -- Check against both citizenid and full name
                            alreadyExists = true
                            break
                        end
                    end

                    if not alreadyExists then
                        local targetPed = GetPlayerPed(targetSrc)
                        if DoesEntityExist(targetPed) then
                            local targetCoords = GetEntityCoords(targetPed)
                            local distance = #(playerCoords - targetCoords)

                            if distance < 10.0 then -- Adjust distance as needed
                                table.insert(nearbyPlayers, {
                                    citizenid = targetCitizenId,
                                    name = targetName
                                })
                            end
                        end
                    end
                end
            end
        end
    end
    cb({ success = true, players = nearbyPlayers })
end)

QBCore.Functions.CreateCallback('qb-banking:server:addUser', function(source, cb, data)
    local src = source
    local Player, citizenid = getPlayerAndCitizenId(src)
    if not Player or not citizenid then return cb({ success = false, message = Lang:t('error.error') }) end
    local userToAdd = data.userName
    local accountName = data.accountName
    if not Accounts[accountName] then return cb({ success = false, message = Lang:t('error.account') }) end
    if Accounts[accountName].citizenid ~= citizenid then return cb({ success = false, message = Lang:t('error.access') }) end
    local account = Accounts[accountName]
    local users = json.decode(account.users)
    for _, cid in ipairs(users) do
        if cid == userToAdd then return cb({ success = false, message = Lang:t('error.user') }) end
    end
    users[#users + 1] = userToAdd
    local usersData = json.encode(users)
    Accounts[accountName].users = usersData
    local result = MySQL.update.await('UPDATE bank_accounts SET users = ? WHERE account_name = ? AND citizenid = ?', { usersData, accountName, citizenid })
    if not result then cb({ success = false, message = Lang:t('error.error') }) end
    TriggerEvent('qb-log:server:CreateLog', 'banking', 'User Added', 'green', string.format('**%s** added **%s** to **%s**', GetPlayerName(src), userToAdd, accountName))
    cb({ success = true, message = Lang:t('success.userAdd') })
end)

QBCore.Functions.CreateCallback('qb-banking:server:removeUser', function(source, cb, data)
    local src = source
    local Player, citizenid = getPlayerAndCitizenId(src)
    if not Player or not citizenid then return cb({ success = false, message = Lang:t('error.error') }) end
    local userToRemove = data.userName
    local accountName = data.accountName
    if not Accounts[accountName] then return cb({ success = false, message = Lang:t('error.account') }) end
    if Accounts[accountName].citizenid ~= citizenid then return cb({ success = false, message = Lang:t('error.access') }) end
    local account = Accounts[accountName]
    local users = json.decode(account.users)
    local userFound = false
    for i = #users, 1, -1 do
        if users[i] == userToRemove then
            table.remove(users, i)
            userFound = true
            break
        end
    end
    if not userFound then return cb({ success = false, message = Lang:t('error.noUser') }) end
    local usersData = json.encode(users)
    Accounts[accountName].users = usersData
    local result = MySQL.update.await('UPDATE bank_accounts SET users = ? WHERE account_name = ? AND citizenid = ?', { usersData, accountName, citizenid })
    if not result then cb({ success = false, message = Lang:t('error.error') }) end
    TriggerEvent('qb-log:server:CreateLog', 'banking', 'User Removed', 'red', string.format('**%s** removed **%s** from **%s**', GetPlayerName(src), userToRemove, accountName))
    cb({ success = true, message = Lang:t('success.userRemove') })
end)

QBCore.Functions.CreateCallback('qb-banking:server:changeDebitCardPin', function(source, cb, data)
    local src = source
    local Player, citizenid = getPlayerAndCitizenId(src)
    if not Player or not citizenid then return cb({ success = false, message = Lang:t('error.error') }) end
    local cardNumber = data.cardNumber
    local newPin = tonumber(data.newPin)

   

    if not cardNumber or not newPin or #tostring(newPin) ~= 4 then
        return cb({ success = false, message = Lang:t('error.invalid_pin_format') })
    end

    -- Retrieve existing card details from DB to get necessary info for item meta
    local existingCard = MySQL.query.await('SELECT card_holder_name, account_name FROM debit_cards WHERE citizenid = ? AND card_number = ?', { citizenid, cardNumber })
    if not existingCard or #existingCard == 0 then

        return cb({ success = false, message = Lang:t('error.no_existing_card_data') })
    end
    local cardHolderName = existingCard[1].card_holder_name
    local accountName = existingCard[1].account_name

    local success = MySQL.update.await('UPDATE debit_cards SET card_pin = ? WHERE citizenid = ? AND card_number = ?', { newPin, citizenid, cardNumber })
   
    if success then
        -- Check if the player has the card in their inventory and update its metadata
        local inventory = exports['qs-inventory']:GetInventory(src)
        local foundCardInInventory = false
        for _, item in pairs(inventory) do
            if item.name == 'bank_card' and item.info and item.info.cardNumber == cardNumber then
              
                -- Remove the old card item
                Player.Functions.RemoveItem(item.name, 1, item.slot)

                -- Add a new card item with updated PIN metadata
                local info = {
                    citizenid = citizenid,
                    name = cardHolderName,
                    cardNumber = cardNumber,
                    cardPin = newPin,
                    accountName = accountName,
                }
                exports['qs-inventory']:AddItem(src, 'bank_card', 1, false, info)
              

                foundCardInInventory = true
                break
            end
        end

        cb({ success = true, message = Lang:t('success.pin_changed') })
    else
        cb({ success = false, message = Lang:t('error.pin_change_failed') })
    end
end)

QBCore.Functions.CreateCallback('qb-banking:server:buyLostDebitCard', function(source, cb, data)
    local src = source
    local Player, citizenid = getPlayerAndCitizenId(src)
    if not Player or not citizenid then return cb({ success = false, message = Lang:t('error.error') }) end

    local accountName = data.accountName
    local cardPrice = Config.CardOrderPrice

    if Player.PlayerData.money.bank < cardPrice then
        return cb({ success = false, message = Lang:t('error.not_enough_money_card') })
    end

    -- Retrieve existing card details from DB to get the original card number
    local existingCard = MySQL.query.await('SELECT card_number, card_holder_name FROM debit_cards WHERE citizenid = ? AND account_name = ?', { citizenid, accountName })
    if not existingCard or #existingCard == 0 then
        return cb({ success = false, message = Lang:t('error.no_existing_card_data') }) -- Should not happen if flow is correct
    end
    local originalCardNumber = existingCard[1].card_number
    local cardHolderName = existingCard[1].card_holder_name

    -- Generate new PIN
    local newPin = math.random(1000, 9999) -- Generate a new 4-digit PIN

    -- Deduct money from bank
    Player.Functions.RemoveMoney('bank', cardPrice, 'lost debit card purchase')
    CreateBankStatement(src, accountName, cardPrice, 'Lost Debit Card Purchase', 'withdraw', 'player')

    -- Update PIN in database
    local updateSuccess = MySQL.update.await('UPDATE debit_cards SET card_pin = ? WHERE citizenid = ? AND card_number = ?', { newPin, citizenid, originalCardNumber })
    if not updateSuccess then
        Player.Functions.AddMoney('bank', cardPrice, 'lost debit card refund') -- Refund if DB update fails
        return cb({ success = false, message = Lang:t('error.error') })
    end

    -- Give new card item to player (with updated info)
    local info = {
        citizenid = citizenid,
        name = cardHolderName,
        cardNumber = originalCardNumber,
        cardPin = newPin,
        accountName = accountName,
    }
    exports['qs-inventory']:AddItem(src, 'bank_card', 1, false, info)

    cb({ success = true, message = Lang:t('success.new_card_bought'), newPin = newPin, cardNumber = originalCardNumber })
end)

-- Items

QBCore.Functions.CreateUseableItem('bank_card', function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    if Player.Functions.GetItemByName(item.name) then
        TriggerClientEvent('qb-banking:client:useCard', source)
    end
end)

-- Threads

CreateThread(function()
    local accounts = MySQL.query.await('SELECT * FROM bank_accounts')

    for _, account in ipairs(accounts) do
        Accounts[account.account_name] = account
    end

    for job in pairs(QBCore.Shared.Jobs) do
        if Accounts[job] == nil then
            CreateJobAccount(job, 0)
        end
    end
end)

CreateThread(function()
    local statements = MySQL.query.await('SELECT * FROM bank_statements')
    for _, statement in ipairs(statements) do
        if statement.account_name == 'personal account' then
            if not Statements[statement.citizenid] then Statements[statement.citizenid] = {} end
            if not Statements[statement.citizenid][statement.account_name] then Statements[statement.citizenid][statement.account_name] = {} end
            Statements[statement.citizenid][statement.account_name][#Statements[statement.citizenid][statement.account_name] + 1] = statement
        else
            if not Statements[statement.account_name] then Statements[statement.account_name] = {} end
            Statements[statement.account_name][#Statements[statement.account_name] + 1] = statement
        end
    end
end)

-- Commands

QBCore.Functions.CreateCallback('qb-banking:server:getPlayerNameByCitizenId', function(source, cb, citizenid) 
    local Player = QBCore.Functions.GetPlayerByCitizenId(citizenid)
    if Player then

        if Player.PlayerData and Player.PlayerData.charinfo then
            local retrievedCitizenId = Player.PlayerData.citizenid
            local fullName = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname

            if retrievedCitizenId == citizenid then

                cb({ success = true, name = fullName })
            else

                cb({ success = false, message = 'Mismatch: Retrieved player does not match requested citizenid.' })
            end
        else
            cb({ success = false, message = 'Player data or character info missing' })
        end
    else
        cb({ success = false, message = 'Player not found' })
    end
end)

QBCore.Commands.Add('givecash', 'Give Cash', { { name = 'id', help = 'Player ID' }, { name = 'amount', help = 'Amount' } }, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local playerPed = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(playerPed)
    local target = QBCore.Functions.GetPlayer(tonumber(args[1]))
    if not target then return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.noUser'), 'error') end
    local targetPed = GetPlayerPed(tonumber(args[1]))
    local targetCoords = GetEntityCoords(targetPed)
    local amount = tonumber(args[2])
    if not amount then return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.amount'), 'error') end
    if amount <= 0 then return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.amount'), 'error') end
    if #(playerCoords - targetCoords) > 5 then return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.toofar'), 'error') end
    if Player.PlayerData.money.cash < amount then return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.money'), 'error') end
    Player.Functions.RemoveMoney('cash', amount, 'cash transfer')
    target.Functions.AddMoney('cash', amount, 'cash transfer')
    TriggerClientEvent('QBCore:Notify', src, string.format(Lang:t('success.give'), amount), 'success')
    TriggerClientEvent('QBCore:Notify', target.PlayerData.source, string.format(Lang:t('success.receive'), amount), 'success')
end)
