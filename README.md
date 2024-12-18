# mad-loot

Inspired by Old School RuneScape drop tables, mad-loot is a centralised loot generation resource designed to handle all your player reward distribution needs. Whether you're running a robbery system or giving rewards for other activities, mad-loot allows you to create fully customisable and randomisable loot tables with ease.

## Why use it?

Traditionally, managing rewards across various activities like robberies can get complicated. mad-loot simplifies this by offering:

- Centralised loot management: no more digging around each individual resource to define rewards.
- Customisable loot tables with multiple tiers (e.g., uncommon, common, rare, legendary).
- Randomise loot with defined chances for item drops, including optional guaranteed rewards.

This resource is perfect for anyone who wants to add an engaging, scalable loot system to their server.

## Features

### Customizable Loot Tables
Define unique loot tables for different scenarios, such as robberies, events, or missions.
Each loot table can have:
- Tiers: Organize loot into categories like primary, secondary, and tertiary.
- Drop Chances: Specify odds for rolling on a tier or individual items.
- Guaranteed Rewards: Add guaranteed drops for specific items.

### Flexible
Use predefined tiers or roll on all tiers at once.
Set custom chances for each tier and item.
Scale loot probabilities dynamically for different scenarios.

### Simple Loot Generation
Easily generate loot with a single export. Choose which tiers to roll on and whether to include guaranteed drops.

## How does it work?

To use mad-loot, define a loot table with tiers and item chances. Then, call the `GenerateLoot` export to roll the loot, which can be processed and added to a player's inventory with ease.

#### Define your loot table
<details>
<summary>Example for a bank robbery: (Click to Expand)</summary>

```lua
-- Here's how you might define a loot table for a robbery scenario like the Fleeca Bank:
fleecaBank = {
    primary = {
        tableChance = { low = 1, high = 1 },
        items = {
            { item = "lockpick", itemChance = { low = 1, high = 2 }, minAmount = 1, maxAmount = 10 },
            { item = "water", itemChance = { low = 1, high = 5 }, minAmount = 1, maxAmount = 10 },
            { item = "cola", itemChance = { low = 1, high = 3 }, minAmount = 1, maxAmount = 10 },
        },
        guaranteed = {
            { item = "coffee", minAmount = 1, maxAmount = 1 },
        }
    },
    secondary = {
        tableChance = { low = 1, high = 10 },
        items = {
            { item = "ammo-9", itemChance = { low = 50, high = 100 }, minAmount = 1, maxAmount = 10 },
            { item = "garbage", itemChance = { low = 15, high = 100 }, minAmount = 1, maxAmount = 10 },
        },
    },
    -- define as many tiers as you like
}
```
</details>

#### Call the export
Easily generate loot with a single export function. Choose which tiers to roll on and whether to include guaranteed drops.

<details>
<summary>Generate loot export example: (Click to Expand)</summary>

```lua
local tableName = "fleecaBank"      -- The name of the loot table to use
local tiers = true                  -- Roll on all available tiers
local useGuaranteed = true          -- Include guaranteed drops

local loot = exports["mad-loot"]:GenerateLoot(tableName, tiers, useGuaranteed)
```
</details>

## Export Reference: `GenerateLoot`

`GenerateLoot` generates loot based on a specified loot table and its tiers, returning a table of loot items.

**Parameters:**
- `tableName:` (string) - The loot table's name (e.g., `'fleecaBank'`).
- `tiers:` (string | table | boolean) - Tiers to roll on:
  - A single string (e.g., `'primary'`) for one tier.
  - A table of strings (e.g., `{'primary', 'secondary'}`) for multiple tiers.
  - `true` to roll on all available tiers.
- `useGuaranteed` (boolean) *optional* - Whether to include guaranteed drops (default is `false`).

**Returns:**
- An array of loot items, each with:
  - `item: string` - Name of the item.
  - `amount: number` - The quantity of the item.


**Example Usage:**

Server-side:

```lua
local loot = exports['mad-loot']:GenerateLoot('fleecaBank', {'primary', 'secondary'}, true)

-- Example of processing the loot
for _, item in ipairs(loot) do
    print("Player receives: " .. item.amount .. 'x "' .. item.item .. '"')
    -- Example adding generated loot items with ox_inventory:
    -- (Replace with your own inventory system if needed)
    -- exports.ox_inventory:AddItem(source, item.item, item.amount)
end
```
Client-side:

```lua
local loot = lib.callback.await("mad-loot:server:generateLoot", false, "fleecaBank", true, true)

-- Example of processing the loot
for _, item in ipairs(loot) do
    print("Player receives: " .. item.amount .. 'x "' .. item.item .. '"')
    -- Example adding generated loot items with ox_inventory:
    -- (Replace with your own inventory system if needed)
    -- exports.ox_inventory:AddItem(source, item.item, item.amount)
end
```

## Dependencies

- [ox_lib](https://github.com/overextended/ox_lib)

## Contributing
If you'd like to contribute to mad-loot, feel free to open issues or submit pull requests. Please follow the project's coding conventions and ensure tests are included for any new features.
