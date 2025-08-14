-- gui.lua
return function(shopList, togglesTable, selectedItemsTable)
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local pg = player:WaitForChild("PlayerGui")

    local gui = Instance.new("ScreenGui")
    gui.Name = "AutoBuyGui"
    gui.ResetOnSpawn = false
    gui.Parent = pg

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 340, 0, 360)
    frame.Position = UDim2.new(0, 30, 0.3, 0)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local title = Instance.new("TextLabel")
    title.Text = "Auto-Buy"
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 22
    title.Size = UDim2.new(1, 0, 0, 32)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Parent = frame

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 32, 0, 32)
    close.Position = UDim2.new(1, -36, 0, 4)
    close.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    close.Text = "X"
    close.Font = Enum.Font.SourceSansBold
    close.TextSize = 19
    close.TextColor3 = Color3.fromRGB(255,255,255)
    close.Parent = frame
    close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    local function makeSelector(category, yStart)
        local label = Instance.new("TextLabel")
        label.Text = category
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 18
        label.TextColor3 = Color3.fromRGB(200,200,255)
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 20, 0, yStart)
        label.Size = UDim2.new(0, 120, 0, 22)
        label.Parent = frame

        -- Automation toggle button
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 90, 0, 28)
        toggleBtn.Position = UDim2.new(0, 200, 0, yStart)
        toggleBtn.Text = togglesTable[category] and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = togglesTable[category] and Color3.fromRGB(60,180,60) or Color3.fromRGB(44,44,44)
        toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
        toggleBtn.Font = Enum.Font.SourceSansBold
        toggleBtn.TextSize = 16
        toggleBtn.Parent = frame

        toggleBtn.MouseButton1Click:Connect(function()
            togglesTable[category] = not togglesTable[category]
            toggleBtn.Text = togglesTable[category] and "ON" or "OFF"
            toggleBtn.BackgroundColor3 = togglesTable[category] and Color3.fromRGB(60,180,60) or Color3.fromRGB(44,44,44)
        end)

        -- All selector
        local allBox = Instance.new("TextButton")
        allBox.Size = UDim2.new(0, 60, 0, 24)
        allBox.Position = UDim2.new(0, 20, 0, yStart + 32)
        allBox.Text = "[ ] All"
        allBox.BackgroundColor3 = Color3.fromRGB(44,44,44)
        allBox.TextColor3 = Color3.fromRGB(255,255,255)
        allBox.Font = Enum.Font.SourceSans
        allBox.TextSize = 14
        allBox.Parent = frame

        -- Item selectors
        local itemY = yStart + 62
        local selectors = {}
        local itemTbl = shopList[category]
        for _, item in ipairs(itemTbl) do
            selectedItemsTable[category][item] = false
            local cb = Instance.new("TextButton")
            cb.Size = UDim2.new(0, 120, 0, 22)
            cb.Position = UDim2.new(0, 20, 0, itemY)
            cb.Text = "[ ] " .. item
            cb.BackgroundColor3 = Color3.fromRGB(44,44,44)
            cb.TextColor3 = Color3.fromRGB(255,255,255)
            cb.Font = Enum.Font.SourceSans
            cb.TextSize = 13
            cb.Parent = frame

            cb.MouseButton1Click:Connect(function()
                selectedItemsTable[category][item] = not selectedItemsTable[category][item]
                cb.Text = (selectedItemsTable[category][item] and "[X] " or "[ ] ") .. item
                -- If any are unselected, "All" should turn off
                if selectedItemsTable[category][item] == false then
                    selectedItemsTable[category]["All"] = false
                    allBox.Text = "[ ] All"
                else
                    -- If all selected, "All" should turn on
                    local allSel = true
                    for _, itm in ipairs(itemTbl) do
                        if not selectedItemsTable[category][itm] then allSel = false break end
                    end
                    if allSel then
                        selectedItemsTable[category]["All"] = true
                        allBox.Text = "[X] All"
                    end
                end
            end)
            selectors[item] = cb
            itemY = itemY + 24
        end

        allBox.MouseButton1Click:Connect(function()
            local selectAll = not selectedItemsTable[category]["All"]
            selectedItemsTable[category]["All"] = selectAll
            allBox.Text = selectAll and "[X] All" or "[ ] All"
            for _, item in ipairs(itemTbl) do
                selectedItemsTable[category][item] = selectAll
                selectors[item].Text = (selectAll and "[X] " or "[ ] ") .. item
            end
        end)
    end

    makeSelector("Seeds", 45)
    makeSelector("Gears", 210)
end