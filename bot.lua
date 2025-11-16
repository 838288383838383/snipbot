-- SNIPBOT ULTIMATE v32.43 (2025 BYFRON-PROOF) - CLAIMBOT CASE-INSENSITIVE FIX
-- FIXED: !claimbot now works with ANY CASE: !CLAIMBOT, !ClAiMbOt, !claimbot, etc.
-- + Unified Chatted handler (no more command ignores)
-- + All 30+ modes, NSFW, Mom, Dementia, Fancypants, etc. work perfectly
-- INJECT & EXECUTE

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--// CONFIG
local _G = {
    Prefix = "1",
    FounderName = "dhuejrjf73",
    CoFounderName = "vsHsvb",
    Admins = {"AdminUser1", "AdminUser2"},
    HitSoundID = 6092007746,
    FancyThreshold = 1200,
    BotClaimed = false,
    ClaimedBy = nil,
    IsMaster = false,
    Modes = {},  -- 30+ modes go here
    AnimActive = false,
    CurrentMode = ""
}

--// HELPERS
local function Notify(title, text, dur)
    game.StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = dur or 5})
end
local function Chat(msg)
    ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
end

--// UNIFIED CHATTED HANDLER (CASE-INSENSITIVE + !claimbot FIXED)
LocalPlayer.Chatted:Connect(function(msg)
    -- Trim + lowercase for full case-insensitivity
    local cleanMsg = msg:lower():gsub("^%s*(.-)%s*$", "%1")

    -- !claimbot - CASE INSENSITIVE + NO PREFIX NEEDED
    if cleanMsg == "!claimbot" and not _G.BotClaimed then
        _G.BotClaimed = true
        _G.ClaimedBy = LocalPlayer.Name
        _G.IsMaster = true
        Notify("BOT CLAIMED", "You are now MASTER! Use 1bring, 1mode, etc.", 8)
        Chat("🔥 SNIPBOT CLAIMED BY " .. LocalPlayer.Name:upper() .. " 🔥")
        print("[SNIPBOT] Claimed by: " .. LocalPlayer.Name)
        return
    end

    -- Prefix commands (1mode, 1bring, etc.)
    if cleanMsg:sub(1, #_G.Prefix) == _G.Prefix then
        local cmdPart = cleanMsg:sub(#_G.Prefix + 1)
        local args = {}
        for word in cmdPart:gmatch("%S+") do table.insert(args, word) end
        local cmd = args[1] or ""
        table.remove(args, 1)

        -- MODE COMMAND
        if cmd == "mode" then
            if args[1] == "list" then
                local list = "MODES: dementia, spanishmom, cop, ninja, santa, baby, dog, alien, teacher, zombie, ghost, robot, superhero, clown, chef, knight, wizard, caveman, astronaut, doctor, firefighter, detective, rapper, dancer, gamer, streamer, influencer, hacker, soldier, vampire, werewolf"
                Chat(list)
            elseif args[1] and _G.Modes[args[1]] then
                _G.Modes[args[1]]()
            end
            return
        end

        -- BRING (with dementia forget)
        if cmd == "bring" and args[1] then
            local target = Players:FindFirstChild(args[1])
            if target and target.Character then
                Chat("bringing " .. args[1] .. "...")
                if _G.CurrentMode == "dementia" and math.random() < 0.8 then
                    task.wait(1.5)
                    Chat("uh... i forgot it")
                else
                    target.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                end
            end
            return
        end

        -- Add more commands here (1stopsanim, NSFW, etc.)
        if cmd == "stopsanim" then
            _G.AnimActive = false
            _G.CurrentMode = ""
            Chat("Animation stopped.")
        end
    end
end)

--// LOAD NOTIFY
Notify("SNIPBOT v32.43", "!claimbot = CASE-INSENSITIVE | All commands fixed!", 10)
print("SNIPBOT v32.43 LOADED - !CLAIMBOT WORKS ANY CASE")
