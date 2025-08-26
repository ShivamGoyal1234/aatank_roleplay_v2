# Forge Jobs - Advanced Job System for FiveM

Forge Jobs is a comprehensive job system for FiveM servers, offering multiple interactive jobs with progression, processing, daily missions, and more. It's designed to be highly configurable and compatible with popular frameworks.

## Features

*   **Multiple Job Roles:** Mining, Hunting, Fishing, Lumberjack, Farming, Recycling.
*   **Interactive Job Mechanics:** Gathering resources, processing items through multiple stages.
*   **Leveling System:** Gain XP through job actions and unlock better tools.
*   **Tool System:** Purchase and use different tiers of tools based on job level.
*   **NPC Interaction:** Job NPCs for selling items, getting tools, and potentially more.
*   **Daily Missions:** Engaging daily tasks for extra rewards.
*   **Sell Shop:** Integrated market system for selling final products and raw materials (Retail & Wholesale).
*   **Localization:** Supports multiple languages (English, Spanish, French, German, Portuguese, Turkish, Arabic, Italian, Russian).
*   **High Configurability:** Extensive `config.lua` file to tweak almost every aspect.
*   **Framework Compatibility:** Supports ESX, QBCore, and QBox.
*   **System Integration:** Works with various inventory and target systems (ox_inventory, qb-inventory, quasar-inventory, ox_target, qb-target).

## Dependencies

*   **Framework:** ESX, QBCore, or QBox.
*   **Database:** oxmysql, mysql-async, or ghmattimysql.
*   **Inventory:** ox_inventory, qb-inventory, or quasar-inventory.
*   **Target System (Recommended):** ox_target or qb-target (or disable for floating text).
*   [ox_lib](https://github.com/overextended/ox_lib) (Commonly required for modern scripts, especially those using ox features).

## Installation

1.  **Download:** Obtain the script files, including the `EXTRA` folder.
2.  **Extract:** Place the `forge-jobs` folder (or your script's folder name) into your server's `resources` directory.
3.  **Install Extras:**
    *   **Props:**
        *   Install the prop resources found within the `EXTRA/[PROPS]` folder (`fury_cf_machines`, `fury_cf_workprops`, `fury_cfh_bones`) into your server's resources.
        *   **Important:** The `bzzz_onion` prop is **not** included in the `EXTRA` folder. Download and install it separately from [bzzz's Tebex Store](https://bzzz.tebex.io/package/5887685).
    *   **Items & Images:**
        *   Add the item definitions from `EXTRA/items` to your framework/inventory system. Snippets are provided for `ox_inventory`, `qb-inventory`, and `quasar-inventory`.
        *   Place the item images from `EXTRA/ITEMS INSTALLATION` into the corresponding image directory used by your inventory system (e.g., `ox_inventory/web/images` or your configured path).
    *   **Minigames:** Place the minigame resource(s) found in `EXTRA/[MINIGAMES]` into your server's `resources` directory.
4.  **Database:** Import the `.sql` file (likely found in the main script folder) into your database. This usually contains tables for player levels, missions, etc.
5.  **Configure `shared/config.lua`:**
    *   Set `Config.Framework` to your server's framework (`"ESX"`, `"QB"`, or `"QBOX"`).
    *   Set `Config.SQL` to your database wrapper (`"OXMYSQL"`, `"MYSQL-ASYNC"`, `"GHMATTIMYSQL"`).
    *   Set `Config.Inventory` to your inventory system (`"ox_inventory"`, `"qb-inventory"`, `"quasar-inventory"`).
    *   Set `Config.Target` to your target system (`"ox_target"`, `"qb-target"`) or `""` if you want to use floating 3D text (requires `ox_lib` for text UI).
    *   Review other settings like `Config.Locale`, `Config.CurrencySymbol`, job locations, item names, processing times, prices, etc., and adjust them to fit your server's economy and setup. **Ensure item names match the items you added in step 3.**
7.  **Server Configuration:** Add the following ensures to your `server.cfg` or `resources.cfg` **in this order**:
    *   `ensure ox_lib` (if not already started)
    *   `ensure forge-key`
    *   `ensure forge-strong`
    *   `ensure bzzz_onion`
    *   `ensure fury_cf_machines`
    *   `ensure fury_cf_workprops`
    *   `ensure fury_cfh_bones`
    *   `ensure forge-jobs` (or your script's folder name)
    *   Make sure they are ensured *after* their own dependencies (framework, inventory, target, etc.).
8.  **Restart Server:** Restart your FiveM server or the resource.

## Configuration

The primary configuration file is `shared/config.lua`. It allows detailed customization of:

*   Core settings (Framework, SQL, Inventory, Target, Locale).
*   Job-specific settings (locations, NPCs, items, processing steps, zones, models, loot).
*   Animation details and props.
*   Leveling system (max level, XP per level).
*   Daily missions (types, requirements, prizes).
*   Tools (item names, levels, prices, rewards).
*   Sell Shop (item availability, prices).
*   Localization strings.

## Localization

The script supports multiple languages.

1.  Add new language translations to the `Config.Locales` table in `shared/config.lua`.
2.  Set the default language using `Config.Locale` at the top of `shared/config.lua`.
3. Translate the UI in .HTML and .JS

## Support

For questions, issues, or support, please join our Discord server:

*   **https://discord.gg/UTVssdrXRV**

## Acknowledgements

We would like to extend our sincere thanks to the following creators for their contributions:

*   **FURY** ([Discord](https://discord.gg/DXe7vZwN2A)) for creating all the custom props used in this script.
*   **bzzz** ([Tebex](https://bzzz.tebex.io/)) for generously providing the onion prop free of charge.

--- 