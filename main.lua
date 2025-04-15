
-- FXM Chat Hub - Delta Executor Script
-- Created by ChatGPT for openaitoken | FXM Project
-- Loadstring-compatible | Uses Rayfield UI and OpenAI integration
-- Discord: https://discord.gg/ktqrvHXV

-- Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- SETTINGS
local API_KEY = "YOUR_OPENAI_API_KEY" -- Replace this with your real OpenAI API key
local KEY_REQUIRED = "fxm-access" -- Example key for access

-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()

-- Key System UI
local KeyUI = Rayfield:CreateWindow({
    Name = "Key System by fm",
    LoadingTitle = "FXM Key Check",
    LoadingSubtitle = "Script by openaitoken",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = true,
        Invite = "ktqrvHXV",
        RememberJoins = false
    },
    KeySystem = true,
    KeySettings = {
        Title = "FXM Chat Hub Access",
        Subtitle = "Key System by fm",
        Note = "Join the Discord for the key",
        FileName = "FXMKeyFile",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = KEY_REQUIRED
    }
})

-- Main Window (shown after key success)
local Window = Rayfield:CreateWindow({
    Name = "Welcome to FXM Chat Hub",
    LoadingTitle = "FXM Hub",
    LoadingSubtitle = "Chat with AI",
    ConfigurationSaving = {
        Enabled = false
    }
})

-- Language Options
local Languages = {
    "English", "Spanish", "French", "German", "Russian", "Japanese", "Korean", "Chinese (Simplified)", "Arabic", "Portuguese", "Hindi"
}
local selectedLanguage = "English"

-- UI Elements
local MainTab = Window:CreateTab("FXM Chat", 4483362458)

MainTab:CreateDropdown({
    Name = "Choose Output Language",
    Options = Languages,
    CurrentOption = "English",
    Flag = "LanguageDropdown",
    Callback = function(option)
        selectedLanguage = option
    end
})

MainTab:CreateParagraph({Title = "FXM AI Chat", Content = "Type your message below. Grammar will be corrected and translated."})

MainTab:CreateInput({
    Name = "Your Message",
    PlaceholderText = "Type here...",
    RemoveTextAfterFocusLost = false,
    Callback = function(input)
        Rayfield:Notify({
            Title = "FXM Chat",
            Content = "Sending message to AI...",
            Duration = 3
        })

        -- Make the OpenAI request
        local prompt = string.format("Fix grammar and translate this message into %s: %s", selectedLanguage, input)
        local success, response = pcall(function()
            return syn.request({
                Url = "https://api.openai.com/v1/completions",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["Authorization"] = "Bearer " .. API_KEY,
                },
                Body = HttpService:JSONEncode({
                    model = "text-davinci-003",
                    prompt = prompt,
                    max_tokens = 100,
                    temperature = 0.7
                })
            })
        end)

        if success and response and response.Body then
            local json = HttpService:JSONDecode(response.Body)
            local aiMessage = json.choices and json.choices[1] and json.choices[1].text or "No response."
            Rayfield:Notify({
                Title = "AI Response",
                Content = aiMessage,
                Duration = 10
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Failed to contact OpenAI API.",
                Duration = 5
            })
        end
    end
})
