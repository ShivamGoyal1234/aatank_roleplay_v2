exports('GetPlayerEmail', function(source)
    local xPlayer = Resmon.Lib.GetPlayerFromSource(source)
    local Tablets = Shared.Tablets
    local checked = 'notFound'
    for k,v in pairs(Tablets) do
        if v.owner == xPlayer.identifier then
            return v.email
        end
    end
    return checked
end)

exports('CreateNewMail', function(Receiver, Data, From_Name, From, Type)
    local Date = os.date("%d/%m/%Y %H:%M:%S")
    local newMail = #AllMails + 1
    local tabOwner = GetTabletOwnerFromMail(Receiver)
    local src = Resmon.Lib.GetPlayerByIdentifier(tabOwner)
    local Player = {}
    if src then
        Player = Resmon.Lib.GetPlayerFromSource(src)
    end

    AllMails[newMail] = {
        receiver = Receiver,
        data = Data,
        from_name = From_Name,
        from = From,
        type = Type,
        date = Date,
    }

    MySQL.Async.execute([[
        INSERT INTO kibra_smartpad_mails (`receiver`, `data`, `from`, `from_name`, `type`, `date`)
        VALUES (?, ?, ?, ?, ?, ?)
    ]],  {
        AllMails[newMail].receiver,
        json.encode(AllMails[newMail].data),
        AllMails[newMail].from,
        AllMails[newMail].from_name,
        AllMails[newMail].type,
        AllMails[newMail].date
    })

    TriggerClientEvent('Kibra:SmartPad:Client:AddNewMail', -1, AllMails[newMail])
    if src > 0 and Player then
        TriggerClientEvent('Kibra:SmartPad:Client:NewMail', Player.source)
    end
end)

exports('GiveTablet', function(source)
    local src = source
    local xPlayer = Resmon.Lib.GetPlayerFromSource(src)
    if xPlayer then
        local newSerialNumber = getUniqueSerialNumber()
        AddInventoryItem(source, Shared.TabletItemName, 1, nil, {SerialNumber = newSerialNumber})
        TriggerClientEvent('SmartPad:Ox:Notification', source, Shared.LangData.successfull, string.format(Shared.LangData.gaveNewTablet, src, newSerialNumber), 'success')
    else
        TriggerClientEvent('SmartPad:Ox:Notification', source, Shared.LangData.error, Shared.LangData.invalidSource, 'error')
    end
end)

exports('CreateNewBill', function(Owner, DueDate, Content, Status, Notes, Job)
    local receiver = Resmon.Lib.GetPlayerByIdentifier(Owner)
    if receiver and receiver > 0 then
        ReceiverData = Resmon.Lib.GetPlayerFromSource(receiver)
    end
    local Date = os.date("%Y-%m-%d")
    local TotalAmount = 0
    for _, p in ipairs(Content) do
        TotalAmount = TotalAmount + p.Price
    end
    local newInvoice = #AllInvoices+1

    AllInvoices[newInvoice] = {
        ikey = Resmon.Lib.GenerateHash(),
        owner = Owner,
        date = Date,
        duedate = DueDate,
        content = Content,
        totalamount = tonumber(TotalAmount),
        status = Status,
        notes = Notes,
        job = Job,
        name = Resmon.Lib.GetPlayerOfflineName(Owner)
    }

    MySQL.insert([[
        INSERT INTO `kibra_smartpad_invoices`
            (`ikey`,`owner`,`date`,`duedate`,`content`,`totalamount`,`status`,`notes`,`job`)
        VALUES(?,?,?,?,?,?,?,?,?)
        ]], {
        AllInvoices[newInvoice].ikey,
        AllInvoices[newInvoice].owner,
        AllInvoices[newInvoice].date,
        AllInvoices[newInvoice].duedate,
        json.encode(AllInvoices[newInvoice].content),
        AllInvoices[newInvoice].totalamount,
        AllInvoices[newInvoice].status,
        AllInvoices[newInvoice].notes,
        AllInvoices[newInvoice].job
    })

    local MailContent = {}
    MailContent.getProducts = {}
    local TotalPrice = 0
    for k,v in pairs(AllInvoices[newInvoice].content) do
        TotalPrice = TotalPrice + v.Price
        MailContent.getProducts[#MailContent.getProducts+1] = {
            label = v.Description.. ' x'..v.Quantity,
            fine = v.Price,
        }   
    end
    MailContent.DueDate = AllInvoices[newInvoice].duedate
    MailContent.totalPrice = AllInvoices[newInvoice].totalamount
    local allMails = GetPlayerEmails(AllInvoices[newInvoice].owner)
    local From = AllInvoices[newInvoice].job..'@'..Shared.Domain
    if Shared.BillingCompanies[AllInvoices[newInvoice].job] then
        From = Shared.BillingCompanies[AllInvoices[newInvoice].job]
    end

    if Job ~= 'police' then
        for k,v in pairs(allMails) do
            exports['kibra-smartpad']:CreateNewMail(v, MailContent, From.AccountName, From.Mail, 2)
        end
    end

    TriggerClientEvent('Kibra:SmartPad:Client:AddInvoice', -1, AllInvoices[newInvoice])

    if receiver and receiver > 0 then
        TriggerClientEvent('Kibra:SmartPad:ReceiverNewBill', receiver)
    end
end)

exports('GetPlayerUnpaidInvoices', function(source)
    local xPlayer = Resmon.Lib.GetPlayerFromSource(source)
    local billings = {}
    for k,v in pairs(AllInvoices) do
        if v.owner == xPlayer.identifier then
            if v.status == 0 then
                billings[#billings+1] = v
            end
        end
    end
    return billings
end)