-- functions.lua
local Players = game:GetService("Players")

local M = {}

function M.cleanupGui()
    local player = Players.LocalPlayer
    local pg = player and player:FindFirstChild("PlayerGui")
    if not pg then return end
    local oldGui = pg:FindFirstChild("AutoBuyGui")
    if oldGui then oldGui:Destroy() end
end

function M.fire(remote, itemName)
    if not remote then return false, "nil remote" end
    if remote:IsA("RemoteEvent") then
        local ok, err = pcall(function()
            remote:FireServer(itemName)
        end)
        return ok, err
    elseif remote:IsA("RemoteFunction") then
        local ok, res = pcall(function()
            return remote:InvokeServer(itemName)
        end)
        return ok, res
    else
        return false, "Unsupported remote type: " .. remote.ClassName
    end
end

M.BUY_COUNT = 25
M.MIN_STEP_DELAY = 0

function M.startAutoBuy(ShopRemotes, ShopList, togglesTable)
    for _, category in ipairs({"Seeds", "Gears"}) do
        local itemList = ShopList[category]
        local remote = ShopRemotes[category]
        if remote == nil or not (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
            warn("[Skip] No valid remote for category: " .. tostring(category))
            continue
        end
        if type(itemList) ~= "table" then
            warn("[Skip] Item list for " .. tostring(category) .. " is not a table")
            continue
        end

        task.spawn(function()
            while true do
                while not (togglesTable and togglesTable[category]) do
                    task.wait(0.2)
                end
                for _, itemName in ipairs(itemList) do
                    task.spawn(function()
                        for i = 1, M.BUY_COUNT do
                            if not (togglesTable and togglesTable[category]) then
                                break
                            end
                            local ok, err = M.fire(remote, itemName)
                            if not ok then
                                warn("[Fail] " .. category .. " -> " .. tostring(itemName) .. " (" .. tostring(i) .. "): " .. tostring(err))
                            end
                            if M.MIN_STEP_DELAY > 0 then
                                task.wait(M.MIN_STEP_DELAY)
                            else
                                task.wait()
                            end
                        end
                    end)
                end
                task.wait(0.5)
            end
        end)
    end
end

return M