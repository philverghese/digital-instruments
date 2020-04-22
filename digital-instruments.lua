-----------------------------------------------
-- Digital Instruments
--
-- Uses imgui for the UI element. See imgui_demo.lua
-- for documentation.
-----------------------------------------------

if not SUPPORTS_FLOATING_WINDOWS then
    logMsg('Please update your FlyWithLua to the latest version')
    return
end

require('graphics')

dataref('airspeed', 'sim/cockpit2/gauges/indicators/airspeed_kts_pilot')

local wnd = float_wnd_create(300, 100, 1, true)
float_wnd_set_title(wnd, 'Digital Instruments')
float_wnd_set_imgui_builder(wnd, 'DIGI_build_window')

function DIGI_build_window(wnd, x, y)
    imgui.TextUnformatted("        NAV1    NAV2")
    imgui.TextUnformatted("OBS     " .. string.format('%03d', airspeed))
end
