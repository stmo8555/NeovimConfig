CapsLock::Esc
Esc::CapsLock

#Requires AutoHotkey v2.0
#SingleInstance Force

tabUsed := false

; --- Allow Alt+Tab (pass Tab through when LAlt is held) ---
#HotIf GetKeyState("LAlt", "P")
~*Tab:: return
~*Tab up:: return
#HotIf

; --- Tap Tab = Tab (only when LAlt is NOT held) ---
#HotIf !GetKeyState("LAlt", "P")

*Tab::
{
    global tabUsed
    tabUsed := false
}

*Tab up::
{
    global tabUsed
    if (!tabUsed) {
        Send "{Tab}"
    }
}

#HotIf

; --- Symbol layer ONLY while Tab is physically held (and LAlt not held) ---
#HotIf GetKeyState("Tab", "P") && !GetKeyState("LAlt", "P")

u::
{
    global tabUsed
    tabUsed := true
    SendText "{"
}

i::
{
    global tabUsed
    tabUsed := true
    SendText "}"
}

j::
{
    global tabUsed
    tabUsed := true
    SendText "("
}

k::
{
    global tabUsed
    tabUsed := true
    SendText ")"
}

l::
{
    global tabUsed
    tabUsed := true
    SendText "["
}

ö::
{
    global tabUsed
    tabUsed := true
    SendText "]"
}

h::
{
    global tabUsed
    tabUsed := true
    SendText "&"
}

,::
{
    global tabUsed
    tabUsed := true
    SendText "\"
}

.::
{
    global tabUsed
    tabUsed := true
    SendText "/"
}

-::
{
    global tabUsed
    tabUsed := true
    SendText "|"
}

ä::
{
    global tabUsed
    tabUsed := true
    SendText "~"
}

n::
{
    global tabUsed
    tabUsed := true
    SendText "<"
}

m::
{
    global tabUsed
    tabUsed := true
    SendText ">"
}

#HotIf
