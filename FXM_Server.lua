-- FXM Chat Hub Server (ServerScriptService)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local ChatService = game:GetService("Chat")

local SendMessageEvent = ReplicatedStorage:FindFirstChild("SendMessageEvent")
if not SendMessageEvent then
    SendMessageEvent = Instance.new("RemoteEvent", ReplicatedStorage)
    SendMessageEvent.Name = "SendMessageEvent"
end

local OPENAI_API_KEY = "YOUR_OPENAI_API_KEY" -- Replace with actual key
local OPENAI_API_URL = "https://api.openai.com/v1/chat/completions"

local function processMessage(message, language)
    local prompt = "Fix grammar and translate this to " .. language .. ": " .. message
    local requestBody = {
        model = "gpt-3.5-turbo",
        messages = {
            { role = "user", content = prompt }
        }
    }

    local success, response = pcall(function()
        return HttpService:RequestAsync({
            Url = OPENAI_API_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["Authorization"] = "Bearer " .. OPENAI_API_KEY
            },
            Body = HttpService:JSONEncode(requestBody)
        })
    end)

    if success and response.Success then
        local data = HttpService:JSONDecode(response.Body)
        return data.choices[1].message.content
    else
        warn("[OpenAI] Request failed:", response)
        return "Sorry, I couldn't process that message."
    end
end

SendMessageEvent.OnServerEvent:Connect(function(player, message, language)
    local response = processMessage(message, language)
    if player.Character and player.Character:FindFirstChild("Head") then
        ChatService:Chat(player.Character.Head, response, Enum.ChatColor.Blue)
    end
end)
