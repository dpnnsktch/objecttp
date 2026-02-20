--[[
   by: sm0cutor
]]

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ScanWorldBtn = Instance.new("TextButton")
local TpToPoint = Instance.new("TextButton")
local TpForwardBtn = Instance.new("TextButton")
local Status = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local MinimizeBtn = Instance.new("TextButton")
local PointList = Instance.new("ScrollingFrame")
local ListLayout = Instance.new("UIListLayout")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "Object TP"


MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
MainFrame.Size = UDim2.new(0, 400, 0, 350)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -175)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)


Title.Parent = MainFrame
Title.Size = UDim2.new(1, -60, 0, 35)
Title.Text = "Object TP"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 5, 0, 0)


MinimizeBtn.Parent = MainFrame
MinimizeBtn.Size = UDim2.new(0, 35, 0, 35)
MinimizeBtn.Position = UDim2.new(1, -70, 0, 0)
MinimizeBtn.Text = "—"
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.SourceSansBold
MinimizeBtn.TextSize = 25

CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.Text = "✕"
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 20


ScanWorldBtn.Parent = MainFrame
ScanWorldBtn.Size = UDim2.new(0.45, -5, 0, 40)
ScanWorldBtn.Position = UDim2.new(0.025, 0, 0.15, 0)
ScanWorldBtn.Text = "SCAN"
ScanWorldBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ScanWorldBtn.TextColor3 = Color3.fromRGB(100, 200, 255)
ScanWorldBtn.Font = Enum.Font.SourceSansBold
ScanWorldBtn.TextSize = 16

TpForwardBtn.Parent = MainFrame
TpForwardBtn.Size = UDim2.new(0.45, -5, 0, 40)
TpForwardBtn.Position = UDim2.new(0.525, 0, 0.15, 0)
TpForwardBtn.Text = "TP Next (50m)"
TpForwardBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 30)
TpForwardBtn.TextColor3 = Color3.fromRGB(255, 150, 150)
TpForwardBtn.Font = Enum.Font.SourceSansBold
TpForwardBtn.TextSize = 16


TpToPoint.Parent = MainFrame
TpToPoint.Size = UDim2.new(0.95, 0, 0, 45)
TpToPoint.Position = UDim2.new(0.025, 0, 0.25, 0)
TpToPoint.Text = "LET'S GO!"
TpToPoint.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
TpToPoint.TextColor3 = Color3.fromRGB(255, 255, 255)
TpToPoint.Font = Enum.Font.SourceSansBold
TpToPoint.TextSize = 18


PointList.Parent = MainFrame
PointList.Size = UDim2.new(0.95, 0, 0, 150)
PointList.Position = UDim2.new(0.025, 0, 0.4, 0)
PointList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
PointList.BorderSizePixel = 1
PointList.BorderColor3 = Color3.fromRGB(255, 0, 0)
PointList.ScrollBarThickness = 8
PointList.CanvasSize = UDim2.new(0, 0, 0, 0)

ListLayout.Parent = PointList
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 2)


Status.Parent = MainFrame
Status.Size = UDim2.new(0.95, 0, 0, 30)
Status.Position = UDim2.new(0.025, 0, 0.9, 0)
Status.Text = "Ready to scan"
Status.TextColor3 = Color3.fromRGB(0, 255, 0)
Status.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Status.Font = Enum.Font.SourceSans
Status.TextSize = 14


local worldPoints = {}
local selectedPoint = nil
local currentPage = 0


local function teleport(pos, desc)
    local player = game.Players.LocalPlayer
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos)
        Status.Text = "ТЕЛЕПОРТ: " .. (desc or "В ТОЧКУ")
        Status.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        
        local effect = Instance.new("Part")
        effect.Parent = workspace
        effect.Size = Vector3.new(3, 3, 3)
        effect.Position = pos
        effect.BrickColor = BrickColor.new("Really red")
        effect.Anchored = true
        effect.CanCollide = false
        effect.Material = Enum.Material.Neon
        game:GetService("Debris"):AddItem(effect, 1.5)
    end
end


local function scanWholeWorld()
    Status.Text = "Scan Objects.."
    Status.TextColor3 = Color3.fromRGB(255, 255, 0)
    
    worldPoints = {}
    
    
    for _, child in ipairs(PointList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local player = game.Players.LocalPlayer
    local char = player.Character
    local startPos = char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.Position or Vector3.new(0, 0, 0)
    
 
    local totalParts = 0
    local processed = 0
    
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsA("Terrain") then
            totalParts = totalParts + 1
        end
    end
    
    Status.Text = "Objects: " .. totalParts
    
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsA("Terrain") then
            processed = processed + 1
            
            
            if processed % 500 == 0 then
                Status.Text = "Scan..: " .. math.floor((processed/totalParts)*100) .. "% (" .. processed .. "/" .. totalParts .. ")"
                wait()
            end
            
            
            if obj.Size.Magnitude > 5 then
                
                table.insert(worldPoints, {
                    pos = obj.Position,
                    name = "🏢 " .. obj.Name,
                    size = obj.Size,
                    type = "structure"
                })
            elseif obj:IsA("TrussPart") or obj.Name:lower():find("ladder") then
               
                table.insert(worldPoints, {
                    pos = obj.Position,
                    name = "🪜 " .. obj.Name,
                    size = obj.Size,
                    type = "climbable"
                })
            elseif obj.BrickColor == BrickColor.new("Bright green") or obj.BrickColor == BrickColor.new("Bright red") then
                
                table.insert(worldPoints, {
                    pos = obj.Position,
                    name = "🎯 " .. obj.Name,
                    size = obj.Size,
                    type = "objective"
                })
            end
            
            
            local rayUp = Ray.new(obj.Position + Vector3.new(0, 10, 0), Vector3.new(0, -20, 0))
            local hit, hitPos = workspace:FindPartOnRay(rayUp, obj)
            
            if hit and hit ~= obj then
                table.insert(worldPoints, {
                    pos = hitPos + Vector3.new(0, 3, 0),
                    name = "Surface " .. hit.Name,
                    size = hit.Size,
                    type = "surface"
                })
            end
        end
    end
    
    
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(worldPoints, {
                pos = plr.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0),
                name = "Player: " .. plr.Name,
                size = Vector3.new(2, 2, 2),
                type = "player"
            })
        end
    end
    
    
    local uniquePoints = {}
    for _, point in ipairs(worldPoints) do
        local isDuplicate = false
        for _, up in ipairs(uniquePoints) do
            if (up.pos - point.pos).Magnitude < 5 then
                isDuplicate = true
                break
            end
        end
        if not isDuplicate then
            table.insert(uniquePoints, point)
        end
    end
    
    worldPoints = uniquePoints
    
    
    table.sort(worldPoints, function(a, b)
        return (a.pos - startPos).Magnitude < (b.pos - startPos).Magnitude
    end)
    
    
    for i, point in ipairs(worldPoints) do
        local dist = math.floor((point.pos - startPos).Magnitude)
        local btn = Instance.new("TextButton")
        btn.Parent = PointList
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.BackgroundColor3 = i % 2 == 0 and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(40, 40, 40)
        btn.Text = point.name .. " [" .. dist .. "m]"
        btn.TextColor3 = Color3.fromRGB(200, 200, 255)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 14
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BorderSizePixel = 0
        
        
        btn.MouseButton1Click:Connect(function()
            selectedPoint = point
            Status.Text = "YSYYS: " .. point.name .. " (кликни ТЕЛЕПОРТ)"
            Status.TextColor3 = Color3.fromRGB(255, 255, 0)
            
            
            for _, b in ipairs(PointList:GetChildren()) do
                if b:IsA("TextButton") then
                    b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                end
            end
            btn.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
        end)
        
        
        if point.type == "structure" then
            btn.TextColor3 = Color3.fromRGB(150, 150, 255)
        elseif point.type == "objective" then
            btn.TextColor3 = Color3.fromRGB(255, 255, 100)
        elseif point.type == "player" then
            btn.TextColor3 = Color3.fromRGB(100, 255, 100)
        end
    end
    
   
    PointList.CanvasSize = UDim2.new(0, 0, 0, #worldPoints * 32)
    
    Status.Text = "Find: " .. #worldPoints .. " (All objects)"
    Status.TextColor3 = Color3.fromRGB(0, 255, 0)
end


local function teleportForward()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local forward = hrp.CFrame.LookVector * 50
    local newPos = hrp.Position + forward
    
    
    local ray = Ray.new(newPos + Vector3.new(0, 5, 0), Vector3.new(0, -10, 0))
    local hit, groundPos = workspace:FindPartOnRay(ray, char)
    
    if hit then
        teleport(groundPos + Vector3.new(0, 3, 0), "ВПЕРЕД 50м")
    else
        teleport(newPos, "ВПЕРЕД 50м (ВОЗДУХ)")
    end
end


ScanWorldBtn.MouseButton1Click:Connect(scanWholeWorld)

TpForwardBtn.MouseButton1Click:Connect(teleportForward)

TpToPoint.MouseButton1Click:Connect(function()
    if selectedPoint then
        teleport(selectedPoint.pos, selectedPoint.name)
    else
        Status.Text = "You haven't chosen a point."
        Status.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)


local minimized = false
local originalSize = MainFrame.Size

local function toggleMinimize()
    minimized = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0, 200, 0, 35)
        ScanWorldBtn.Visible = false
        TpForwardBtn.Visible = false
        TpToPoint.Visible = false
        PointList.Visible = false
        Status.Visible = false
        Title.Text = "Object TP"
    else
        MainFrame.Size = originalSize
        ScanWorldBtn.Visible = true
        TpForwardBtn.Visible = true
        TpToPoint.Visible = true
        PointList.Visible = true
        Status.Visible = true
        Title.Text = "Object TP"
    end
end

MinimizeBtn.MouseButton1Click:Connect(toggleMinimize)

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.K then
        toggleMinimize()
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("=================================")
print("Object TP:")
print("=================================")
print("Version: 1.0")
print("By: sm0cutor")
print("TGK: @sm0cutor")
print("heh:)")
print("=================================")
print("Use k to show")
print("=================================")
