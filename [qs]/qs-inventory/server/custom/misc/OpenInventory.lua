RegisterNetEvent(Config.InventoryPrefix .. ':server:OpenInventory', function(name, id, other, entityModel, customLabel)
	local src = source
	local jobName = GetJobName(src)
	local IsVehicleOwned = IsVehicleOwned(id)

	Player(src).state:set('inv_busy', false, true)

	local blocked = false
	for k, v in pairs(searchingInventories) do
		if v == src then
			blocked = true
		end
	end
	if blocked then
		return TriggerClientEvent(Config.InventoryPrefix .. ':client:sendTextMessage', src, Lang('INVENTORY_NOTIFICATION_INVENTORY_SEARCH_BUSY'), 'error')
	end

	Debug('The inventory was opened with id:', id)

	if name and id then
		local secondInv = {}
		if name == 'stash' then
			if Stashes[id] then
				if Stashes[id].isOpen then
					local Target = GetPlayerFromId(Stashes[id].isOpen)
					if Target then
						TriggerClientEvent(Config.InventoryPrefix .. ':client:CheckOpenState', Stashes[id].isOpen, name, id, Stashes[id].label)
					else
						Stashes[id].isOpen = false
					end
				end
			end
			local maxweight = 1000000
			local slots = 50
			if other then
				maxweight = other.maxweight or 1000000
				slots = other.slots or 50
			end
			secondInv.name = 'stash-' .. id
			secondInv.label = customLabel or id
			secondInv.maxweight = maxweight
			secondInv.inventory = {}
			secondInv.slots = slots
			if Stashes[id] and Stashes[id].isOpen then
				return InventoryInUse(src)
			else
				local stashItems = GetOtherInventoryItems('stash', id)
				if next(stashItems) then
					secondInv.inventory = stashItems
					Stashes[id] = {}
					Stashes[id].items = stashItems
					Stashes[id].isOpen = src
					Stashes[id].label = secondInv.label
				else
					Stashes[id] = {}
					Stashes[id].items = {}
					Stashes[id].isOpen = src
					Stashes[id].label = secondInv.label
				end
			end
		elseif name == 'trunk' then
			if Trunks[id] then
				if Trunks[id].isOpen then
					local Target = GetPlayerFromId(Trunks[id].isOpen)
					if Target then
						TriggerClientEvent(Config.InventoryPrefix .. ':client:CheckOpenState', Trunks[id].isOpen, name, id, Trunks[id].label)
					else
						Trunks[id].isOpen = false
					end
				end
			end
			secondInv.name = 'trunk-' .. id
			secondInv.label = Lang('INVENTORY_NUI_TRUNK_LABEL') .. '-' .. id
			secondInv.maxweight = other.maxweight or 60000
			secondInv.inventory = {}
			secondInv.slots = other.slots or 50
			if (Trunks[id] and Trunks[id].isOpen) or (SplitStr(id, 'PLZI')[2] and jobName ~= 'police') then
				return InventoryInUse(src)
			else
				if Config.OpenTrunkAll and id then
					local ownedItems = GetOtherInventoryItems('trunk', id)
					if IsVehicleOwned and next(ownedItems) then
						secondInv.inventory = ownedItems
						Trunks[id] = {}
						Trunks[id].items = ownedItems
						Trunks[id].isOpen = src
						Trunks[id].label = secondInv.label
					elseif Trunks[id] and not Trunks[id].isOpen then
						secondInv.inventory = Trunks[id].items
						Trunks[id].isOpen = src
						Trunks[id].label = secondInv.label
					else
						Trunks[id] = {}
						Trunks[id].items = {}
						Trunks[id].isOpen = src
						Trunks[id].label = secondInv.label
					end
				else
					if IsVehicleOwnedAbleToOpen(id, src) or (Config.OpenTrunkPolice and GetJobName(src) == 'police' and GetJobGrade(src) >= Config.OpenTrunkPoliceGrade) then
						local ownedItems = GetOtherInventoryItems('trunk', id)
						if IsVehicleOwned and next(ownedItems) then
							secondInv.inventory = ownedItems
							Trunks[id] = {}
							Trunks[id].items = ownedItems
							Trunks[id].isOpen = src
							Trunks[id].label = secondInv.label
						elseif Trunks[id] and not Trunks[id].isOpen then
							secondInv.inventory = Trunks[id].items
							Trunks[id].isOpen = src
							Trunks[id].label = secondInv.label
						else
							Trunks[id] = {}
							Trunks[id].items = {}
							Trunks[id].isOpen = src
							Trunks[id].label = secondInv.label
						end
					else
						TriggerClientEvent(Config.InventoryPrefix .. ':client:closeinv', src)
						return TriggerClientEvent(Config.InventoryPrefix .. ':client:sendTextMessage', src, Lang('INVENTORY_NOTIFICATION_TRUNK_BLOCKED'), 'error')
					end
				end
			end
		elseif name == 'glovebox' then
			if Gloveboxes[id] then
				if Gloveboxes[id].isOpen then
					local Target = GetPlayerFromId(Gloveboxes[id].isOpen)
					if Target then
						TriggerClientEvent(Config.InventoryPrefix .. ':client:CheckOpenState', Gloveboxes[id].isOpen, name, id, Gloveboxes[id].label)
					else
						Gloveboxes[id].isOpen = false
					end
				end
			end
			secondInv.name = 'glovebox-' .. id
			secondInv.label = Lang('INVENTORY_NUI_GLOVEBOX_LABEL') .. '-' .. id
			secondInv.maxweight = other?.maxweight or 10000
			secondInv.inventory = {}
			secondInv.slots = other?.slots or 10
			if Gloveboxes[id] and Gloveboxes[id].isOpen then
				return InventoryInUse(src)
			else
				if Config.OpenGloveboxesAll then
					local ownedItems = GetOtherInventoryItems('glovebox', id)
					if Gloveboxes[id] and not Gloveboxes[id].isOpen then
						secondInv.inventory = Gloveboxes[id].items
						Gloveboxes[id].isOpen = src
						Gloveboxes[id].label = secondInv.label
					elseif IsVehicleOwned and next(ownedItems) then
						secondInv.inventory = ownedItems
						Gloveboxes[id] = {}
						Gloveboxes[id].items = ownedItems
						Gloveboxes[id].isOpen = src
						Gloveboxes[id].label = secondInv.label
					else
						Gloveboxes[id] = {}
						Gloveboxes[id].items = {}
						Gloveboxes[id].isOpen = src
						Gloveboxes[id].label = secondInv.label
					end
				else
					if IsVehicleOwnedAbleToOpen(id, src) or (Config.OpenGloveboxesPolice and GetJobName(src) == 'police' and GetJobGrade(src) >= Config.OpenGloveboxesPoliceGrade) then
						local ownedItems = GetOtherInventoryItems('glovebox', id)
						if Gloveboxes[id] and not Gloveboxes[id].isOpen then
							secondInv.inventory = Gloveboxes[id].items
							Gloveboxes[id].isOpen = src
							Gloveboxes[id].label = secondInv.label
						elseif IsVehicleOwned and next(ownedItems) then
							secondInv.inventory = ownedItems
							Gloveboxes[id] = {}
							Gloveboxes[id].items = ownedItems
							Gloveboxes[id].isOpen = src
							Gloveboxes[id].label = secondInv.label
						else
							Gloveboxes[id] = {}
							Gloveboxes[id].items = {}
							Gloveboxes[id].isOpen = src
							Gloveboxes[id].label = secondInv.label
						end
					else
						TriggerClientEvent(Config.InventoryPrefix .. ':client:closeinv', src)
						return TriggerClientEvent(Config.InventoryPrefix .. ':client:sendTextMessage', src, Lang('INVENTORY_NOTIFICATION_GLOVEBOX_BLOCKED'), 'error')
					end
				end
			end
		elseif name == 'shop' then
			secondInv.name = 'itemshop-' .. id
			secondInv.label = other.label
			secondInv.maxweight = 900000
			secondInv.inventory = SetupShopItems(other.items)
			RegisteredShops[id] = {
				name = id,
				label = other.label,
				coords = other.coords,
				slots = #other.items,
				items = secondInv.inventory,
				account = other.type or 'money'
			}
			secondInv.slots = #other.items
			Debug('The store you opened uses the account ' .. json.encode(RegisteredShops[id].account))
		elseif name == 'selling' then
			secondInv.name = 'selling-' .. id
			secondInv.label = other.label
			secondInv.maxweight = 900000
			secondInv.inventory = SetupSellingItems(id, other.items)
			SellItems[id] = {}
			SellItems[id].items = other.items
			secondInv.slots = #other.items
		elseif name == 'garbage' then
			if not entityModel then Debug('Model for garbage system not found') end
			secondInv.name = 'garbage_' .. id
			secondInv.label = Lang('INVENTORY_NUI_GARBAGE_LABEL') .. '-' .. id
			secondInv.maxweight = 900000
			if GarbageItems[id] == nil then
				GarbageItems[id] = {}
				local items = {}
				Config.GarbageItems[id] = Config.GarbageItemsForProp[entityModel].items[math.random(1, #Config.GarbageItemsForProp[entityModel].items)]
				for a, x in pairs(Config.GarbageItems[id]) do
					local itemInfo = ItemInfo(x)
					if not itemInfo then
						Error('There is an item that does not exist in this garbage store!')
						goto continue
					end
					items[a] = table.clone(x)
					items[a].amount = math.random(x.amount.min, x.amount.max)
					::continue::
				end

				GarbageItems[id].items = items
			end
			secondInv.inventory = SetupGarbageItems(id, GarbageItems[id].items)
			secondInv.slots = 30
		elseif name == 'traphouse' then
			secondInv.name = 'traphouse-' .. id
			secondInv.label = other.label
			secondInv.maxweight = 900000
			secondInv.inventory = other.items
			secondInv.slots = other.slots
		elseif name == 'crafting' then
			secondInv.name = 'crafting'
			secondInv.label = other.label
			secondInv.maxweight = 900000
			secondInv.inventory = other.items
			secondInv.slots = #other.items
		elseif name == 'attachment_crafting' then
			secondInv.name = 'attachment_crafting'
			secondInv.label = other.label
			secondInv.maxweight = 900000
			secondInv.inventory = other.items
			secondInv.slots = #other.items
		elseif name == 'customcrafting' then
			secondInv.name = 'customcrafting'
			secondInv.label = other.label
			secondInv.maxweight = 900000
			secondInv.inventory = other.items
			secondInv.slots = #other.items
		elseif name == 'otherplayer' then
			id = tonumber(id)
			local OtherPlayer = GetPlayerFromId(id)
			if OtherPlayer then
				if Player(id).state.inv_busy then
					return
				end
				secondInv.name = 'otherplayer-' .. id
				secondInv.label = 'Player-' .. id
				secondInv.maxweight = Config.InventoryWeight.weight
				secondInv.inventory = FormatInventoryByType(Inventories[id], other?.type)
				searchingInventories[src] = id
				secondInv.slots = Config.InventoryWeight.slots
				TriggerClientEvent(Config.InventoryPrefix .. ':client:sendTextMessage', id, Lang('INVENTORY_NOTIFICATION_ROBBERY_WARNING'), 'inform')
				Wait(250)
			end
		else
			if Drops[id] then
				if Drops[id].isOpen then
					local Target = GetPlayerFromId(Drops[id].isOpen)
					if Target then
						TriggerClientEvent(Config.InventoryPrefix .. ':client:CheckOpenState', Drops[id].isOpen, name, id, Drops[id].label)
					else
						Drops[id].isOpen = false
					end
				end
			end
			if Drops[id] and not Drops[id].isOpen then
				secondInv.coords = Drops[id].coords
				secondInv.name = 'dropped-' .. id
				secondInv.label = 'Dropped-' .. tostring(id)
				secondInv.maxweight = Config.DropWeight.weight
				secondInv.inventory = Drops[id].items
				secondInv.slots = Config.DropWeight.slots
				Drops[id].isOpen = src
				Drops[id].label = secondInv.label
				Drops[id].createdTime = os.time()
			else
				return InventoryInUse(src)
			end
		end
		Wait(0)
		TriggerClientEvent(Config.InventoryPrefix .. ':client:OpenInventory', src, {}, Inventories[src], secondInv)
		OpenedSecondInventories[src] = secondInv
	else
		TriggerClientEvent(Config.InventoryPrefix .. ':client:OpenInventory', src, {}, Inventories[src])
	end
end)

function OpenInventory(name, id, other, origin)
	local src = origin
	local player = GetPlayerFromId(src)
	local jobName = GetJobName(src)
	Player(src).state:set('inv_busy', false, true)

	local blocked = false
	for k, v in pairs(searchingInventories) do
		if v == src then
			blocked = true
		end
	end
	if blocked then
		return TriggerClientEvent(Config.InventoryPrefix .. ':client:sendTextMessage', src, Lang('INVENTORY_NOTIFICATION_INVENTORY_SEARCH_BUSY'), 'error')
	end

	Debug('The inventory was opened with id:', id)
	if name and id then
		local secondInv = {}
		if name == 'stash' then
			if Stashes[id] then
				if Stashes[id].isOpen then
					local Target = GetPlayerFromId(Stashes[id].isOpen)
					if Target then
						TriggerClientEvent(Config.InventoryPrefix .. ':client:CheckOpenState', Stashes[id].isOpen, name, id, Stashes[id].label)
					else
						Stashes[id].isOpen = false
					end
				end
			end
			local maxweight = 1000000
			local slots = 50
			if other then
				maxweight = other.maxweight or 1000000
				slots = other.slots or 50
			end
			secondInv.name = 'stash-' .. id
			secondInv.label = 'Stash-' .. id
			secondInv.maxweight = maxweight
			secondInv.inventory = {}
			secondInv.slots = slots
			if Stashes[id] and Stashes[id].isOpen then
				secondInv.name = 'none-inv'
				secondInv.label = 'Stash-None'
				secondInv.maxweight = 1000000
				secondInv.inventory = {}
				secondInv.slots = 0
			else
				local stashItems = GetOtherInventoryItems('stash', id)
				if next(stashItems) then
					secondInv.inventory = stashItems
					Stashes[id] = {}
					Stashes[id].items = stashItems
					Stashes[id].isOpen = src
					Stashes[id].label = secondInv.label
				else
					Stashes[id] = {}
					Stashes[id].items = {}
					Stashes[id].isOpen = src
					Stashes[id].label = secondInv.label
				end
			end
		elseif name == 'trunk' then
			if Trunks[id] then
				if Trunks[id].isOpen then
					local Target = GetPlayerFromId(Trunks[id].isOpen)
					if Target then
						TriggerClientEvent(Config.InventoryPrefix .. ':client:CheckOpenState', Trunks[id].isOpen, name, id, Trunks[id].label)
					else
						Trunks[id].isOpen = false
					end
				end
			end
			secondInv.name = 'trunk-' .. id
			secondInv.label = 'Trunk-' .. id
			secondInv.maxweight = other.maxweight or 60000
			secondInv.inventory = {}
			secondInv.slots = other.slots or 50
			if (Trunks[id] and Trunks[id].isOpen) or (SplitStr(id, 'PLZI')[2] and (jobName ~= 'police')) then
				secondInv.name = 'none-inv'
				secondInv.label = 'Trunk-None'
				secondInv.maxweight = other.maxweight or 60000
				secondInv.inventory = {}
				secondInv.slots = 0
			else
				if id then
					local ownedItems = GetOtherInventoryItems('trunk', id)
					if IsVehicleOwned(id) and next(ownedItems) then
						secondInv.inventory = ownedItems
						Trunks[id] = {}
						Trunks[id].items = ownedItems
						Trunks[id].isOpen = src
						Trunks[id].label = secondInv.label
					elseif Trunks[id] and not Trunks[id].isOpen then
						secondInv.inventory = Trunks[id].items
						Trunks[id].isOpen = src
						Trunks[id].label = secondInv.label
					else
						Trunks[id] = {}
						Trunks[id].items = {}
						Trunks[id].isOpen = src
						Trunks[id].label = secondInv.label
					end
				end
			end
		elseif name == 'glovebox' then
			if Gloveboxes[id] then
				if Gloveboxes[id].isOpen then
					local Target = GetPlayerFromId(Gloveboxes[id].isOpen)
					if Target then
						TriggerClientEvent(Config.InventoryPrefix .. ':client:CheckOpenState', Gloveboxes[id].isOpen, name, id, Gloveboxes[id].label)
					else
						Gloveboxes[id].isOpen = false
					end
				end
			end
			secondInv.name = 'glovebox-' .. id
			secondInv.label = 'Glovebox-' .. id
			secondInv.maxweight = 10000
			secondInv.inventory = {}
			secondInv.slots = 5
			if Gloveboxes[id] and Gloveboxes[id].isOpen then
				secondInv.name = 'none-inv'
				secondInv.label = 'Glovebox-None'
				secondInv.maxweight = 10000
				secondInv.inventory = {}
				secondInv.slots = 0
			else
				local ownedItems = GetOtherInventoryItems('glovebox', id)
				if Gloveboxes[id] and not Gloveboxes[id].isOpen then
					secondInv.inventory = Gloveboxes[id].items
					Gloveboxes[id].isOpen = src
					Gloveboxes[id].label = secondInv.label
				elseif IsVehicleOwned(id) and next(ownedItems) then
					secondInv.inventory = ownedItems
					Gloveboxes[id] = {}
					Gloveboxes[id].items = ownedItems
					Gloveboxes[id].isOpen = src
					Gloveboxes[id].label = secondInv.label
				else
					Gloveboxes[id] = {}
					Gloveboxes[id].items = {}
					Gloveboxes[id].isOpen = src
					Gloveboxes[id].label = secondInv.label
				end
			end
		elseif name == 'shop' then
			secondInv.name = 'itemshop-' .. id
			secondInv.label = other.label
			secondInv.maxweight = 900000
			secondInv.inventory = SetupShopItems(other.items)
			RegisteredShops[id] = {
				name = id,
				label = other.label,
				coords = other.coords,
				slots = #other.items,
				items = secondInv.inventory,
				account = other.type or 'money'
			}
			secondInv.slots = #other.items
		elseif name == 'traphouse' then
			secondInv.name = 'traphouse-' .. id
			secondInv.label = other.label
			secondInv.maxweight = 900000
			secondInv.inventory = other.items
			secondInv.slots = other.slots
		elseif name == 'crafting' then
			secondInv.name = 'crafting'
			secondInv.label = other.label
			secondInv.maxweight = 900000
			secondInv.inventory = other.items
			secondInv.slots = #other.items
		elseif name == 'attachment_crafting' then
			secondInv.name = 'attachment_crafting'
			secondInv.label = other.label
			secondInv.maxweight = 900000
			secondInv.inventory = other.items
			secondInv.slots = #other.items
		elseif name == 'otherplayer' then
			id = tonumber(id)
			local OtherPlayer = GetPlayerFromId(id)
			if OtherPlayer then
				if Player(id).state.inv_busy then
					return
				end
				secondInv.name = 'otherplayer-' .. id
				secondInv.label = 'Player-' .. id
				secondInv.maxweight = Config.InventoryWeight.weight
				local items = {}
				for k, v in pairs(Inventories[id]) do
					if k ~= 41 or jobName == 'police' then
						items[k] = v
					end
				end
				secondInv.inventory = items
				searchingInventories[src] = id
				secondInv.slots = Config.InventoryWeight.slots
				if jobName ~= 'police' then
					secondInv.slots = secondInv.slots - 1
				end
				TriggerClientEvent(Config.InventoryPrefix .. ':client:sendTextMessage', id, Lang('INVENTORY_NOTIFICATION_ROBBERY_WARNING'), 'inform')
				Wait(250)
			end
		else
			if Drops[id] then
				if Drops[id].isOpen then
					local Target = GetPlayerFromId(Drops[id].isOpen)
					if Target then
						TriggerClientEvent(Config.InventoryPrefix .. ':client:CheckOpenState', Drops[id].isOpen, name, id, Drops[id].label)
					else
						Drops[id].isOpen = false
					end
				end
			end
			if Drops[id] and not Drops[id].isOpen then
				secondInv.coords = Drops[id].coords
				secondInv.name = id
				secondInv.label = 'Dropped-' .. tostring(id)
				secondInv.maxweight = 100000
				secondInv.inventory = Drops[id].items
				secondInv.slots = 30
				Drops[id].isOpen = src
				Drops[id].label = secondInv.label
				Drops[id].createdTime = os.time()
			else
				secondInv.name = 'none-inv'
				secondInv.label = 'Dropped-None'
				secondInv.maxweight = 100000
				secondInv.inventory = {}
				secondInv.slots = 0
			end
		end
		Wait(0)
		TriggerClientEvent(Config.InventoryPrefix .. ':client:OpenInventory', src, {}, Inventories[src], secondInv)
		OpenedSecondInventories[src] = secondInv
	else
		TriggerClientEvent(Config.InventoryPrefix .. ':client:OpenInventory', src, {}, Inventories[src])
	end
end

sharedExports('OpenInventory', OpenInventory)
