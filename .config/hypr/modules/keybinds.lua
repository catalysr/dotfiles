
local menu
if HOST == "arch-laptop" then
    menu = "bemenu-run -b -H 36 -W 0.75 --fn 'JetBrains Mono 11' --nb '#0D0D0D' --nf '#FFFFFF' --tb '#0D0D0D' --tf '#FFFFFF' --hb '#FFFFFF' --hf '#0D0D0D'"

else
    menu = "bemenu-run -b -H 34 -W 0.625 --fn 'JetBrains Mono 11' --nb '#0D0D0D' --nf '#FFFFFF' --tb '#0D0D0D' --tf '#FFFFFF' --hb '#FFFFFF' --hf '#0D0D0D'"
end
-------------------------------------------------------------------------------
---- CORE VARIABLES -----------------------------------------------------------
-------------------------------------------------------------------------------
local terminal    = "foot"
local fileManager = "thunar"
local mainMod     = "SUPER"

-------------------------------------------------------------------------------
---- APPLICATION LAUNCHERS ----------------------------------------------------
-------------------------------------------------------------------------------
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + Space",  hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))
-------------------------------------------------------------------------------
---- WINDOW CONTROLS & LAYOUT -------------------------------------------------
-------------------------------------------------------------------------------
local closeWindowBind = hl.bind(mainMod .. " + W", hl.dsp.window.close())
hl.bind(mainMod .. " + V",     hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P",     hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J",     hl.dsp.layout("togglesplit"))    -- dwindle only

-- FULLSCREEN BINDS 
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

-------------------------------------------------------------------------------
---- NAVIGATION & DIRECTIONAL FOCUS -------------------------------------------
-------------------------------------------------------------------------------
-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-------------------------------------------------------------------------------
---- WORKSPACE LOOPS (1-10) ---------------------------------------------------
-------------------------------------------------------------------------------
-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-------------------------------------------------------------------------------
---- SCRATCHPADS & SPECIAL WORKSPACES -----------------------------------------
-------------------------------------------------------------------------------
-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-------------------------------------------------------------------------------
---- MOUSE BINDINGS -----------------------------------------------------------
-------------------------------------------------------------------------------
-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-------------------------------------------------------------------------------
---- SYSTEM MANAGEMENT --------------------------------------------------------
-------------------------------------------------------------------------------
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

-------------------------------------------------------------------------------
---- HARDWARE & MULTIMEDIA KEYS -----------------------------------------------
-------------------------------------------------------------------------------
-- Laptop multimedia keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t"))
