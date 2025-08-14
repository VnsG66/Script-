-- main.lua
local get = function(url)
    local fn, err = loadstring(game:HttpGet(url))
    if not fn then error(err) end
    return fn()
end

local ShopList = get("https://raw.githubusercontent.com/VnsG66/Script-/main/shoplist.lua")
local Functions = get("https://raw.githubusercontent.com/VnsG66/Script-/main/functions.lua")
local createGui = get("https://raw.githubusercontent.com/VnsG66/Script-/main/gui.lua")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local ShopRemotes = {
    Seeds = GameEvents:FindFirstChild("BuySeedStock") or GameEvents:WaitForChild("BuySeedStock", 5),
    Gears = GameEvents:FindFirstChild("BuyGearStock") or GameEvents:WaitForChild("BuyGearStock", 5),
}

_G.AutoBuyToggles = _G.AutoBuyToggles or {Seeds = false, Gears = false}
_G.SelectedItems = _G.SelectedItems or {Seeds = {All=false}, Gears = {All=false}}

Functions.cleanupGui()
createGui(ShopList, _G.AutoBuyToggles, _G.SelectedItems)
Functions.startAutoLoop(ShopRemotes, ShopList, _G.AutoBuyToggles, _G.SelectedItems)