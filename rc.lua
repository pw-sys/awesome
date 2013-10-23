-- Standard awesome library
local gears = require("gears")
awful = require("awful")
awful.autofocus = require("awful.autofocus")
awful.rules = require("awful.rules")
-- Theme handling library
beautiful = require("beautiful")
naughty = require("naughty")
vicious = require("vicious")
wibox = require("wibox")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
--blingbling = require("blingbling")


-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/djluciver/.config/awesome/themes/myOwn/theme.lua")

--Colorarray
color = {}
for val = 0, 100, 1 do
    local red, green

    if (val <= 50) then
        red = (255 * val) / 50
        green = 255
    else
        red = 255
        green = 255 - (255 * (val - 50)) / (50)
    end

    color[val] = string.format("#%02x%02x00", red, green)
end

-- This is used later as the default terminal and editor to run.
terminal = "terminal"
editor = "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile.bottom,
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
	layout= {
		layouts[1],
		layouts[10],
		layouts[10],
		layouts[2],
		layouts[3],
		layouts[3],
		layouts[1],
		layouts[1],
		layouts[1]
	},
	name = {
		"c",
		"ec",
		"ff",
		"tb",
		"5pdf",
		"6pi",
		"7",
		"8",
		"9"
	}
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.name, s, tags.layout)
end
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
            gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
--                                    { "Debian", debian.menu.Debian_menu.Debian },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
-- }}}
-- {{{ Separators

--Two separators to make more beautifull the final interface :)
spacer = wibox.widget.textbox()
separator = wibox.widget.textbox()
spacer:set_markup(" ")
separator:set_markup("|")
test = wibox.widget.textbox()
test:set_markup("test")

--}}}

-- {{{ Widget Wibox

-- Create a batwidget (status chrg%) ###############################################################
baticon = wibox.widget.imagebox() 
baticon:set_image("/home/djluciver/.config/awesome/icons/cc/white/png/battery_icon&16.png")
-- Initialize widget
batwidget = wibox.widget.textbox()
-- Register widget
--Displays a plus or minus (charging or not){$1}, then the percentage of charge {$2}, and at the end
--the time to finish the charge or discharge {$3}.
--Maybe you will have to change the BAT0 for BAT1, or BAT2... Try :)
vicious.register(batwidget, vicious.widgets.bat, " $1 $2% $3", 30, "BAT0",71)


-- Create a cpuwidget (usage%) #####################################################################
--
-- A widget who displays the percentage of CPU usage :)
-- The vicious.widgets.cpu return three variables, $1 is the percentage total usage.
-- $2 is the percentage of the first CPU usage, and $3 is the percentage of the second CPU usage.
-- I just use the first one, you can put all you want.
 cpuicon =wibox.widget.imagebox() 
 cpuicon:set_image("/home/djluciver/.config/awesome/icons/cc/white/png/dashboard_icon&16.png")
-- Initialize widget
 cpuwidget = wibox.widget.textbox()
-- Register widget
 --vicious.register(cpuwidget, vicious.widgets.cpu, "$1% $2 $3 $4 $5", 3)
-- Initialize thermal widget 
 thermalwidget  = wibox.widget.textbox()
 vicious.register(thermalwidget, vicious.widgets.thermal, " $1°C", 5, { "coretemp.0", "core"} ,7)
-- Init fan widget
 fanwidget = wibox.widget.textbox() 
-- bashets.register("fan.sh", {widget = fanwidget, separator = " ", update_time=1})
 vicious.register(fanwidget, vicious.widgets.fan, " $1", 13)
 rpmlabel = wibox.widget.textbox()
 rpmlabel:set_markup("rpm")


-- CPU Graph widget ###############################################################################
-- Initialize widget
cpuwidgetgraph1 = awful.widget.graph()
-- Graph properties
cpuwidgetgraph1:set_width(25)
cpuwidgetgraph1:set_background_color("#494B4F")
cpuwidgetgraph1:set_color("#FF5656")
-- cpuwidgetgraph1:set_gradient_colors({ "#FF5656", "#88A175", "#AECF96" })
-- Register widget
vicious.register(cpuwidgetgraph1, vicious.widgets.cpu, "$2",3)
-- Create a clock widget ###########################################################################

clockicon = wibox.widget.imagebox()
clockicon:set_image("/home/djluciver/.config/awesome/icons/cc/white/png/clock_icon&16.png")


-- My volume widget ################################################################################
volumewidget = wibox.widget.textbox()
vicious.register(volumewidget, vicious.widgets.volume, " $1% $2 ", 1, "Master",67)

volumewidget:buttons(awful.util.table.join(
    awful.button({ }, 3, function () awful.util.spawn("terminal -e alsamixer", true) end), --right click to open alsamixer in a xterm
    awful.button({ }, 1, function () awful.util.spawn("amixer -q set Master toggle", false) end) --left click to mute/umute (I have the keybind x86vol... to do it too)
))

volicon = wibox.widget.imagebox()
vicious.register(volicon, vicious.widgets.volume,
	function (widget, args)
		if args[1] == 0 or args[2] == '♩' then
--			volicon.image=image(beautiful.widget_vol_mute)
			volicon:set_image("/home/djluciver/.config/awesome/icons/cc/white/png/sound_mute_icon&16.png")
		elseif args[1] > 50 then
--			volicon.image=image(beautiful.widget_vol_hi)
			volicon:set_image("/home/djluciver/.config/awesome/icons/cc/white/png/sound_high_icon&16.png")
		else
--			volicon.image=image(beautiful.widget_vol_low)
			volicon:set_image("/home/djluciver/.config/awesome/icons/cc/white/png/sound_low_icon&16.png")
		end
	end,
1, "Master",17)

--To volume_up and Volume_down I have two keybindings: x86vol....

-- Create a wifiwidget ############################################################################
 
 -- Wifi widget!!!!
 -- It displays the SSID of the net you are connected ( ${ssid} ), the percentage of connectivity ( ${link} )
 -- and the rate ( ${rate} )
 wifiicon = wibox.widget.imagebox()
 wifiicon:set_image("/home/djluciver/.config/awesome/icons/cc/white/png/wireless_signal_icon&16.png")
 -- Initialize widget
 wifiwidget = wibox.widget.textbox()
 -- Register widget
 vicious.register(wifiwidget, vicious.widgets.wifi, " ${ssid} ${linp}% ${rate}Mbps", 5, "wlan0")

 wifiwidget:buttons(awful.util.table.join(
 awful.button({}, 1, function() awful.util.spawn("wicd-client -n", true) end) --Left click to open wicd-client, but becarefull to don't open it twice or more
 ))


-- Create a netwidget (usage) #####################################################################

--Widget who print the kb/s you are downloading and uploading :)
--Just with wlan, with eht you will have to change it ;)
dnicon = wibox.widget.imagebox()
upicon = wibox.widget.imagebox()
--dnicon.image = image("/home/rock/.config/awesome/icons/down.png")
upicon:set_image("/home/djluciver/.config/awesome/icons/cc/white/png/balance_icon&16.png")
-- Initialize widget
netwidget = wibox.widget.textbox()
-- Register widget
vicious.register(netwidget, vicious.widgets.net, "↓${wlan0 down_kb} ↑${wlan0 up_kb}kb/s", 5)



-- DOMEs #########################################################################################

-- Create a CPU Widget
cpuwidgetd = wibox.widget.textbox()
vicious.register(cpuwidgetd, vicious.widgets.cpu, 
	function (widget, args)
		local out = '['
		for i = 1, 5, 1 do
			out = out .. string.format("<span color=\"%s\">%02d</span>|", color[args[i]], args[i])
		 end
 		 return string.sub(out, 0, string.len(out) - 1) .. '] '
	end, 7)



-- start all bashets          #####################################################################
-- bashets.start()

-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)
    -- mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
    --[[
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)
					  --]]

    -- Create the wibox

    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    
    right_layout:add(wifiicon)
    right_layout:add(wifiwidget)
    right_layout:add(spacer)
    right_layout:add(upicon)
    right_layout:add(netwidget)
    right_layout:add(spacer)
    right_layout:add(cpuicon)
    right_layout:add(spacer)
    right_layout:add(cpuwidgetgraph1)
    right_layout:add(spacer)
    right_layout:add(cpuwidgetd)
    --right_layout:add(cpuwidget)
    right_layout:add(thermalwidget)
    right_layout:add(fanwidget)
    right_layout:add(rpmlabel)
    right_layout:add(spacer)
    right_layout:add(baticon)
    right_layout:add(batwidget)
    right_layout:add(spacer)
    right_layout:add(volicon)
    right_layout:add(volumewidget)
    right_layout:add(clockicon)
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
    --[[
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
	mytextclock, clockicon,
--eigene widgets
	rpmlabel,fanwidget,thermalwidget,cpuwidget, spacer,  cpuicon,  --cpu widget
	batwidget, baticon,  --Battery widget :)
	volumewidget, volicon, spacer,
	netwidget, upicon, spacer,
	wifiwidget, wifiicon, spacer,
--uhr
        spacer,spacer,
	s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
   }
   --]]
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
    
    -- Change Keyboard backlight
    awful.key({            }, "XF86KbdBrightnessDown", function () awful.util.spawn_with_shell("sudo kbacklight $((`kbacklight`-10))") end),
    awful.key({            }, "XF86KbdBrightnessUp", function () awful.util.spawn_with_shell("sudo kbacklight $((`kbacklight`+10))") end),
    
    
    --awful.key({            }, "XF86MonBrightnessDown", function () awful.util.spawn_with_shell("sudo backlight $((`backlight`-5))") end),
    awful.key({            }, "XF86MonBrightnessDown", function () awful.util.spawn("xbacklight -dec 10") end),
    --awful.key({            }, "XF86MonBrightnessUp", function () awful.util.spawn_with_shell("sudo backlight $((`backlight`+5))") end),
    awful.key({            }, "XF86MonBrightnessUp", function () awful.util.spawn_with_shell("xbacklight -inc 10; echo $? >>/tmp/debug") end),
    
    
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    --Volume!!

    awful.key({	 }, "XF86AudioLowerVolume", function () awful.util.spawn("amixer -q sset Master 5%-") end),
    awful.key({	 }, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer -q sset Master 5%+") end),
    awful.key({	 }, "XF86AudioMute", function () awful.util.spawn("amixer -q sset Master toggle") end),
    awful.key({modkey,	 }, "F7", function () awful.util.spawn("mpc stop") end),
    awful.key({modkey,	 }, "XF86AudioPlay", function () awful.util.spawn("mpc toggle") end),
    awful.key({modkey,	 }, "F8", function () awful.util.spawn("mpc next") end),
    awful.key({modkey,	 }, "F6", function () awful.util.spawn("mpc prev") end),
    awful.key({modkey,	 }, "m", function () awful.util.spawn(terminal .. " -e ncmpcpp") end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "Wicd Network Manager" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][3] } },
    { rule = { class = "Thunderbird" },
      properties = { tag = tags[1][4], floating = true } },
--    { rule = { class = "Terminal" },
--      properties = { tag = tags[1][1] } },
    { rule = { class = "Nautilus" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "Pidgin" },
      properties = { tag = tags[1][6] } },
      { rule = { class = "Zathura" },
      properties = { tag = tags[screen.count()][5] } },
     { rule = { class = "zathura" },
      properties = { tag = tags[screen.count()][5] } },
   { rule = { class = "Evince" },
      properties = { tag = tags[screen.count()][5] } },
    { rule = { class = "Xpdf" },
      properties = { tag = tags[1][5] } },
    { rule = { class = "Eclipse" },
      properties = { tag = tags[1][2] } }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
--    c:connect_signal("mouse::enter", function(c)
--        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
--            and awful.client.focus.filter(c) then
--            client.focus = c
--       end
--    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Autostart
awful.util.spawn(terminal)
--awful.util.spawn("xfce4-power-manager")
--awful.util.spawn("xautolock.sh")
--awful.util.spawn("pidgin")
--awful.util.spawn("nautilus --no-desktop")
--awful.util.spawn("/usr/lib/gnome-settings-daemon/gnome-settings-daemon")
--awful.util.spawn("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
--awful.util.spawn("nm-applet")

--}}}
