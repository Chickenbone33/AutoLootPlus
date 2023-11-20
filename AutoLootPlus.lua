local AutoLootPlus = CreateFrame("Frame");

function AutoLootPlus:OnEvent(event, arg1, ...)
    if event == "LOOT_OPENED" or (event == "CVAR_UPDATE" and arg1 == "autoLoot") then
        self:CheckAutoLootStatus()
    elseif event == "LOOT_CLOSED" then
        self:UnregisterEvent("LOOT_CLOSED")
    elseif event == "PLAYER_ENTERING_WORLD" then
        self:CheckAutoLootStatus()
    end
end

function AutoLootPlus:CheckAutoLootStatus()
    local autoLootEnabled = GetCVar("autoLootDefault") == "1" or (GetCVar("autoLootDefault") == "0" and GetCVar("autoLoot") == "1")

    if autoLootEnabled then
        self:RegisterEvent("LOOT_CLOSED")
        C_Timer.After(0.1, function()
            for index = 1, GetNumLootItems() do
                local lootIcon, _, _, quality, _, _, isQuestItem, _, _, itemID, _, _, _, _, isBoE = GetLootSlotInfo(index)
                if quality >= ITEM_QUALITY_RARE or isBoE then
                    LootSlot(index)
                    C_Timer.After(0.001, function()
                        ConfirmLootSlot(index)
                    end)
                end
            end
        end)
        CloseLoot()
    else
        self:UnregisterEvent("LOOT_CLOSED")
    end
end -- Закрываем функцию CheckAutoLootStatus()

function AutoLootPlus:OnLoad()
    self:RegisterEvent("PLAYER_ENTERING_WORLD");
    self:RegisterEvent("LOOT_OPENED");
    self:RegisterEvent("CVAR_UPDATE");
    self:SetScript("OnEvent", function(_, event, ...) 
        AutoLootPlus:OnEvent(event, ...);
    end);
end

AutoLootPlus:OnLoad();