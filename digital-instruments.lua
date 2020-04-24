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
require('math')

-- Name all global things with DIGI_ prefix for some isolation from other scripts.
dataref('DIGI_gps1_crs', 'sim/cockpit/radios/gps_course_degtm', 'writable')
dataref('DIGI_nav1_obs', 'sim/cockpit/radios/nav1_obs_degm', 'writable')
dataref('DIGI_nav1_fromto', 'sim/cockpit/radios/nav1_fromto')
dataref('DIGI_nav1_dme', 'sim/cockpit/radios/nav1_dme_dist_m')
-- The daDIGI_taref docs say that "gps2_course_degtm2" means the copilot
-- instruDIGI_ment. In the stock C172 with 2 GPSs, this is the one that's
-- set foDIGI_r GPS2, not "gps2_course_degtm"
dataref('DIGI_gps2_crs', 'sim/cockpit/radios/gps2_course_degtm2', 'writable')
dataref('DIGI_nav2_obs', 'sim/cockpit/radios/nav2_obs_degm', 'writable')
dataref('DIGI_nav2_fromto', 'sim/cockpit/radios/nav2_fromto')
dataref('DIGI_nav2_dme', 'sim/cockpit/radios/nav2_dme_dist_m')

local fromto_text = {[0]='OFF', [1]='TO', [2]='FROM'}

local function clampAngle(angle)
	return math.fmod(angle + 3600, 360)
end

function DIGI_build_window(wnd, x, y)
    -- Some third-party instruments go outside the range [0, 359]. Clamp those.
    DIGI_gps1_crs = clampAngle(DIGI_gps1_crs)
    DIGI_gps2_crs = clampAngle(DIGI_gps2_crs)
    DIGI_nav1_obs = clampAngle(DIGI_nav1_obs)
    DIGI_nav2_obs = clampAngle(DIGI_nav2_obs)

    imgui.TextUnformatted('        NAV1    NAV2')
    imgui.TextUnformatted('GPS     ' .. string.format('%03d', DIGI_gps1_crs) .. string.format('     %03d', DIGI_gps2_crs))
    imgui.TextUnformatted('OBS     ' .. string.format('%03d', DIGI_nav1_obs) .. string.format('     %03d', DIGI_nav2_obs))
    imgui.TextUnformatted('FLAG    ' .. string.format('%-4s', fromto_text[DIGI_nav1_fromto]) .. string.format('    %-4s', fromto_text[DIGI_nav2_fromto]))
    imgui.TextUnformatted('DME     ' .. string.format('%.1f', DIGI_nav1_dme) .. string.format('     %.1f', DIGI_nav2_dme))
end

DIGI_wnd = nil

function DIGI_show_wnd()
    DIGI_wnd = float_wnd_create(180, 100, 1, true)
    float_wnd_set_position(DIGI_wnd, 100, SCREEN_HIGHT - 150)
    float_wnd_set_title(DIGI_wnd, 'Digital Instruments')
    float_wnd_set_imgui_builder(DIGI_wnd, 'DIGI_build_window')
    float_wnd_set_onclose(DIGI_wnd, 'DIGI_closed_wnd')
end

function DIGI_hide_wnd()
    if DIGI_wnd then
        float_wnd_destroy(DIGI_wnd)
    end
    DIGI_wnd = nil
end

function DIGI_closed_wnd()
    if DIGI_wnd then
        DIGI_wnd = nil
    end
end

function DIGI_toggle_wnd()
    if DIGI_wnd then
        DIGI_hide_wnd()
    else
        DIGI_show_wnd()
    end
end

-- Main
DIGI_show_wnd()

-- Menu item to hide/show window
add_macro('Toggle digital instruments window', 'DIGI_toggle_wnd()')

-- Command you can bind to hide/show window
create_command('FlyWithLua/digital-instruments/toggle_window',
    'Toggle the Digital Instruments windows',
    'DIGI_toggle_wnd()', '', '')