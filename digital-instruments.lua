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

dataref('nav1_course', 'sim/cockpit/radios/nav1_course_degm')
dataref('nav1_obs', 'sim/cockpit/radios/nav1_obs_degm')
dataref('nav1_fromto', 'sim/cockpit/radios/nav1_fromto')
dataref('nav1_dme', 'sim/cockpit/radios/nav1_dme_dist_m')

local wnd = float_wnd_create(300, 100, 1, true)
local fromto_text = {[0]='OFF', [1]='TO', [2]='FROM'}

float_wnd_set_title(wnd, 'Digital Instruments')
float_wnd_set_imgui_builder(wnd, 'DIGI_build_window')

function DIGI_build_window(wnd, x, y)
    imgui.TextUnformatted("        NAV1    NAV2")
    imgui.TextUnformatted("CRS     " .. string.format('%03d', nav1_course))
    imgui.TextUnformatted("OBS     " .. string.format('%03d', nav1_obs))
    imgui.TextUnformatted("FLAG    " .. string.format('%-4s', fromto_text[nav1_fromto]))
    imgui.TextUnformatted("DME     " .. string.format('%.1f', nav1_dme))

end
