-- Particle Spam Script
-- Executa automaticamente ao rodar

-- Função para criar particle spam em todos os jogadores
local function createParticleSpam()
    for i, v in pairs(game.Players:GetChildren()) do
        if v.Character and v.Character:FindFirstChild("Head") then
            local emit = Instance.new("ParticleEmitter")
            emit.Parent = v.Character.Head
            emit.Texture = "rbxassetid://178993745" -- Formato mais compatível
            emit.VelocitySpread = 1000
            emit.Rate = 500
            emit.Lifetime = NumberRange.new(5, 10)
            emit.Speed = NumberRange.new(5, 15)
            
            -- Configurações adicionais para mais efeito
            emit.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0))
            emit.Size = NumberSequence.new(1, 5)
            emit.Transparency = NumberSequence.new(0, 1)
            
            print("Particle emitter adicionado em: " .. v.Name)
        end
    end
end

-- Executa o particle spam imediatamente
createParticleSpam()

-- GUI opcional para controle
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local SpamButton = Instance.new("TextButton")
local StopButton = Instance.new("TextButton")
local Title = Instance.new("TextLabel")

-- Propriedades da GUI
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "ParticleSpamGUI"

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
Frame.BorderSizePixel = 3
Frame.Position = UDim2.new(0.8, 0, 0.1, 0)
Frame.Size = UDim2.new(0, 180, 0, 120)

Title.Parent = Frame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "c00lkidd particle"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

SpamButton.Parent = Frame
SpamButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpamButton.BorderColor3 = Color3.fromRGB(255, 0, 0)
SpamButton.BorderSizePixel = 2
SpamButton.Position = UDim2.new(0.1, 0, 0.35, 0)
SpamButton.Size = UDim2.new(0.8, 0, 0, 25)
SpamButton.Font = Enum.Font.SourceSans
SpamButton.Text = "SPAM PARTICLES"
SpamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpamButton.TextSize = 14

StopButton.Parent = Frame
StopButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
StopButton.BorderColor3 = Color3.fromRGB(255, 0, 0)
StopButton.BorderSizePixel = 2
StopButton.Position = UDim2.new(0.1, 0, 0.65, 0)
StopButton.Size = UDim2.new(0.8, 0, 0, 25)
StopButton.Font = Enum.Font.SourceSans
StopButton.Text = "STOP PARTICLES"
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.TextSize = 14

-- Função para parar todas as partículas
local function stopAllParticles()
    for i, v in pairs(game.Players:GetChildren()) do
        if v.Character and v.Character:FindFirstChild("Head") then
            for _, emitter in pairs(v.Character.Head:GetChildren()) do
                if emitter:IsA("ParticleEmitter") then
                    emitter:Destroy()
                end
            end
        end
    end
    print("Todas as partículas foram removidas!")
end

-- Conectar botões
SpamButton.MouseButton1Click:Connect(createParticleSpam)
StopButton.MouseButton1Click:Connect(stopAllParticles)

-- Sistema de arrastar a GUI
local function makeDraggable(gui)
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

makeDraggable(Frame)

print("Particle Spam Script carregado! Partículas já foram aplicadas automaticamente.")
print("Use a GUI para controlar as partículas.")