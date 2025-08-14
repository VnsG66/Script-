return function(shopList, togglesTable, selectedItemsTable)
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local pg = player:WaitForChild("PlayerGui")
    local UIS = game:GetService("UserInputService")

    local gui = Instance.new("ScreenGui")
    gui.Name = "Germa66Gui"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = pg

    -- Main frame (draggable, modernized, taller)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 430, 0, 420)
    frame.Position = UDim2.new(0, 80, 0.33, 0)
    frame.BackgroundColor3 = Color3.fromRGB(38, 40, 54)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui

    -- Rounded corners and shadow
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 16)
    local shadow = Instance.new("ImageLabel", frame)
    shadow.Image = "rbxassetid://1316045217"
    shadow.Size = UDim2.new(1,26,1,26)
    shadow.Position = UDim2.new(0,-13,0,-13)
    shadow.ImageTransparency = 0.80
    shadow.BackgroundTransparency = 1
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10,10,118,118)
    shadow.ZIndex = 0

    -- Title
    local title = Instance.new("TextLabel")
    title.Text = "Germa66"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 32
    title.Size = UDim2.new(1, -56, 0, 52)
    title.Position = UDim2.new(0, 22, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(207, 225, 255)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 2
    title.Parent = frame

    -- Close button (modern)
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 40, 0, 40)
    close.Position = UDim2.new(1, -46, 0, 8)
    close.BackgroundColor3 = Color3.fromRGB(55, 60, 70)
    close.Text = "✕"
    close.Font = Enum.Font.GothamBold
    close.TextSize = 22
    close.TextColor3 = Color3.fromRGB(255,255,255)
    close.AutoButtonColor = false
    close.ZIndex = 3
    close.Parent = frame
    local closeCorner = Instance.new("UICorner", close)
    closeCorner.CornerRadius = UDim.new(0, 12)
    close.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)
    close.MouseEnter:Connect(function() close.BackgroundColor3 = Color3.fromRGB(220,70,70) end)
    close.MouseLeave:Connect(function() close.BackgroundColor3 = Color3.fromRGB(55,60,70) end)

    -- Helper for dropdown+scroll (modernized)
    local function makeDropdown(category, yPos)
        -- Automation toggle
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 90, 0, 38)
        toggleBtn.Position = UDim2.new(0, 310, 0, yPos)
        toggleBtn.Text = togglesTable[category] and "● ON" or "○ OFF"
        toggleBtn.BackgroundColor3 = togglesTable[category] and Color3.fromRGB(60,200,140) or Color3.fromRGB(49, 49, 62)
        toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
        toggleBtn.Font = Enum.Font.GothamSemibold
        toggleBtn.TextSize = 18
        toggleBtn.ZIndex = 2
        toggleBtn.AutoButtonColor = false
        toggleBtn.Parent = frame
        local toggleCorner = Instance.new("UICorner", toggleBtn)
        toggleCorner.CornerRadius = UDim.new(0, 10)
        toggleBtn.MouseButton1Click:Connect(function()
            togglesTable[category] = not togglesTable[category]
            toggleBtn.Text = togglesTable[category] and "● ON" or "○ OFF"
            toggleBtn.BackgroundColor3 = togglesTable[category] and Color3.fromRGB(60,200,140) or Color3.fromRGB(49,49,62)
        end)
        toggleBtn.MouseEnter:Connect(function()
            if togglesTable[category] then
                toggleBtn.BackgroundColor3 = Color3.fromRGB(44,230,170)
            else
                toggleBtn.BackgroundColor3 = Color3.fromRGB(59,59,80)
            end
        end)
        toggleBtn.MouseLeave:Connect(function()
            toggleBtn.BackgroundColor3 = togglesTable[category] and Color3.fromRGB(60,200,140) or Color3.fromRGB(49,49,62)
        end)

        -- Label
        local label = Instance.new("TextLabel")
        label.Text = category
        label.Font = Enum.Font.GothamSemibold
        label.TextSize = 20
        label.TextColor3 = Color3.fromRGB(180,210,255)
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 22, 0, yPos)
        label.Size = UDim2.new(0, 110, 0, 38)
        label.ZIndex = 2
        label.Parent = frame

        -- Dropdown Button
        local dropdownBtn = Instance.new("TextButton")
        dropdownBtn.Size = UDim2.new(0, 180, 0, 38)
        dropdownBtn.Position = UDim2.new(0, 125, 0, yPos)
        dropdownBtn.Text = "▼ Select items..."
        dropdownBtn.BackgroundColor3 = Color3.fromRGB(58,58,75)
        dropdownBtn.TextColor3 = Color3.fromRGB(225,235,255)
        dropdownBtn.Font = Enum.Font.Gotham
        dropdownBtn.TextSize = 16
        dropdownBtn.AutoButtonColor = false
        dropdownBtn.ZIndex = 2
        dropdownBtn.Parent = frame
        local btnCorner = Instance.new("UICorner", dropdownBtn)
        btnCorner.CornerRadius = UDim.new(0, 10)

        dropdownBtn.MouseEnter:Connect(function()
            dropdownBtn.BackgroundColor3 = Color3.fromRGB(80,80,110)
        end)
        dropdownBtn.MouseLeave:Connect(function()
            dropdownBtn.BackgroundColor3 = Color3.fromRGB(58,58,75)
        end)

        -- Dropdown frame (hidden by default)
        local dropFrame = Instance.new("Frame")
        dropFrame.Size = UDim2.new(0, 230, 0, 220)
        dropFrame.Position = UDim2.new(0, 125, 0, yPos + 38)
        dropFrame.BackgroundColor3 = Color3.fromRGB(44, 46, 65)
        dropFrame.BorderSizePixel = 0
        dropFrame.Visible = false
        dropFrame.ZIndex = 14
        dropFrame.Parent = frame
        local dropCorner = Instance.new("UICorner", dropFrame)
        dropCorner.CornerRadius = UDim.new(0, 12)
        local dropBorder = Instance.new("Frame", dropFrame)
        dropBorder.BackgroundColor3 = Color3.fromRGB(65, 90, 130)
        dropBorder.Size = UDim2.new(1, 0, 0, 2)
        dropBorder.Position = UDim2.new(0,0,0,0)
        dropBorder.BorderSizePixel = 0
        dropBorder.ZIndex = 15

        -- Scrollable area
        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1, 0, 1, -38)
        scroll.Position = UDim2.new(0, 0, 0, 38)
        scroll.CanvasSize = UDim2.new(0, 0, 0, #shopList[category]*36)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 7
        scroll.ZIndex = 15
        scroll.Parent = dropFrame

        -- "All" checkbox
        local allBox = Instance.new("TextButton")
        allBox.Size = UDim2.new(1, 0, 0, 38)
        allBox.Position = UDim2.new(0, 0, 0, 0)
        allBox.Text = (selectedItemsTable[category]["All"] and "✓ " or "☐ ") .. "All"
        allBox.BackgroundColor3 = Color3.fromRGB(53,70,110)
        allBox.TextColor3 = Color3.fromRGB(210,225,255)
        allBox.Font = Enum.Font.GothamSemibold
        allBox.TextSize = 17
        allBox.BorderSizePixel = 0
        allBox.ZIndex = 16
        allBox.Parent = dropFrame
        local allCorner = Instance.new("UICorner", allBox)
        allCorner.CornerRadius = UDim.new(0,9)

        allBox.MouseEnter:Connect(function() allBox.BackgroundColor3 = Color3.fromRGB(75,100,150) end)
        allBox.MouseLeave:Connect(function() allBox.BackgroundColor3 = Color3.fromRGB(53,70,110) end)

        -- Checkbox logic
        local selectors = {}
        for idx, item in ipairs(shopList[category]) do
            selectedItemsTable[category][item] = selectedItemsTable[category][item] or false
            local cb = Instance.new("TextButton")
            cb.Size = UDim2.new(1, -12, 0, 32)
            cb.Position = UDim2.new(0, 6, 0, (idx-1)*36)
            cb.Text = (selectedItemsTable[category][item] and "✓ " or "☐ ") .. item
            cb.BackgroundColor3 = Color3.fromRGB(62, 68, 99)
            cb.TextColor3 = Color3.fromRGB(220,230,255)
            cb.Font = Enum.Font.Gotham
            cb.TextSize = 15
            cb.BorderSizePixel = 0
            cb.Parent = scroll
            cb.ZIndex = 16
            local cbCorner = Instance.new("UICorner", cb)
            cbCorner.CornerRadius = UDim.new(0,8)

            cb.MouseEnter:Connect(function() cb.BackgroundColor3 = Color3.fromRGB(84,94,130) end)
            cb.MouseLeave:Connect(function() cb.BackgroundColor3 = Color3.fromRGB(62,68,99) end)

            cb.MouseButton1Click:Connect(function()
                selectedItemsTable[category][item] = not selectedItemsTable[category][item]
                cb.Text = (selectedItemsTable[category][item] and "✓ " or "☐ ") .. item
                -- "All" box logic: If any unchecked, All is off
                local allSel = true
                for _, itm in ipairs(shopList[category]) do
                    if not selectedItemsTable[category][itm] then allSel = false break end
                end
                selectedItemsTable[category]["All"] = allSel
                allBox.Text = (allSel and "✓ " or "☐ ") .. "All"
            end)
            selectors[item] = cb
        end

        allBox.MouseButton1Click:Connect(function()
            local selectAll = not selectedItemsTable[category]["All"]
            selectedItemsTable[category]["All"] = selectAll
            allBox.Text = (selectAll and "✓ " or "☐ ") .. "All"
            for _, item in ipairs(shopList[category]) do
                selectedItemsTable[category][item] = selectAll
                selectors[item].Text = (selectAll and "✓ " or "☐ ") .. item
            end
        end)

        -- Dropdown show/hide logic
        dropdownBtn.MouseButton1Click:Connect(function()
            dropFrame.Visible = not dropFrame.Visible
        end)

        -- Hide dropdown if click outside (fix: use UIS.InputBegan, not gui.InputBegan)
        UIS.InputBegan:Connect(function(input)
            if dropFrame.Visible and input.UserInputType == Enum.UserInputType.MouseButton1 then
                local mouse = UIS:GetMouseLocation()
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

    -- Seeds at y=80, Gears at y=210
    makeDropdown("Seeds", 80)
    makeDropdown("Gears", 210)
end