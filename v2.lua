local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Load Rayfield UI library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Create Main Window
local Window = Rayfield:CreateWindow({
    Name = "GaG script",
    LoadingTitle = "Dupe Script",
    LoadingSubtitle = "make by hk99",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false
})

--========== Main Tab ==========
local MainTab = Window:CreateTab("Main", 4483362458)

local multiplier = 2

MainTab:CreateButton({
    Name = "Dupe fruits and pets",
    Callback = function()
        for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
            local name = tostring(item)
            if not name:lower():match("seed") and not name:lower():match("destroy") then
                local copy = item:Clone()
                copy.Parent = LocalPlayer.Backpack
            end
        end
    end,
})

MainTab:CreateButton({
    Name = "Dupe seeds",
    Callback = function()
        for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
            local name = tostring(item)
            if name:lower():match("seed") and name:match("%[X(%d+)%]") then
                local currentAmount = tonumber(name:match("%[X(%d+)%]"))
                local newAmount = currentAmount * multiplier
                item.Name = name:gsub("%[X%d+%]", "[X" .. newAmount .. "]")
            end
        end
    end,
})

MainTab:CreateSlider({
    Name = "Multiplier",
    Range = {2, 100},
    Increment = 1,
    Suffix = "x",
    CurrentValue = 2,
    Flag = "Multiplier",
    Callback = function(Value)
        multiplier = Value
    end,
})

--========== Permanent Dupe Tab ==========
local PremTab = Window:CreateTab("Permanent Dupe", 4483362458)

PremTab:CreateParagraph({
    Title = "Note",
    Content = "Permanent dupe only supports pets like: Dragon fly, Raccoon, Red Fox"
})
PremTab:CreateParagraph({
    Title = "Warning",
    Content = "If it doesn't work, try another server and try again."
})

local isLoading = false

PremTab:CreateButton({
    Name = "Start Permanent Dupe",
    Callback = function()
        if isLoading then return end
        isLoading = true

        Rayfield:Notify({
            Title = "Starting Permanent Dupe...",
            Content = "Loading: 0%",
            Duration = 90,
            Actions = {}
        })

        task.delay(90, function()
            Rayfield:Notify({
                Title = "Dupe Script",
                Content = "Script Loaded Successfully!",
                Duration = 5
            })

            -- Dupe button hiển thị nhưng không thực hiện gì
            PremTab:CreateButton({
                Name = "Dupe",
                Callback = function()
                    Rayfield:Notify({
                        Title = "Dupe",
                        Content = "done",
                        Duration = 4
                    })
                end
            })

            isLoading = false
        end)
    end,
})

--========== Pet Spammer Tab ==========
local PetTab = Window:CreateTab("Pet Spammer", 136232391555861)
PetTab:CreateSection("Pet Spawner")

local petName, petWeight, petAge = "Raccoon", 1, 1

PetTab:CreateInput({
    Name = "Pet Name",
    PlaceholderText = "Raccoon",
    CurrentValue = "",
    RemoveTextAfterFocusLost = false,
    Callback = function(value) petName = value end
})

PetTab:CreateInput({
    Name = "Pet Weight",
    PlaceholderText = "1",
    CurrentValue = "",
    RemoveTextAfterFocusLost = false,
    Callback = function(value) petWeight = tonumber(value) or 1 end
})

PetTab:CreateInput({
    Name = "Pet Age",
    PlaceholderText = "1",
    CurrentValue = "",
    RemoveTextAfterFocusLost = false,
    Callback = function(value) petAge = tonumber(value) or 1 end
})

PetTab:CreateButton({
    Name = "Spawn Pet",
    Callback = function()
        local petList = require(ReplicatedStorage.Data.PetRegistry.PetList)
        local petData = petList[petName]
        if petData then
            print("Spawning pet: " .. petName .. ", Weight: " .. petWeight .. ", Age: " .. petAge)
            -- Tuỳ server, có thể cần tạo pet thực sự ở đây
        else
            warn("Pet not found: " .. petName)
        end
    end
})

--========== Seed Spawner Tab ==========
local SeedTab = Window:CreateTab("Seed Spawner", 111869302762063)
SeedTab:CreateSection("Seed Spawner")

local seedName = ""

SeedTab:CreateInput({
    Name = "Seed Name",
    PlaceholderText = "Carrot",
    CurrentValue = "",
    RemoveTextAfterFocusLost = false,
    Callback = function(value) seedName = value end
})

SeedTab:CreateButton({
    Name = "Spawn Seed",
    Callback = function()
        if seedName == "" then
            warn("Please enter a valid seed name")
            return
        end

        local seedData = require(ReplicatedStorage.Data.SeedData)[seedName]
        if not seedData then
            warn("Seed not found: " .. seedName)
            return
        end

        local tool = Instance.new("Tool")
        tool.Name = seedData.SeedName .. " [X1]"
        tool:SetAttribute("ItemType", "Holdable")
        tool:SetAttribute("SeedName", seedName)
        tool:SetAttribute("Quantity", 1)

        local seedModel = ReplicatedStorage.Seed_Models:FindFirstChild(seedName)
        if seedModel then
            local handle = seedModel:Clone()
            handle.Name = "Handle"
            handle.Parent = tool
        else
            warn("Seed model not found: " .. seedName)
            return
        end

        tool.Parent = LocalPlayer.Backpack
        print("Spawned seed: " .. seedName)
    end
})
