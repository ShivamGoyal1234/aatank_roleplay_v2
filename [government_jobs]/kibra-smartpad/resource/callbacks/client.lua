RegisterNUICallback('deleteGalleryMedia', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:DeletePhoto', function(export)
        if export then
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'gallery', {
                title = OpenedTabletLang.success,
                only = false,
                message = OpenedTabletLang.deletedPhotos,
                icon = 'gallery'
            })
            
        end
    end, OpenedTabletSerialNumber, data)
    cb('ok')
end)

RegisterNUICallback('likeMedia', function(data, cb)
    TriggerServerEvent('Kibra:SmartPad:AddFavourite', data, OpenedTabletSerialNumber, data.state)
    cb('ok')
end)

RegisterNUICallback('deleteDataFromMdt', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:DeleteMdtData', function(export)
        if export then
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'mdt', {
                title = OpenedTabletLang.success,
                only = false,
                message = OpenedTabletLang.deletedcrime,
                icon = 'mdt'
            })
        end
    end, data)
end)

RegisterNUICallback('createNewHaber', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:AddNewHaber', function(export)
        if export then
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'news', {
                title = OpenedTabletLang.success,
                only = false,
                message = OpenedTabletLang.newnew,
                icon = 'weazel'
            })
        end
    end, data, OpenedTabletSerialNumber)
end)

RegisterNUICallback('shareMyLocationTo', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:ShareLocation', function(export)
        if export then
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'map', {
                title = OpenedTabletLang.success,
                only = false,
                message = OpenedTabletLang.sharedloca,
                icon = 'map'
            })
        else
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'map', {
                title = OpenedTabletLang.error,
                only = false,
                message = OpenedTabletLang.alreadyshared,
                icon = 'map'
            })
        end
    end, data, OpenedTabletSerialNumber)
end)

RegisterNUICallback('setOnMap', function(data, cb)
    SetNewWaypoint(data.coords.x, data.coords.y)
    TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'map', {
        title = OpenedTabletLang.success,
        only = false,
        message = string.format(OpenedTabletLang.rotabann, data.coords.time),
        icon = 'map'
    })
    cb('ok')
end)

RegisterNetEvent('Kibra:SmartPad:Client:ShareLocation', function(shared)
    TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'map', {
        title = OpenedTabletLang.success,
        only = false,
        message = string.format(OpenedTabletLang.ohoshared, shared),
        icon = 'map'
    })
    
    if isTabletOpened then
        GetMyShareers(OpenedTabletSerialNumber)
        SendNUIMessage({
            action = 'updateShared',
        })
    end
end)

RegisterNUICallback('CreateNewWanted', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:CreateWanted', function(export)
        if export ~= 'already' then
            SendNUIMessage({
                action = 'newWanteds',
                data = {data = export, type = data.type}
            })
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'mdt', {
                title = OpenedTabletLang.success,
                only = false,
                message = OpenedTabletLang.createdwanted,
                icon = 'mdt'
            })
        elseif export == 'already' then
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'mdt', {
                title = OpenedTabletLang.error,
                only = false,
                message = OpenedTabletLang.alreadyhaswanted,
                icon = 'mdt'
            })
        end
    end, data)
end)

RegisterNUICallback('approveCase', function(datax, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:ApproveCase', function(export)
        if export then
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'dojapp', {
                title = OpenedTabletLang.caseApproved,
                only = false,
                message = string.format(OpenedTabletLang.approveddesc, datax.id),
                icon = 'dojapp'
            })
            SendNUIMessage({action = 'updateCrimeData', data = {id = datax.id, dataLand = export}})
        end
    end, datax.id, OpenedTabletSerialNumber)
    cb('ok')
end)

RegisterNUICallback('getDojUsers', function(data, cb)
    local dojData = lib.callback.await('Kibra:SmartPad:GetDojUsers', false, data.type)
    cb(dojData.data)
end)

RegisterNUICallback('createNewCourt', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:AddNewCourt', function(export, newCourt)
        if export then
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'dojapp', {
                title = OpenedTabletLang.success,
                only = false,
                message = OpenedTabletLang.createdcourt,
                icon = 'dojapp'
            })
            SendNUIMessage({action = 'updateCrimeData', data = {id = data.caseid, dataLand = export}})
            SendNUIMessage({action = 'addNewCourt', data = {id = data.caseid, dataa = newCourt}})
        else
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'dojapp', {
                title = OpenedTabletLang.error,
                only = false,
                message = OpenedTabletLang.alreadycourt,
                icon = 'dojapp'
            })
        end
    end, data)
    cb('ok')
end)

RegisterNUICallback('CloseCameraApp', function(data, cb)
    CameraMode = false
    local tabletData = FindTabletData(OpenedTabletSerialNumber)
    SetNuiFocusKeepInput(check)
    SetFollowPedCamViewMode(1)
    if tabletData and tabletData[1] then
        UseTabletWalking(tabletData[1].data.walkanduse) 
    end
    cb('ok')
end)

RegisterNUICallback('createResmonId', function(data, cb)
    cb('ok')
end)

RegisterNUICallback('verdictCase', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:VerdictCase', function(export)
        if export then 
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'dojapp', {
                title = OpenedTabletLang.success,
                only = false,
                message = string.format(OpenedTabletLang.verdicted, data.crimeId),
                icon = 'dojapp'
            })
            SendNUIMessage({action = 'updateCrimeData', data = {id = data.crimeId, dataLand = export}})
        end
    end, data)
end)

RegisterNUICallback('RejectCrime', function(datax, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:RejectCase', function(export)
        if export then
              TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'dojapp', {
                title = OpenedTabletLang.caseRejected,
                only = false,
                message = string.format(OpenedTabletLang.rejecteddesc, datax.id),
                icon = 'dojapp'
            })
            SendNUIMessage({action = 'updateCrimeData', data = {id = datax.id, dataLand = export}})
        end
    end, OpenedTabletSerialNumber, datax)
end)

RegisterNUICallback('UpdateJob', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:UpdatePlayerJob', function(export)
        if export then
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'mdt', {
                title = OpenedTabletLang.success,
                only = false,
                message = OpenedTabletLang.updatedrole,
                icon = 'mdt'
            })
        end
    end, data)
    cb('ok')
end)

RegisterNUICallback('checkAccount', function(data, cb)
    local resp = lib.callback.await('Kibra:SmartPad:CheckLogin', false, data)
    cb(resp)
end)

RegisterNUICallback('removeJournalist', function(data, cb)
    local resp = lib.callback.await('Kibra:SmartPad:RemoveJournalist', false, data.staffId)
    if resp then
        TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'weazel', {
            title = OpenedTabletLang.success,
            only = false,
            message = string.format(OpenedTabletLang.dismissed, data.staffName),
            icon = 'weazel'
        })
        cb(resp)
    end
end)

RegisterNUICallback('saveNewTablet', function(data, cb)
    TriggerServerEvent('Kibra:SmartPad:RegisterNewTablet', OpenedTabletSerialNumber, data)
    cb('ok')
end)

RegisterNUICallback('addNewStaff', function(data, cb)
    local resp = lib.callback.await('Kibra:SmartPad:AddNewJournalist', false, data)
    if resp then
        TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'weazel', {
            title = OpenedTabletLang.success,
            only = false,
            message = string.format(OpenedTabletLang.hired, data.staffItem.name),
            icon = 'weazel'
        })
        cb(resp.data)
    end
end)

RegisterNUICallback('createJobApplications', function(data, cb)
    local resp = lib.callback.await('Kibra:SmartPad:CreateJobApplication', false, data, OpenedTabletSerialNumber)
    if resp then
        TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'weazel', {
            title = OpenedTabletLang.success,
            only = false,
            message = OpenedTabletLang.sentedreq,
            icon = 'weazel'
        })
    else
        TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'weazel', {
            title = OpenedTabletLang.error,
            only = false,
            message = OpenedTabletLang.alrex,
            icon = 'weazel'
        })
    end
end)

RegisterNUICallback('postComment', function(data, cb)
    local resp = lib.callback.await('Kibra:SmartPad:NewsAddComment', false, data, OpenedTabletSerialNumber)
    if resp then
        TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'weazel', {
            title = OpenedTabletLang.success,
            only = false,
            message = OpenedTabletLang.posted,
            icon = 'weazel'
        })
        cb(resp)
    else

    end
end)

RegisterNUICallback('getJournalists', function(data, cb)
    local resp = lib.callback.await('Kibra:SmartPad:GetJournalist', false)
    cb(resp)
end)

RegisterNUICallback('mapAppState', function(data, cb)
    MapOpened = data.state
    cb('Ok')
end)

RegisterNUICallback('closeTablet', function(data, cb)
    SetNuiFocus(false, false)
    SetFollowPedCamViewMode(1)
    RemoveTabletPHand()
    isTabletOpened = false
    DestroyMobilePhone()
    TriggerServerEvent('Kibra:SmartPad:UpdateTabletCharge', OpenedTabletSerialNumber, tonumber(data.batteryLevel))
    TriggerServerEvent('Kibra:SmartPad:TabletState', OpenedTabletSerialNumber, false)
    cb('ok')
    OpenedTabletSerialNumber = nil
end)

RegisterNUICallback('updateBatteryLevel', function(data, cb)
    TriggerServerEvent('Kibra:SmartPad:UpdateTabletCharge', OpenedTabletSerialNumber, 0)
    cb('ok')
end)

RegisterNUICallback('getMessages', function(data, cb)
    cb(EMSChat)
end)

RegisterNUICallback('sendMessage', function(data, cb)
    TriggerServerEvent('Kibra:SmartPad:SendChatMessage', data, OpenedTabletSerialNumber)
    cb('ok')
end)

RegisterNUICallback('usePowerBank', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:UsePowerBank', function(export)
        if export then
            cb(export)
        else
            cb(false)
        end
    end, OpenedTabletSerialNumber)
end)

RegisterNUICallback('updateChargeWait', function(data, cb)
    TriggerServerEvent('Kibra:SmartPad:UpdateTabletCharge', OpenedTabletSerialNumber, tonumber(data.value))
    SendNUIMessage({action = 'usedPowerbank', data = {charge = tonumber(data.value)}})
    cb('ok')
end)

RegisterNUICallback('SendMail', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:Server:SendMail', function(export)
        if export then
             TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'mail', {
                title = OpenedTabletLang.success,
                only = false,
                message = OpenedTabletLang.sentmail,
                icon = 'mail'
            })
            local mails, sented = GetTabletMails(OpenedTabletSerialNumber)
            SendNUIMessage({
                action = 'updateMails',
                data = {data = mails, data2 = sented}
            })
        end
    end, data, OpenedTabletSerialNumber)
    cb('ok')
end)

RegisterNUICallback('SendAnnounceForMdt', function(data, cb)
    TriggerServerEvent('Kibra:SmartPad:AddNewAnnounce', data, OpenedTabletSerialNumber)
    cb('ok')
end)

RegisterNUICallback('addNewAlbum', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:CreateNewAlbum', function(export)
        if export then
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'gallery', {
                title = OpenedTabletLang.success,
                only = false,
                message = OpenedTabletLang.createdal,
                icon = 'gallery'
            })
        end
    end, data, OpenedTabletSerialNumber)
    cb('ok')
end)

RegisterNUICallback('getNearestForAirDrop', function(data, cb)
    local nearestPlayers = lib.callback.await('Kibra:SmartPad:GetOpenedTablets', false)
    cb(nearestPlayers.data)
end)

RegisterNUICallback('getNearestForBilling', function(data, cb)
    local nearestPlayers = lib.callback.await('Kibra:SmartPad:GetNearPlayers', false)
    cb(nearestPlayers.data)
end)

RegisterNUICallback('addPhotosToAlbum', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:Client:AddAlbum', function(export)
        if export then
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'gallery', {
                title = OpenedTabletLang.success,
                only = false,
                message = OpenedTabletLang.addedtoalbum,
                icon = 'gallery'
            })
            cb(export)
        end
    end, data, OpenedTabletSerialNumber)
end)

RegisterNUICallback('PayInvoice', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:PayInvoice', function(export)
        if export then
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'billing', {
                title = OpenedTabletLang.success,
                only = false,
                message = OpenedTabletLang.paidinv,
                icon = 'billings'
            })
        else
             TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'billing', {
                title = OpenedTabletLang.error,
                only = false,
                message = OpenedTabletLang.youdonthavemoney,
                icon = 'billings'
            })
        end
    end, data, OpenedTabletSerialNumber)
    cb('ok')
end)

RegisterNUICallback('createNewInvoice', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:CreateNewBill', function(export)
        if export then
             TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'billing', {
                title = OpenedTabletLang.success,
                only = false,
                message = OpenedTabletLang.createdinvoice,
                icon = 'billing'
            })
        end
    end, data)
    cb('ok')
end)

RegisterNUICallback('SendAirDropPhoto', function(data, cb)
    data.sender = OpenedTabletSerialNumber
    Resmon.Lib.Callback.Client('Kibra:SmartPad:Server:SendAirDrop', function(export)
        if export then
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'gallery', {
                title = OpenedTabletLang.success,
                only = false,
                message = OpenedTabletLang.sentphoto,
                icon = 'gallery'
            })
            cb(true)
        else
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'gallery', {
                title = OpenedTabletLang.error,
                only = false,
                message = OpenedTabletLang.youcantsend,
                icon = 'gallery'
            })
            cb(false)
        end
    end, data)
end)

RegisterNUICallback('openedGallery', function(data, cb)
    SendNUIMessage({
        action = 'getNearest',
        data = {players = lib.callback.await('Kibra:SmartPad:GetNearPlayers', false)}
    })
    cb('ok')
end)

RegisterNUICallback('UpdateTabletMainData', function(dataland, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:UpdateMainData', function(export)
        SendNUIMessage({
            action = 'updateTabletMainData',
            data = {data = export}
        })
        -- if dataland.datatype == 'passcode' then
        --     SendNUIMessage({action = 'newpass', data = {pass = dataland.result}})
        -- end
    end, OpenedTabletSerialNumber, dataland)
    cb('ok')
end)

RegisterNUICallback('UpdateTabletData', function(data, cb)
    TriggerServerEvent('Kibra:SmartPad:UpdateTabletMiniData', data, OpenedTabletSerialNumber)
    if data.datatype == 'walkanduse' then
        UseTabletWalking(data.result)
    elseif data.dataype == 'lang' then
        OpenedTabletLang = GetTabletLang(data.result)
        TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'settings', {
            title = OpenedTabletLang.success,
            only = false,
            message = OpenedTabletLang.changedLang,
            icon = 'settings'
        })
        SendNUIMessage({action = 'updateLang', data = {lang = OpenedTabletLang}})
    elseif data.datatype == 'background' then
        TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'mdt', {
            title = OpenedTabletLang.success,
            only = false,
            message = OpenedTabletLang.changedback,
            icon = 'settings'
        })
        SendNUIMessage({
            action = 'updtbck',
            data = {data = data.result}
        })
    end
    cb('ok')
end)

RegisterNUICallback('addDrugList', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:AddTreatment', function(export)
        if export then 
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'ems', {
                title = OpenedTabletLang.success,
                only = false,
                message = OpenedTabletLang.addedtreatment,
                icon = 'ems'
            })
            updateEmsData('treatments', export)
        end
    end, data, getTabletOwner(OpenedTabletSerialNumber))
    cb('ok')
end)

RegisterNUICallback('addDoctorNote', function(data, cb)
      Resmon.Lib.Callback.Client('Kibra:SmartPad:AddDoctorNote', function(export)
        if export then 
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'ems', {
                title = OpenedTabletLang.success,
                only = false,
                message = OpenedTabletLang.addednote,
                icon = 'ems'
            })
            updateEmsData('docnotes', export)
        end
    end, data, getTabletOwner(OpenedTabletSerialNumber))
    cb('ok')
end)

RegisterNUICallback('updateNote', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:CreateNewNote', function(export)
        if export == 'new' then
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'ems', {
                title = OpenedTabletLang.success,
                only = false,
                message = OpenedTabletLang.addednotex,
                icon = 'notes'
            })
        else
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'ems', {
                title = OpenedTabletLang.success,
                only = false,
                message = OpenedTabletLang.addednotex,
                icon = 'notes'
            })
        end
    end, data, OpenedTabletSerialNumber)
    cb('ok')
end)

RegisterNUICallback('ToggleCameraAppModule', function(data, cb)
    CameraMode = true
    SetNuiFocusKeepInput(true)
    SetFollowPedCamViewMode(4)
    CameraBlockThread()
    cb('ok')
end)

RegisterNUICallback('SelectOnMap', function(data, cb)
    SetNewWaypoint(data.coords.x, data.coords.y)
    TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'mdt', {
        title = OpenedTabletLang.success,
        only = true,
        message = OpenedTabletLang.markedonmap,
        icon = 'mdt'
    })
    cb('ok')
end)

RegisterNUICallback('CreateVehicleCrime', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:CreateVehicleCrime', function(export)
        if export then
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'mdt', {
                title = OpenedTabletLang.success,
                only = false,
                message = OpenedTabletLang.createdCrimeOffence,
                icon = 'mdt'
            })
            SendNUIMessage({
                action = 'setNewVehicleCrime',
                data = {data = export}
            })
        else
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'mdt', {
                title = OpenedTabletLang.error,
                only = false,
                message = OpenedTabletLang.errors,
                icon = 'mdt'
            }) 
            cb('ok')
        end
    end, data)
end)

RegisterNUICallback('getAllBlipsAndPlayers', function(data, cb)
    local nearestPlayers = lib.callback.await('Kibra:SmartPad:GetNearPlayers', false)
    local data = {}
    data.players = nearestPlayers.data
    data.blips = blips
    cb(data)
end)

RegisterNUICallback('getMyCoords', function(data, cb)
    local coords = GetEntityCoords(PlayerPedId())
    cb({x = coords.x, y = coords.y, z = coords.z, location = GetAddress(coords)})
end)

RegisterNUICallback('CreateNewCriminalRecord', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:CreateNewCrime', function(export)
        if export then
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'mdt', {
                title = OpenedTabletLang.success,
                only = false,
                message = OpenedTabletLang.createdCrimeOffence,
                icon = 'mdt'
            })
            SendNUIMessage({
                action = 'setNewCriminal',
                data = {dataland = export}
            })
        else
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'mdt', {
                title = OpenedTabletLang.error,
                only = false,
                message = OpenedTabletLang.errors,
                icon = 'mdt'
            }) 
            cb('ok')
        end
    end, data, OpenedTabletSerialNumber)
end)

RegisterNUICallback('CreateNewLicense', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:RegisterWeaponLicense', function(export)
        if export ~= 'alreadyHas' then
            SendNUIMessage({
                action = 'newWanteds',
                data = {data = export, type = 'wlicenses'}
            })
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'mdt', {
                title = 'Başarılı',
                only = true,
                message = 'Silah lisansı eklendi',
                icon = 'mdt'
            }) 
        else
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'mdt', {
                title = 'Başarısız',
                only = true,
                message = 'Kişi bu silah lisansına zaten sahip',
                icon = 'mdt'
            })
        end
    end, data)
    cb('ok')
end)

RegisterNUICallback('SaveGalleryPhoto', function(data, cb)
    data.location = GetAddress(GetEntityCoords(PlayerPedId()))
    Resmon.Lib.Callback.Client('Kibra:SmartPad:AddMediaGallery', function(result)
        if result then
            if data.type == 'video' then
                SendNUIMessage({action = 'updateLastPhoto', data = {url = data.url}})
            end
            SendNUIMessage({action = 'updateGallery', data = {gallery = GetTabletGallery(OpenedTabletSerialNumber)}})
            cb(true)

            if data.custom == 'forMdt' then
                SendNUIMessage({
                    action = 'openApp',
                    url = data.url
                })
            end
        else
            print("There's been a problem.")
            cb(false)
        end
    end, OpenedTabletSerialNumber, data)
    cb('ok')
end)

RegisterNUICallback('deleteSelectedNote', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:DeleteSelectedNote', function(export)
        if export then
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'ems', {
                title = OpenedTabletLang.success,
                only = false,
                message = OpenedTabletLang.delNote,
                icon = 'notes'
            })
        end
    end, data, OpenedTabletSerialNumber)
    cb('ok')
end)

RegisterNUICallback('selectLanguage', function(data, cb)
    local selectedLang = data.language
    local langData = json.decode(LoadResourceFile(Shared.ScriptName, 'locales/'..selectedLang..'.json'))
    cb({
        langData = langData
    })
end)

RegisterNUICallback('toggleDuty', function(data, cb)
    local _ = data and data.state
    TriggerEvent('qb-policejob:ToggleDuty')
    Wait(200)
    local playerData = Resmon.Lib.GetPlayerData()
    local onDuty = false
    if playerData and playerData.job and type(playerData.job.onduty) ~= 'nil' then
        onDuty = playerData.job.onduty and true or false
    end
    cb({ state = onDuty })
end)

RegisterNUICallback('getDutyState', function(data, cb)
    local playerData = Resmon.Lib.GetPlayerData()
    local onDuty = false
    if playerData and playerData.job and type(playerData.job.onduty) ~= 'nil' then
        onDuty = playerData.job.onduty and true or false
    end
    cb({ state = onDuty })
end)

RegisterNUICallback('resetTablet', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:ResetTablet', function(export)
        if export then
             TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'settings', {
                title = OpenedTabletLang.success,
                only = false,
                message = OpenedTabletLang.reseted,
                icon = 'settings'
            })
            Wait(400)
            SendNUIMessage({action = 'closeTablet'})
            cb(true)
        else
            cb(false)
        end
    end, OpenedTabletSerialNumber)
end)

-- Insurance Callbacks
RegisterNUICallback('createInsurancePolicy', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:CreateInsurancePolicy', function(result)
        if result then
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'insurance', {
                title = 'Success',
                only = false,
                message = 'Insurance policy created successfully',
                icon = 'insurance'
            })
            cb(result)
        else
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'insurance', {
                title = 'Error',
                only = false,
                message = 'Failed to create insurance policy',
                icon = 'insurance'
            })
            cb(false)
        end
    end, data)
end)

RegisterNUICallback('createInsuranceClaim', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:CreateInsuranceClaim', function(result)
        if result then
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'insurance', {
                title = 'Success',
                only = false,
                message = 'Insurance claim submitted successfully',
                icon = 'insurance'
            })
            cb(result)
        else
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'insurance', {
                title = 'Error',
                only = false,
                message = 'Failed to submit insurance claim',
                icon = 'insurance'
            })
            cb(false)
        end
    end, data)
end)

RegisterNUICallback('getInsuranceData', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:GetInsuranceData', function(result)
        cb(result)
    end)
end)

-- New Insurance Plans Callback
RegisterNUICallback('getInsurancePlans', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:GetInsurancePlans', function(result)
        cb(result)
    end)
end)

-- New Insurance Providers Callback
RegisterNUICallback('getInsuranceProviders', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:GetInsuranceProviders', function(result)
        cb(result)
    end)
end)

-- Create Insurance Plan Callback
RegisterNUICallback('createInsurancePlan', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:CreateInsurancePlan', function(result)
        if result and result.success then
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'insurance', {
                title = 'Success',
                only = false,
                message = 'Insurance plan created successfully',
                icon = 'insurance'
            })
            cb(result)
        else
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'insurance', {
                title = 'Error',
                only = false,
                message = result.message or 'Failed to create insurance plan',
                icon = 'insurance'
            })
            cb(false)
        end
    end, data)
end)

-- New Policy Renewal Callback
RegisterNUICallback('renewInsurancePolicy', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:RenewInsurancePolicy', function(result)
        if result then
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'insurance', {
                title = 'Success',
                only = false,
                message = 'Policy renewed successfully',
                icon = 'insurance'
            })
            cb(result)
        else
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'insurance', {
                title = 'Error',
                only = false,
                message = 'Failed to renew policy',
                icon = 'insurance'
            })
            cb(false)
        end
    end, data)
end)

-- New Get Policy Renewals Callback
RegisterNUICallback('getPolicyRenewals', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:GetPolicyRenewals', function(result)
        cb(result)
    end)
end)

-- New Insurance Callbacks
RegisterNUICallback('approveInsuranceClaim', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:ApproveInsuranceClaim', function(result)
        if result and result.success then
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'insurance', {
                title = 'Success',
                only = false,
                message = 'Claim processed successfully',
                icon = 'insurance'
            })
            cb(result)
        else
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'insurance', {
                title = 'Error',
                only = false,
                message = result.message or 'Failed to process claim',
                icon = 'insurance'
            })
            cb(false)
        end
    end, data)
end)

RegisterNUICallback('createMedicalRecord', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:CreateMedicalRecord', function(result)
        if result and result.success then
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'insurance', {
                title = 'Success',
                only = false,
                message = 'Medical record created successfully',
                icon = 'insurance'
            })
            cb(result)
        else
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'insurance', {
                title = 'Error',
                only = false,
                message = result.message or 'Failed to create medical record',
                icon = 'insurance'
            })
            cb(false)
        end
    end, data)
end)

RegisterNUICallback('getInsuranceTransactions', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:GetInsuranceTransactions', function(result)
        cb(result)
    end)
end)

RegisterNUICallback('processPremiumPayment', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:ProcessPremiumPayment', function(result)
        if result and result.success then
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'insurance', {
                title = 'Success',
                only = false,
                message = 'Premium payment processed successfully',
                icon = 'insurance'
            })
            cb(result)
        else
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'insurance', {
                title = 'Error',
                only = false,
                message = result.message or 'Failed to process payment',
                icon = 'insurance'
            })
            cb(false)
        end
    end, data)
end)

RegisterNUICallback('processPolicyRefund', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:ProcessPolicyRefund', function(result)
        if result and result.success then
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'insurance', {
                title = 'Success',
                only = false,
                message = 'Policy refund processed successfully',
                icon = 'insurance'
            })
            cb(result)
        else
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'insurance', {
                title = 'Error',
                only = false,
                message = result.message or 'Failed to process refund',
                icon = 'insurance'
            })
            cb(false)
        end
    end, data)
end)

RegisterNUICallback('getMedicalRecords', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:GetMedicalRecords', function(result)
        if result and result.success then
            cb(result)
        else
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'insurance', {
                title = 'Error',
                only = false,
                message = result.message or 'Failed to get medical records',
                icon = 'insurance'
            })
            cb(false)
        end
    end, data.targetPlayerId)
end)

RegisterNUICallback('searchPlayer', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:SearchPlayer', function(result)
        if result and result.success then
            cb(result)
        else
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'insurance', {
                title = 'Error',
                only = false,
                message = result.message or 'Failed to search for players',
                icon = 'insurance'
            })
            cb(false)
        end
    end, data.searchQuery)
end)

RegisterNUICallback('getAllMedicalRecords', function(data, cb)
    Resmon.Lib.Callback.Client('Kibra:SmartPad:GetAllMedicalRecords', function(result)
        if result and result.success then
            cb(result)
        else
            TriggerServerEvent('Kibra:SmartPad:SendNewNotification', 'insurance', {
                title = 'Error',
                only = false,
                message = result.message or 'Failed to get medical records',
                icon = 'insurance'
            })
            cb(false)
        end
    end)
end)