-- FXM Chat Hub Client (StarterPlayerScripts)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local Rayfield = require(ReplicatedStorage:WaitForChild("Rayfield"))
local SendMessageEvent = ReplicatedStorage:WaitForChild("SendMessageEvent")

local Window = Rayfield:CreateWindow({
    Name = "FXM Chat Hub",
    LoadingTitle = "FXM Chat Hub",
    LoadingSubtitle = "Loading...",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "FXMChatHub",
        FileName = "FXMConfig"
    },
    Discord = {
        Enabled = true,
        Invite = "ktqrvHXV",
        RememberJoins = true
    },
    KeySystem = true,
    KeySettings = {
        Title = "FXM Chat Hub Key",
        Subtitle = "Key System by FM",
        Note = "Join the Discord for access!",
        FileName = "FXMKeyFile",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"fxm123"}
    }
})

Rayfield:Notify({
    Title = "Welcome!",
    Content = "Welcome to FXM Chat Hub!",
    Duration = 5
})

local ChatTab = Window:CreateTab("Chat Hub", 4483362458)

local userInput = ""
local selectedLanguage = "English"

ChatTab:CreateInput({
    Name = "Enter Message",
    PlaceholderText = "Type here...",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        userInput = text
    end,
})

ChatTab:CreateDropdown({
    Name = "Choose Language",
    Options = {"English", "Spanish", "French", "German", "Japanese", "Korean", "Hindi", "Arabic"},
    CurrentOption = "English",
    Callback = function(option)
        selectedLanguage = option
    end
})

ChatTab:CreateButton({
    Name = "Send Message",
    Callback = function()
        if userInput == "" then
            Rayfield:Notify({
                Title = "Empty!",
                Content = "Please enter a message first!",
                Duration = 4
            })
        else
            SendMessageEvent:FireServer(userInput, selectedLanguage)
        end
    end
})
