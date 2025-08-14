-- main.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ShopList = require(script.ShopList)
local Functions = require(script.Functions)
local createGui = require(script.Gui)

local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")
local ShopRemotes = {
    Seeds = GameEvents:FindFirstChild("BuySeedStock") or GameEvents:WaitForChild("BuySeedStock", 5),
    Gears = GameEvents:FindFirstChild("BuyGearStock") or GameEvents:WaitForChild("BuyGearStock", 5),
}

_G.AutoBuyToggles = _G.AutoBuyToggles or {Seeds = false, Gears = false}

Functions.cleanupGui()

local closeGuiFunc = createGui(_G.AutoBuyToggles)
Functions.startAutoBuy(ShopRemotes, ShopList, _G.AutoBuyToggles)

-- Optionally, you can call closeGuiFunc() to programmatically close the GUI from elsewhere.