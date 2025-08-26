QBCore = exports['qb-core']:GetCoreObject()

QBCore.Shared.Items = QBCore.Shared.Items or {}

QBCore.Shared.Items['bandage'] = {
    name = 'bandage', label = 'Bandage', weight = 100, type = 'item',
    image = 'bandage.png', unique = false, useable = true, shouldClose = true,
    description = 'Heals +10 health, 50% chance to stop bleeding'
}

QBCore.Shared.Items['ifak'] = {
    name = 'ifak', label = 'IFAK', weight = 150, type = 'item',
    image = 'ifak.png', unique = false, useable = true, shouldClose = true,
    description = 'Heals +10 health and relieves stress'
}
