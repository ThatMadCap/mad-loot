-- Variables -----------------------------------------------------------------------

SetConvar('ox:printlevel:'.. cache.resource, 'debug') -- Replace 'debug' with 'info' to disable debug prints
local LootTables = lib.require("server/loottables")

-- Functions -----------------------------------------------------------------------

local function RollForSuccess(low, high)
    local percentageChance = (low / high) * 100
    lib.print.debug(("^3Attempting a %d in %d chance. (%.2f%% chance)^0"):format(low, high, percentageChance))
    -- Generate a random roll between 1 and the high value
    local roll = math.random(1, high)

    -- Check if the roll matches the 'low' value, which represents the 1/high chance
    if roll <= low then
        lib.print.debug("^2Success! Rolled: " .. roll .. "^0")
        return true -- Success
    else
        lib.print.debug("^1Failed! Rolled: " .. roll .. "^0")
        return false -- Failure
    end
end

--- Function to generate random loot based on robbery type and tier
--- @param tableName string - The name of the loot table to use (e.g., 'fleecaBank').
--- @param tiers table|boolean|string - The tiers to roll on: a string (e.g., 'primary') for a single tier, a table of strings (e.g., {'primary', 'secondary'}) for multiple tiers, true to use all available tiers.
--- @param useGuaranteed boolean - Optional (default false): Whether to include guaranteed drops.
--- @returns table The generated loot table containing items and their amounts.
local function GenerateLoot(tableName, tiers, useGuaranteed)
    local lootTable = LootTables[tableName] -- Retrieve the loot table corresponding to the specified table name
    local loot = {} -- Store generated loot
    local selectedTiers = {} -- Store selected tiers
    useGuaranteed = useGuaranteed or false -- Set default for useGuaranteed

    -- Validate input
    if not lootTable then
        lib.print.warn("Loot table does not exist for: " .. tableName)
        return
    end

    if not tiers then
        lib.print.warn("Tier does not exist for: " .. tableName)
        return
    end

    -- Determine the tiers to select based on input type
    if type(tiers) == "boolean" then
        -- If true, select all available tiers
        if tiers then
            for tierName, tierData in pairs(lootTable) do
                selectedTiers[tierName] = tierData
            end
        else
            lib.print.warn("Tiers parameter is false, no tiers selected for: " .. tableName)
            return
        end
    elseif type(tiers) == "table" then
        -- If a table, check each tier name and add existing tiers
        for _, tier in ipairs(tiers) do
            if lootTable[tier] then
                selectedTiers[tier] = lootTable[tier]
            else
                lib.print.warn("Tier " .. tier .. " does not exist in table: " .. tableName)
            end
        end
    elseif type(tiers) == "string" then
        -- If a single string, check if the tier exists and add it
        if lootTable[tiers] then
            selectedTiers[tiers] = lootTable[tiers]
        else
            lib.print.warn("Tier " .. tiers .. " does not exist in table: " .. tableName)
        end
    elseif tiers == nil then
        -- Handle nil tiers case
        lib.print.warn("Tiers parameter is nil, no tiers selected for: " .. tableName)
        return
    end

    lib.print.debug("Selected tiers:")
    lib.print.debug(selectedTiers)

    -- Roll for each selected tier to determine loot
    for tierName, tierData in pairs(selectedTiers) do
        lib.print.debug("^5[ -- Generating chance for tier: " .. tierName .. " -- ]^0")
        local tierSuccess = RollForSuccess(tierData.tableChance.low, tierData.tableChance.high)

        if not tierSuccess then
            lib.print.debug('^1"' .. tierName .. '" tier not selected by chance^0')
        else
            lib.print.debug('^2"' .. tierName .. '" tier selected by chance^0')
        end

        -- Check for overall guaranteed drops existence
        local hasGuaranteedDrops = tierData.guaranteed ~= nil

        -- Process guaranteed drops
        if not useGuaranteed then
            lib.print.debug("Guaranteed drops: false")
        elseif not hasGuaranteedDrops then
            lib.print.debug('^1"' .. tierName .. '" tier has no guaranteed drops^0')
        else
            lib.print.debug("^9Checking for guaranteed drops...^0")
            for _, guaranteedDrop in ipairs(tierData.guaranteed) do
                local amount = math.random(guaranteedDrop.minAmount, guaranteedDrop.maxAmount)
                lib.print.debug('^2Guaranteed Drop Added - Item: "' .. guaranteedDrop.item .. '", Amount: ' .. amount .. "^0")
                -- Add guaranteed drop to the loot table
                table.insert(loot, {item = guaranteedDrop.item, amount = amount})
            end
        end

        -- Roll for random items within the current tier
        if tierSuccess then
            for _, itemData in ipairs(tierData.items) do
                lib.print.debug('^4[ -- Generating chance for item: "' .. itemData.item .. '" in tier: ' .. tierName .. " -- ]^0")
                local itemSuccess = RollForSuccess(itemData.itemChance.low, itemData.itemChance.high)

                -- Check if the item roll succeeded
                if itemSuccess then
                    local amount = math.random(itemData.minAmount, itemData.maxAmount)
                    -- Add selected item to the loot table
                    table.insert(loot, {item = itemData.item, amount = amount})
                    lib.print.debug('^2Item Added: "' .. itemData.item .. '", Amount: ' .. amount .. "^0")
                end
            end
        end
    end

    lib.print.debug("^6Final loot: ^0")
    lib.print.debug(loot)

    return loot -- Return the generated loot table
end

-- Callback, Register and Export -----------------------------------------------------------------------

lib.callback.register('mad-loot:server:generateLoot', function(_, tableName, tiers, useGuaranteed)
    local loot = GenerateLoot(tableName, tiers, useGuaranteed)
    return loot
end)

exports("GenerateLoot", GenerateLoot)