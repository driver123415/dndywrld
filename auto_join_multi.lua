-- ==================== AntiCheat Removal (TOP) ====================
pcall(function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local events = ReplicatedStorage:WaitForChild("Events", 5)
    if events then
        local antiCheat = events:FindFirstChild("AntiCheatTrigger")
        if antiCheat then
            antiCheat:Destroy()
        end
    end
end)

-- ==================== Services ====================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ==================== State ====================
local running = true
local savedCFrame = nil

-- ==================== STOP IF CurrentRoom EXISTS ====================
if workspace:FindFirstChild("CurrentRoom") then
    return
end

-- ==================== Get HumanoidRootPart ====================
local function getHRP()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

-- ==================== Check leaveButton ====================
local function leaveButtonExists()
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if not gui then return false end

    local mainGui = gui:FindFirstChild("MainGui")
    if not mainGui then return false end

    return mainGui:FindFirstChild("leaveButton") ~= nil
end

-- ==================== Main Logic ====================
task.spawn(function()
    local hrp = getHRP()
    local gate = workspace
        :WaitForChild("Elevators")
        :WaitForChild("Gate")
        :WaitForChild("Gate")

    savedCFrame = hrp.CFrame

    while running do
        -- Stop if CurrentRoom appears
        if workspace:FindFirstChild("CurrentRoom") then
            running = false
            break
        end

        -- Teleport to elevator
        hrp.CFrame = gate.CFrame

        -- Wait 10 seconds
        task.wait(10)

        -- If leaveButton appears → eksekusi logic baru
        if leaveButtonExists() then
            print("Berhasil masuk antrean (Gate). Menunggu 1 detik untuk Vote...")
            
            -- Tunggu 1 detik sesuai permintaanmu
            task.wait(1)
            
            -- Menjalankan script tambahan (VoteMatch) dengan aman menggunakan pcall
            pcall(function()
                local args = { "VoteMatch" }
                local remoteEvent = game:GetService("ReplicatedStorage"):WaitForChild("SharedUtils"):WaitForChild("Network"):WaitForChild("RemoteEvent")
                
                -- Harus menggunakan :FireServer() agar perintah dikirim ke server game
                remoteEvent:FireServer(unpack(args))
            end)
            print("VoteMatch berhasil dieksekusi!")

            -- Melanjutkan sisa logic utama (kembali ke posisi awal dan hentikan loop)
            hrp.CFrame = savedCFrame
            running = false
            break
        end
    end
end)
