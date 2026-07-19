local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local tool = Instance.new("Tool")
tool.Name = "Bloxy Cola Nuclear"
tool.RequiresHandle = true
tool.CanBeDropped = false

-- Criar a garrafa
local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(0.8, 1.6, 0.8)
handle.BrickColor = BrickColor.new("Bright red")
handle.Material = Enum.Material.SmoothPlastic
handle.TopSurface = Enum.SurfaceType.Smooth
handle.BottomSurface = Enum.SurfaceType.Smooth
handle.Parent = tool

-- Tampa
local cap = Instance.new("Part")
cap.Size = Vector3.new(0.8, 0.2, 0.8)
cap.Position = handle.Position + Vector3.new(0, 1, 0)
cap.BrickColor = BrickColor.new("Light stone grey")
cap.Anchored = false
cap.CanCollide = false
cap.Massless = true
cap.Material = Enum.Material.Metal

local weld = Instance.new("WeldConstraint", handle)
weld.Part0 = handle
weld.Part1 = cap
cap.Parent = tool

-- Animação
local drinkAnim = Instance.new("Animation")
drinkAnim.AnimationId = "rbxassetid://129423131"

-- Som nuclear
local nukeSound = Instance.new("Sound", handle)
nukeSound.SoundId = "rbxassetid://5693336619"
nukeSound.Volume = 2
nukeSound.Name = "NukeSound"

tool.Activated:Connect(function()
    -- Parar animações
    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
        track:Stop()
    end

    -- Tocar animação
    local animTrack = humanoid:LoadAnimation(drinkAnim)
    animTrack:Play()

    animTrack.Stopped:Connect(function()
        nukeSound:Play()
        wait(1.5)

        -- Tela branca
        local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
        gui.IgnoreGuiInset = true
        gui.ResetOnSpawn = false

        local white = Instance.new("Frame", gui)
        white.BackgroundColor3 = Color3.new(1, 1, 1)
        white.Size = UDim2.new(1, 0, 1, 0)
        white.BorderSizePixel = 0

        wait(1)
        white:Destroy()

        -- Criar esfera dentro do jogador
        local sphere = Instance.new("Part")
        sphere.Shape = Enum.PartType.Ball
        sphere.Size = Vector3.new(1, 1, 1)
        sphere.BrickColor = BrickColor.new("Bright orange")
        sphere.Material = Enum.Material.Neon
        sphere.Anchored = true
        sphere.CanCollide = false
        sphere.CFrame = character:WaitForChild("HumanoidRootPart").CFrame
        sphere.Name = "ExplosionSphere"

        -- Partículas
        local particle = Instance.new("ParticleEmitter", sphere)
        particle.Texture = "rbxassetid://243660364"
        particle.Rate = 100
        particle.Speed = NumberRange.new(5)
        particle.Lifetime = NumberRange.new(1)
        particle.Size = NumberSequence.new(2)
        particle.Color = ColorSequence.new(Color3.new(1, 0.5, 0))
        particle.LightEmission = 1

        sphere.Parent = workspace

        -- Tremor de tela para todos
        for _, plr in pairs(Players:GetPlayers()) do
            if plr:FindFirstChild("PlayerGui") then
                local tremorGui = Instance.new("ScreenGui", plr.PlayerGui)
                tremorGui.Name = "TremorGui"
                tremorGui.ResetOnSpawn = false

                local cam = workspace.CurrentCamera
                local timePassed = 0

                local conn
                conn = RunService.RenderStepped:Connect(function(dt)
                    timePassed += dt
                    if timePassed > 3 then
                        conn:Disconnect()
                        tremorGui:Destroy()
                        return
                    end
                    cam.CFrame = cam.CFrame * CFrame.new(
                        math.random(-1,1) * 0.1,
                        math.random(-1,1) * 0.1,
                        math.random(-1,1) * 0.1
                    )
                end)
            end
        end

        -- Aumentar tamanho da esfera e matar quem encostar
        spawn(function()
            local startTime = tick()
            while tick() - startTime < 2 do
                sphere.Size = sphere.Size + Vector3.new(2, 2, 2)
                sphere.CFrame = character.HumanoidRootPart.CFrame
                wait(0.1)
            end
            sphere:Destroy()
        end)

        sphere.Touched:Connect(function(hit)
            local h = hit.Parent:FindFirstChild("Humanoid")
            if h and hit.Parent ~= character then
                h.Health = 0
            end
        end)
    end)
end)

tool.Parent = player:WaitForChild("Backpack")