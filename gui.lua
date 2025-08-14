return function(shopList, togglesTable, selectedItemsTable)
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local pg = player:WaitForChild("PlayerGui")

    local gui = Instance.new("ScreenGui")
    gui.Name = "AutoBuyGui"
    gui.ResetOnSpawn = false
    gui.Parent = pg

    -- Main frame (draggable)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 370, 0, 170)
    frame.Position = UDim2.new(0, 60, 0.3, 0)
    frame.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui

    -- Title
    local title = Instance.new("TextLabel")
    title.Text = "Auto-Buy"
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 23
    title.Size = UDim2.new(1, -40, 0, 34)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Parent = frame

    -- Close button
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 32, 0, 32)
    close.Position = UDim2.new(1, -36, 0, 2)
    close.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    close.Text = "X"
    close.Font = Enum.Font.SourceSansBold
    close.TextSize = 19
    close.TextColor3 = Color3.fromRGB(255,255,255)
    close.Parent = frame
    close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    -- Helper for dropdown+scroll
    local function makeDropdown(category, yPos)
        -- Automation toggle
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 80, 0, 28)
        toggleBtn.Position = UDim2.new(0, 240, 0, yPos)
        toggleBtn.Text = togglesTable[category] and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = togglesTable[category] and Color3.fromRGB(60,180,60) or Color3.fromRGB(44,44,44)
        toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
        toggleBtn.Font = Enum.Font.SourceSansBold
        toggleBtn.TextSize = 16
        toggleBtn.Parent = frame
        toggleBtn.ZIndex = 2

        toggleBtn.MouseButton1Click:Connect(function()
            togglesTable[category] = not togglesTable[category]
            toggleBtn.Text = togglesTable[category] and "ON" or "OFF"
            toggleBtn.BackgroundColor3 = togglesTable[category] and Color3.fromRGB(60,180,60) or Color3.fromRGB(44,44,44)
        end)

        -- Label
        local label = Instance.new("TextLabel")
        label.Text = category
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 18
        label.TextColor3 = Color3.fromRGB(200,200,255)
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 20, 0, yPos)
        label.Size = UDim2.new(0, 120, 0, 26)
        label.Parent = frame
        label.ZIndex = 2

        -- Dropdown Button
        local dropdownBtn = Instance.new("TextButton")
        dropdownBtn.Size = UDim2.new(0, 170, 0, 28)
        dropdownBtn.Position = UDim2.new(0, 100, 0, yPos)
        dropdownBtn.Text = "▼ Select items..."
        dropdownBtn.BackgroundColor3 = Color3.fromRGB(44,44,44)
        dropdownBtn.TextColor3 = Color3.fromRGB(255,255,255)
        dropdownBtn.Font = Enum.Font.SourceSans
        dropdownBtn.TextSize = 15
        dropdownBtn.AutoButtonColor = true
        dropdownBtn.Parent = frame
        dropdownBtn.ZIndex = 2

        -- Dropdown frame (hidden by default)
        local dropFrame = Instance.new("Frame")
        dropFrame.Size = UDim2.new(0, 200, 0, 180)
        dropFrame.Position = UDim2.new(0, 100, 0, yPos+28)
        dropFrame.BackgroundColor3 = Color3.fromRGB(33,33,45)
        dropFrame.BorderSizePixel = 0
        dropFrame.Visible = false
        dropFrame.Parent = frame
        dropFrame.ZIndex = 14

        -- Scrollable area
        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1, 0, 1, -30)
        scroll.Position = UDim2.new(0, 0, 0, 30)
        scroll.CanvasSize = UDim2.new(0, 0, 0, #shopList[category]*28)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 7
        scroll.Parent = dropFrame
        scroll.ZIndex = 15

        -- "All" checkbox
        local allBox = Instance.new("TextButton")
        allBox.Size = UDim2.new(1, 0, 0, 28)
        allBox.Position = UDim2.new(0, 0, 0, 0)
        allBox.Text = (selectedItemsTable[category]["All"] and "[X] " or "[ ] ") .. "All"
        allBox.BackgroundColor3 = Color3.fromRGB(40,40,60)
        allBox.TextColor3 = Color3.fromRGB(255,255,255)
        allBox.Font = Enum.Font.SourceSansBold
        allBox.TextSize = 15
        allBox.BorderSizePixel = 0
        allBox.Parent = dropFrame
        allBox.ZIndex = 15

        -- Checkbox logic
        local selectors = {}
        for idx, item in ipairs(shopList[category]) do
            selectedItemsTable[category][item] = selectedItemsTable[category][item] or false
            local cb = Instance.new("TextButton")
            cb.Size = UDim2.new(1, 0, 0, 26)
            cb.Position = UDim2.new(0, 0, 0, (idx-1)*28)
            cb.Text = (selectedItemsTable[category][item] and "[X] " or "[ ] ") .. item
            cb.BackgroundColor3 = Color3.fromRGB(44,44,44)
            cb.TextColor3 = Color3.fromRGB(255,255,255)
            cb.Font = Enum.Font.SourceSans
            cb.TextSize = 14
            cb.BorderSizePixel = 0
            cb.Parent = scroll
            cb.ZIndex = 16

            cb.MouseButton1Click:Connect(function()
                selectedItemsTable[category][item] = not selectedItemsTable[category][item]
                cb.Text = (selectedItemsTable[category][item] and "[X] " or "[ ] ") .. item
                -- "All" box logic: If any unchecked, All is off
                local allSel = true
                for _, itm in ipairs(shopList[category]) do
                    if not selectedItemsTable[category][itm] then allSel = false break end
                end
                selectedItemsTable[category]["All"] = allSel
                allBox.Text = (allSel and "[X] " or "[ ] ") .. "All"
            end)
            selectors[item] = cb
        end

        allBox.MouseButton1Click:Connect(function()
            local selectAll = not selectedItemsTable[category]["All"]
            selectedItemsTable[category]["All"] = selectAll
            allBox.Text = (selectAll and "[X] " or "[ ] ") .. "All"
            for _, item in ipairs(shopList[category]) do
                selectedItemsTable[category][item] = selectAll
                selectors[item].Text = (selectAll and "[X] " or "[ ] ") .. item
            end
        end)

        -- Dropdown show/hide logic
        dropdownBtn.MouseButton1Click:Connect(function()
            dropFrame.Visible = not dropFrame.Visible
        end)

        -- Hide dropdown if click outside
        gui.InputBegan:Connect(function(input)
            if dropFrame.Visible and input.UserInputType == Enum.UserInputType.MouseButton1 then
                local mouse = game:GetService("UserInputService"):GetMouseLocation()
                local fPos = frame.AbsolutePosition
                local dPos = dropFrame.AbsolutePosition
                local dSize = dropFrame.AbsoluteSize
                if not (
                    mouse.X >= dPos.X and mouse.X <= dPos.X + dSize.X and
                    mouse.Y >= dPos.Y and mouse.Y <= dPos.Y + dSize.Y
                ) and not (
                    mouse.X >= fPos.X + dropdownBtn.Position.X.Offset and mouse.X <= fPos.X + dropdownBtn.Position.X.Offset + dropdownBtn.Size.X.Offset and
                    mouse.Y >= fPos.Y + dropdownBtn.Position.Y.Offset and mouse.Y <= fPos.Y + dropdownBtn.Position.Y.Offset + dropdownBtn.Size.Y.Offset
                ) then
                    dropFrame.Visible = false
                end
            end
        end)
    end

    makeDropdown("Seeds", 48)
    makeDropdown("Gears", 96)
end