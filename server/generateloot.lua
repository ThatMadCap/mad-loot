-- Imports & Global Variables -----------------------------------------------------

---@module 'duff.shared.math'
local math = lib.require "@duff.shared.math"

-- Attaching the math to a local variable from CDuff
local math = duff.math

local seed = math.seedrng()
if Debug then print("Math Seed RNG: " .. seed) end

local LootTables = lib.require("server/loottables")

local Debug = true -- true/false, provides useful prints for debugging

-- Functions -----------------------------------------------------------------------

local function RollForSuccess(low, high)
    local percentageChance = (low / high) * 100
    if Debug then lib.print.info("^3Attempting a " .. low .. " in " .. high .. " chance. (" .. string.format("%.2f%%", percentageChance) .. " chance)^0") end

    -- Generate a random roll between 1 and the high value
    local roll = math.random(1, high)

    -- Check if the roll matches the 'low' value, which represents the 1/high chance
    if roll <= low then
        if Debug then lib.print.info("^2Success! Rolled: " .. roll .. "^0") end
        return true -- Success
    else
        if Debug then lib.print.info("^1Failed! Rolled: " .. roll .. "^0") end
        return false -- Failure
    end
end

-- TODO: un-nest things in this function into their own helper functions/wrappers?
-- ex: ValidateInputs(), DetermineTiers(), RollTier(), RollItem(), UseGuaranteed()
-- I feel like there's a better way of programming that I just don't get.

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

    if Debug then
        lib.print.info("Selected tiers:")
        lib.print.info(selectedTiers)
    end

    -- Roll for each selected tier to determine loot
    for tierName, tierData in pairs(selectedTiers) do
        if Debug then lib.print.info("^5[ -- Generating chance for tier: " .. tierName .. " -- ]^0") end
        local tierSuccess = RollForSuccess(tierData.tableChance.low, tierData.tableChance.high)

        -- Early exit if tier roll fails
        if not tierSuccess then
            if Debug then lib.print.info('^1"' .. tierName .. '" tier not selected by chance^0') end
            goto continue
        end

        -- Check for overall guaranteed drops existence
        local hasGuaranteedDrops = tierData.guaranteed ~= nil

        -- Check if guaranteed drops are enabled and exist in the tier
        if not useGuaranteed then
            if Debug then lib.print.info("Guaranteed drops: false") end
        elseif not hasGuaranteedDrops then
            if Debug then lib.print.info('^1"' .. tierName .. '" tier has no guaranteed drops^0') end
        else
            -- Guaranteed drops processing
            if Debug then lib.print.info("^9Checking for guaranteed drops...^0") end
            for _, guaranteedDrop in ipairs(tierData.guaranteed) do
                local amount = math.random(guaranteedDrop.minAmount, guaranteedDrop.maxAmount)
                if Debug then lib.print.info('^2Guaranteed Drop Added - Item: "' .. guaranteedDrop.item .. '", Amount: ' .. amount .. "^0") end
                -- Add guaranteed drop to the loot table
                table.insert(loot, {item = guaranteedDrop.item, amount = amount})
            end
        end

        -- Roll for random items within the current tier (guaranteed drops handled earlier)
        for _, itemData in ipairs(tierData.items) do
            if Debug then lib.print.info('^4[ -- Generating chance for item: "' .. itemData.item .. '" in tier: ' .. tierName .. " -- ]^0") end
            local itemSuccess = RollForSuccess(itemData.itemChance.low, itemData.itemChance.high)

            -- Check if the item roll succeeded
            if itemSuccess then
                local amount = math.random(itemData.minAmount, itemData.maxAmount)
                -- Add selected item to the loot table
                table.insert(loot, {item = itemData.item, amount = amount})
                if Debug then lib.print.info('^2Item Added: "' .. itemData.item .. '", Amount: ' .. amount .. "^0") end
            end
        end

        ::continue::
    end

    if Debug then
        lib.print.info("^6Final loot: ^0")
        lib.print.info(loot)
    end
    return loot -- Return the generated loot table
end

-- Callback, Register and Export -----------------------------------------------------------------------

lib.callback.register('mad-loot:server:generateLoot', function(tableName, tiers, useGuaranteed)
    local src = source
    local loot = GenerateLoot(tableName, tiers, useGuaranteed)
    return loot
end)

exports("GenerateLoot", GenerateLoot)
RegisterServerEvent("mad-loot:server:generateLoot")
