-- ============================================================
-- Hyprland config
-- ============================================================


-- ============================================================
-- Monitors
-- ============================================================

-- Laptop display: left
hl.monitor({
    output = "eDP-2",
    mode = "1920x1200@165",
    position = "0x0",
    scale = 1.5,
})

-- LG UltraGear: right
hl.monitor({
    output = "HDMI-A-2",
    mode = "2560x1440@143.99",
    position = "1280x0",
    scale = 1,
})


-- ============================================================
-- Programs
-- ============================================================

local terminal = "alacritty"
local fileManager = "thunar"


-- ============================================================
-- General
-- ============================================================

hl.config({
    general = {
        gaps_in = 6,
        gaps_out = 12,
        border_size = 8,

        layout = "dwindle",

        resize_on_border = true,
    },

    decoration = {
        rounding = 12,

        active_opacity = 1.0,
        inactive_opacity = 0.97,

        shadow = {
            enabled = true,
        },

        blur = {
            enabled = true,
            size = 6,
            passes = 3,
        },
    },

    animations = {
        enabled = true,
    },

    input = {
        kb_layout = "us",

        follow_mouse = 1,

        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
        },
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
})


-- ============================================================
-- Keybinds
-- ============================================================

-- Applications
hl.bind("SUPER + Q", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + E", hl.dsp.exec_cmd(fileManager))

-- Quickshell
hl.bind(
    "SUPER + R",
    hl.dsp.exec_cmd("qs ipc call launcher toggle")
)

hl.bind(
    "SUPER + W",
    hl.dsp.exec_cmd("qs ipc call wallpapers toggle")
)

hl.bind(
    "SUPER + P",
    hl.dsp.exec_cmd("qs ipc call power toggle")
)

hl.bind(
    "SUPER + SHIFT + S",
    hl.dsp.exec_cmd("qs ipc call settings toggle")
)

hl.bind(
    "SUPER + SHIFT + C",
    hl.dsp.exec_cmd("qs ipc call calculator toggle")
)

hl.bind(
    "SUPER + N",
    hl.dsp.exec_cmd("qs ipc call quicknotes toggle")
)

hl.bind(
    "SUPER + SHIFT + P",
    hl.dsp.exec_cmd("qs ipc call colorpicker toggle")
)

-- Full screenshot
hl.bind(
    "PRINT",
    hl.dsp.exec_cmd("mkdir -p ~/Pictures/Screenshots && grim ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png")
)

-- Select area and copy to clipboard
hl.bind(
    "SUPER + PRINT",
    hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy")
)

-- hyprlock
hl.bind(
    "SUPER + SHIFT + L",
    hl.dsp.exec_cmd("hyprlock")
)



-- Windows
hl.bind("SUPER + C", hl.dsp.window.close())

-- Exit Hyprland
hl.bind("SUPER + M", hl.dsp.exit())


-- ============================================================
-- Focus
-- ============================================================

hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }))


-- ============================================================
-- Workspaces
-- ============================================================

for i = 1, 9 do
    local ws = tostring(i)

    -- Switch workspace
    hl.bind(
        "SUPER + " .. i,
        hl.dsp.focus({ workspace = ws })
    )

    -- Move active window to workspace
    hl.bind(
        "SUPER + SHIFT + " .. i,
        hl.dsp.window.move({ workspace = ws })
    )
end

-- Workspace 10
hl.bind(
    "SUPER + 0",
    hl.dsp.focus({ workspace = "10" })
)

hl.bind(
    "SUPER + SHIFT + 0",
    hl.dsp.window.move({ workspace = "10" })
)


-- ============================================================
-- Mouse
-- ============================================================

hl.bind(
    "SUPER + mouse:272",
    hl.dsp.window.drag(),
    { mouse = true }
)

hl.bind(
    "SUPER + mouse:273",
    hl.dsp.window.resize(),
    { mouse = true }
)


-- ============================================================
-- Autostart
-- ============================================================

hl.on("hyprland.start", function() 
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd(
        "sh -c 'sleep 1; awww img /home/duhan/Pictures/Photos/wallhaven-vpewrl.jpg'"
    )
    hl.exec_cmd("qs")
end)
