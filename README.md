# mad-loot

# WIP

Purpose:
- Provide a centralised resource to manage all loot generation for different robbery types.
- Organize loot by defining customisable loot tables, each with multiple tiers (e.g., primary, secondary, tertiary).
- Easily generate randomised loot from the specified table, with chances to roll for different items and optional guaranteed rewards.

# Planned Features

- Define loot tables to be used in robberies, ex:
```lua
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

- Generate loot export, ex:
```lua
--- @function exports.mad-loot:GenerateLoot
--- @param tableName string - The loot table to use (e.g., 'fleecaBank').
--- @param tiers table|boolean|string - The tiers to roll on:
--- a string (e.g., 'primary') for a single tier,
--- a table of strings (e.g., {'primary', 'secondary'}) for multiple tiers,
--- or true to use all available tiers.
--- @param useGuaranteed boolean - Optional: whether to include guaranteed drops (default is false).
exports['mad-loot']:GenerateLoot('fleecaBank', {'primary', 'secondary'}, true)
```

- TODO: how the fuck do you secure this properly?
    - I guess if it all works off one export, as long as that event, and the config is secure, we're all gucci?
- TODO: Logging
- TODO: make a resource using this as an example (like the looting peureun_minigame)