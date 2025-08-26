---@class ServerFramework
---@field getPlayerFromId fun(self: ServerFramework, source: number): table
---@field getIdentifier fun(self: ServerFramework, source: number): string
---@field getAccountMoney fun(self: ServerFramework, source: number, account: MoneyType): number
---@field removeAccountMoney fun(self: ServerFramework, source: number, account: MoneyType, amount: number): boolean
---@field addAccountMoney fun(self: ServerFramework, source: number, account: MoneyType, amount: number)
---@field removeItem fun(self: ServerFramework, source: number, item: string, count: number)
---@field playerIsAdmin fun(self: ServerFramework, source: number): boolean
---@field getUserName fun(self: ServerFramework, source: number): string, string
---@field registerUsableItem fun(self: ServerFramework, item: string, cb: function)
---@field getSourceFromIdentifier fun(self: ServerFramework, identifier: string): number
---@field getItem fun(self: ServerFramework, player: table, item: string): {count: number}
---@field addItem fun(self: ServerFramework, source: number, item: string, count: number, slot?: number | false, info?: table): boolean
---@field getInside fun(self: ServerFramework, source: number): string
---@field updateInside fun(self: ServerFramework, source: number, data: string | nil)
---@field getUserNameFromIdentifier fun(self: ServerFramework, identifier: string): string
---@field getJobName fun(self: ServerFramework, source: number): string
---@field getPlayers fun(self: ServerFramework): table

---@class ClientFramework
---@field getPlayerData fun(self: ClientFramework): table
---@field getIdentifier fun(self: ClientFramework): string
---@field getJobName fun(self: ClientFramework): string
---@field getJobGrade fun(self: ClientFramework): number
---@field getPlayers fun(self: ClientFramework): table

---@class DecorationObject
---@field id number
---@field modelName string
---@field coords vector3
---@field rotation vector3
---@field handle number
---@field inStash boolean
---@field spawned? boolean
---@field created string | osdate
---@field lab string

---@class CreateFarm
---@field name string
---@field type string
---@field zone CollectionData
---@field blip? Blip
---@field maxCollectionCount number

---@class CreateLab
---@field name string
---@field shell {entry: vector4, tier: number, shellCoords: vector4, exit: vector4}
---@field price number
---@field blip? Blip

---@class CreateSeller
---@field name string
---@field entry vector4
---@field blip? Blip
---@field model string
---@field time? {startDuty: number, endDuty: number}
---@field knock boolean
---@field itemListId string

---@class DrugFarm : CreateFarm
---@field id number
---@field creator string

---@class DrugLab : CreateLab
---@field id number
---@field name string
---@field stash? vector3
---@field wardrobe? vector3
---@field owner? string
---@field locked boolean
---@field holders string[]
---@field level number
---@field progress number Progress of level
---@field public boolean

---@class DrugSeller : CreateSeller
---@field id number
---@field creator string

---@alias ZoneType 'collection' | 'lab' | 'seller'
---@alias ProcessType 'process' | 'package' | 'wash'
---@alias MoneyType 'money' | 'bank' | 'black_money'
---@alias CollectionData {points: vector3[], thickness: number, objectCoords?: vector3}
---@alias LabData {entry: vector4, tier: number, shellCoords: vector4}]]
---@alias Blip {coords: vector3, color: number, sprite: number, scale: number, name: string}
---@alias SceneType 'Money' | 'Cocaine' | 'Meth' | 'Meth'
---@alias DrugEffect 'pink_visual' | 'visual_shaking' | 'drunk_walk' | 'green_visual' | 'confused_visual' | 'armor50' | 'armor100' | 'health50' | 'health100' | 'sprint_faster' | 'swim_faster' | 'fall' | 'infinite_stamina'
---@alias DrugEffectType 'pill' | 'drink' | 'smoke' | 'needle'

---@class ActiveZone
---@field players table<number, boolean>
---@field spawned boolean
---@field spawnerSource? number
---@field objects? {netId: number, pointId: number}[]
---@field spawnCount number
---@field defaultSpawnCount number
---@field spawnPoints? vector3
---@field timer? OxTimer

---@class UpdateObject
---@field coords? string
---@field rotation? string
---@field inStash? boolean

---@class Process
---@field progText string
---@field requireRate number
---@field level number
---@field requireItem? string
---@field requireMoney? boolean
---@field notifyname string
---@field rewardItem? string
---@field rewardRate number
---@field rewardMoney? boolean
---@field time number
---@field act string
---@field process ProcessType
---@field headingOffset number
---@field extraProps? {model: string, pos: vector3, headingOffset: number}[]
---@field coordsOffset vector3

---@class Scene
---@field dict string
---@field pedAnim string
---@field scene SceneObject[]

---@class SceneObject
---@field model string
---@field anim string
---@field coords vector3
---@field heading number
