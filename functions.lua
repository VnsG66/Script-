-- functions.lua

local M = {}

function M.cleanupGui()
    local player = game:GetService("Players").LocalPlayer
    local pg = player and player:FindFirstChild("PlayerGui")
    if not pg then return end
    local oldGui = pg:FindFirstChild("AutoBuyGui")
    if oldGui then oldGui:Destroy() end
end

function M.buyItems(remote, items)
    for _, itemName in ipairs(items) do
        local ok, err
        if remote:IsA("RemoteEvent") then
            ok, err = pcall(function() remote:FireServer(itemName) end)
        else
            ok, err = pcall(function() remote:InvokeServer(itemName) end)
        end
        if not ok then warn("Failed to buy", itemName, ":", err) end
        task.wait(0.05)
    end
end

function M.startAutoLoop(ShopRemotes, ShopList, togglesTable, selectedItemsTable)
    for _, category in ipairs({"Seeds", "Gears"}) do
        task.spawn(function()
            while true do
                while not togglesTable[category] do
                    task.wait(0.2)
                end
                local remote = ShopRemotes[category]
                local buyList = {}
                for _, item in ipairs(ShopList[category]) do
                    if selectedItemsTable[category]["All"] or selectedItemsTable[category][item] then
                        table.insert(buyList, item)
                    end
                end
                if #buyList > 0 then
                    M.buyItems(remote, buyList)
                end
                task.wait(1) -- repeat every second, adjust as needed
            end
        end)
    end
end

return M