-- main.lua

local get = function(url)
    local fn, err = loadstring(game:HttpGet(url))
    if not fn then error(err) end
    return fn()
end

-- Raw URLs for your modules (make sure these are correct and public)
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

Functions.cleanupGui()

local closeGuiFunc = createGui(_G.AutoBuyToggles)
Functions.startAutoBuy(ShopRemotes, ShopList, _G.AutoBuyToggles)

-- Optionally: You can call closeGuiFunc() to close the GUI via script later if needed