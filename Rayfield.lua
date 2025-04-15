return {
    CreateWindow = function(config)
        print("Rayfield window created")
        return {
            CreateTab = function(name, icon)
                return {
                    CreateInput = function(props) end,
                    CreateDropdown = function(props) end,
                    CreateButton = function(props) end,
                }
            end
        }
    end,
    Notify = function(data)
        print("Notification: " .. data.Title)
    end
}