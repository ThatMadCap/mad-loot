return
{ -- Store global loot tables
    fleecaBank = { -- Name of your loot table
        primary = { -- Tiers: Define as many as you want (ex: common, rare, legendary)
            tableChance = { low = 1, high = 1 }, -- Chance to roll on the table (low/high)
            items = { -- List of rewards
                { -- item example
                    item = "lockpick", -- item name
                    itemChance = { low = 1, high = 2 }, -- chance to get the item (low/high)
                    minAmount = 1, -- minimum amount to get
                    maxAmount = 2 -- maxiumum amount to get
                },
                { item = "water", itemChance = { low = 1, high = 5 }, minAmount = 1, maxAmount = 10 },
                { item = "cola", itemChance = { low = 1, high = 3 }, minAmount = 1, maxAmount = 10 },
                {
                    item = "highTechDevice",
                    itemChance = {low = 1, high = 10},
                    minAmount = 1,
                    maxAmount = 1,
                },
            },
            guaranteed = { -- optional, define guaranteed drops
                { item = "coffee", minAmount = 1, maxAmount = 1 },
            }
        },
        secondary = { -- example of table with no guaranteed drop
            tableChance = { low = 1, high = 10 },
            items = {
                { item = "ammo-9", itemChance = { low = 50, high = 100 }, minAmount = 1, maxAmount = 10 },
                { item = "garbage", itemChance = { low = 15, high = 100 }, minAmount = 1, maxAmount = 10 },
            },
        },
        tertiary = {
            tableChance = { low = 1, high = 1 },
            items = {
                { item = "panties", itemChance = { low = 1, high = 3000 }, minAmount = 1, maxAmount = 1 },
            },
            guaranteed = {
                { item = "parachute", minAmount = 1, maxAmount = 1 },
            }
        }
    },
    -- add more as as needed
}