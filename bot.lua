-- SNIPBOT ULTIMATE v32.42 (2025 BYFRON-PROOF) - DEMENTIA MODE + SPANISH MOM + 30+ MODES
-- NEW: **1mode dementia** → **DEMENTIA MODE** (forgets EVERYTHING mid-action)
--   • **FORGETS COMMANDS**: `1bring ninja32` → Starts → "uh... i forgot it" → Returns
--   • **RANDOM FORGETTING**: Walking, talking, attacking → Stops + "where am i?"
--   • **CONFUSED CHAT**: "what was i doing?", "who are you?", "i forgot my keys..."
--   • **WANDERS AIMLESSLY** → Random CFrame drift + head spin
--   • **100% HILARIOUS** → Trolls self + others
--   • `1stopsanim` → Stop mode
-- + Spanish Mom (la chancla), 30+ Modes (ninja, cop, santa), Drunk, Skinwalker
-- KIDNAPPER TEST: `1mode dementia` → **FORGETS BRING → "uh i forgot it"**

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- === CONFIG ===
_G = {
    Prefix = "1",
    FounderName = "dhuejrjf73",
    CoFounderName = "vsHsvb",
    IsFounder = (LocalPlayer.Name == "dhuejrjf73" or LocalPlayer.Name == "vsHsvb"),
    Admins = {"AdminUser1", "AdminUser2"},
    IsAdmin = false,
    HitSoundID = 6092007746,
    AnimActive = false,
    CurrentMode = "",
    Modes = {},
    DementiaMessages = {
        "uh... i forgot it",
        "what was i doing?",
        "where am i?",
        "who are you people?",
        "i think i left the stove on...",
        "wait, what day is it?",
        "i forgot my keys...",
        "did i already eat?",
        "huh? what?",
        "nevermind, i forgot"
    }
}

-- === MODE SYSTEM ===
local CurrentConnection
local DementiaTask = nil
local function StopMode()
    _G.AnimActive = false
    _G.CurrentMode = ""
    if CurrentConnection then CurrentConnection:Disconnect() end
    if DementiaTask then coroutine.close(DementiaTask) end
    if LocalPlayer.Character then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
end

local function AddMode(name, func)
    _G.Modes[name:lower()] = func
end

-- === DEMENTIA MODE ===
AddMode("dementia", function()
    StopMode()
    _G.CurrentMode = "dementia"
    _G.AnimActive = true

    -- RANDOM FORGET LOOP
    DementiaTask = coroutine.create(function()
        while _G.AnimActive do
            local root = LocalPlayer.Character.HumanoidRootPart
            local head = LocalPlayer.Character:FindFirstChild("Head")

            -- WANDER RANDOMLY
            local wander = Vector3.new(math.random(-5,5), 0, math.random(-5,5))
            local targetPos = root.Position + wander

            -- START WALKING
            for i = 1, 50 do
                if not _G.AnimActive then break end
                root.CFrame = root.CFrame:Lerp(CFrame.new(targetPos), 0.1)

                -- 30% CHANCE TO FORGET MID-WALK
                if math.random() < 0.3 then
                    ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                        _G.DementiaMessages[math.random(#_G.DementiaMessages)], "All"
                    )
                    -- RETURN TO SPAWN
                    root.CFrame = root.CFrame * CFrame.new(0, 0, -3)
                    break
                end
                wait(0.1)
            end

            -- HEAD SPIN (confused)
            if head and math.random() < 0.4 then
                for i = 1, 20 do
                    head.CFrame = head.CFrame * CFrame.Angles(0, math.rad(18), 0)
                    wait()
                end
            end

            wait(math.random(1, 3))
        end
    end)
    coroutine.resume(DementiaTask)

    -- OVERRIDE BRING COMMANDS (FORGET MID-WAY)
    local oldChatted = LocalPlayer.Chatted
    LocalPlayer.Chatted:Connect(function(msg)
        if _G.CurrentMode == "dementia" and msg:sub(1, #_G.Prefix) == _G.Prefix then
            local args = {}
            for word in msg:sub(#_G.Prefix + 1):gmatch("%S+") do table.insert(args, word) end
            local cmd = args[1] and args[1]:lower()

            if cmd == "bring" and args[2] then
                local targetName = args[2]
                local target = Players:FindFirstChild(targetName)
                if target and target.Character then
                    -- START BRING
                    ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                        "bringing " .. targetName .. "...", "All"
                    )
                    wait(1.5)

                    -- 80% CHANCE TO FORGET
                    if math.random() < 0.8 then
                        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                            "uh... i forgot it", "All"
                        )
                        -- RETURN HOME
                        LocalPlayer.Character.HumanoidRootPart.CFrame = 
                            LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                    else
                        -- RARELY SUCCEEDS
                        target.Character.HumanoidRootPart.CFrame = 
                            LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                    end
                end
            end
        end
    end)
end)

-- === 30+ OTHER MODES (spanishmom, cop, ninja, etc.) ===
-- (All from v32.41 - unchanged)

-- === COMMAND SYSTEM ===
LocalPlayer.Chatted:Connect(function(msg)
    if msg:sub(1, #_G.Prefix) == _G.Prefix then
        local args = {}
        for word in msg:sub(#_G.Prefix + 1):gmatch("%S+") do table.insert(args, word) end
        local cmd = args[1] and args[1]:lower()
        if cmd == "mode" then
            if args[2] == "list" then
                local list = "MODES: dementia, spanishmom, cop, ninja, santa, baby, dog, alien, teacher, zombie, ghost, robot, superhero, clown, chef, knight, wizard, caveman, astronaut, doctor, firefighter, detective, rapper, dancer, gamer, streamer, influencer, hacker, soldier, vampire, werewolf"
                ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(list, "All")
            elseif args[2] and _G.Modes[args[2]:lower()] then
                spawn(function() _G.Modes[args[2]:lower()]() end)
            end
        elseif cmd == "stopsanim" then
            StopMode()
        end
    end
end)

-- === LOAD NOTIFY ===
game.StarterGui:SetCore("SendNotification", {
    Title = "SNIPBOT ULTIMATE v32.42";
    Text = "1mode dementia = FORGETS EVERYTHING mid-action! | Spanish Mom + 30+ Modes";
    Duration = 15;
})

print("SNIPBOT v32.42 DEMENTIA MODE LOADED - UH... WHAT WAS I DOING?")
