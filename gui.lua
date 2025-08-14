-- gui.lua
local Players = game:GetService("Players")

return function(togglesTable)
    local player = Players.LocalPlayer
    local pg = player:WaitForChild("PlayerGui")
    local gui = Instance.new("ScreenGui")
    gui.Name = "AutoBuyGui"
    gui.ResetOnSpawn = false
    gui.Parent = pg

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 240, 0, 140)
    frame.Position = UDim2.new(0, 20, 0.4, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local title = Instance.new("TextLabel")
    title.Text = "Auto-Buy Controller"
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 20
    title.Size = UDim2.new(1, 0, 0, 28)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Parent = frame

    -- Close button
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 28, 0, 28)
    close.Position = UDim2.new(1, -32, 0, 4)
    close.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    close.Text = "X"
    close.Font = Enum.Font.SourceSansBold
    close.TextSize = 20
    close.TextColor3 = Color3.fromRGB(255,255,255)
    close.Parent = frame
    close.AutoButtonColor = true

    close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    local i = 1
    for _, cat in ipairs({"Seeds", "Gears"}) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.8, 0, 0, 36)
        btn.Position = UDim2.new(0.1, 0, 0, 36 + (i-1)*42)
        btn.Text = cat .. ": " .. (togglesTable[cat] and "ON" or "OFF")
        btn.BackgroundColor3 = togglesTable[cat] and Color3.fromRGB(0,200,60) or Color3.fromRGB(44,44,44)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 18
        btn.AutoButtonColor = true
        btn.Parent = frame

        btn.MouseButton1Click:Connect(function()
            togglesTable[cat] = not togglesTable[cat]
            btn.Text = cat .. ": " .. (togglesTable[cat] and "ON" or "OFF")
            btn.BackgroundColor3 = togglesTable[cat] and Color3.fromRGB(0,200,60) or Color3.fromRGB(44,44,44)
        end)
        i = i + 1
    end

    -- Return a function for closing from code if needed
    return function()
        if gui and gui.Parent then
            gui:Destroy()
        end
    end
end