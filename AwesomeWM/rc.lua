-- Theme By Kanine5 
-- Install artwiz fonts for exact results
-- ----------------------------------------
-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

-- I added these
require("vicious")


-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.init("/home/zeki/.config/awesome/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "terminator"
--editor = os.getenv("EDITOR") or "nano"
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
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {

    names = { "term", "web", "work", "mail", "misc"},
   -- layout = {layout[1], layout[1], layout[1], layout[1], layout[1], layout[1], layout[1], layout[1], layout[1] }
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    --tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
    tags[s] = awful.tag(tags.names, s, layout)
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

internet = {
   { "Browser", "google-chrome" },
   { "Mail", "thunderbird" },
   { "Skype", "skype" },
   { "IM Messenger", "pidgin" },
   { "IRC", "xchat" },
   { "Miro", "miro" },
}

myoffice = {
    { "Word Processor", "soffice --writer"},
    { "Presentation", "soffice --impress"},
    { "Spreadsheet", "soffice --calc"},
}


utilities = {
    { "Text Editor", "medit" },
    { "Calculator", "speedcrunch" },
    
}

settings = {
	{ "Change Wallpaper", "nitrogen" },
	{ "Change Themes", "lxappearance" },
}

places = {
	{ "Home", "thunar /home/zeki" },
	{ "Storage", "thunar /media/Storage" },
	{ "Downloads", "thunar /home/zeki/Downloads" },
	{ "Sem2", "thunar /media/Storage/Files/Courses/3rd_year/Sem2/" },
}


mypowermenu = {
   { "Lock Screen", "/home/zeki/bin/myXlock"},
   { "Standby", "sudo s2ram" },
   { "Hibernate", "sudo s2disk" },
   { "Reboot", "sudo reboot" },
   { "Shutdown", "sudo shutdown -h +0" }
}

mymainmenu = awful.menu({ items = { 
				    { "Places", places,  beautiful.awesome_icon },
					 { "Internet", internet },
                     { "Office", myoffice },
                     { "Utilities", utilities },
					 { "Config", settings },
					 { "awesome", myawesomemenu },
				    { "Power Options", mypowermenu }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- Vicious
-- --------------------------------------
-- Memory usage
memwidget = widget({ type = "textbox" })
vicious.register(memwidget, vicious.widgets.mem, "<span color='#01DF3A'>RAM : $2Mb</span>", 5)
-- Cpu usage
cpuwidget = widget({ type = "textbox" })
vicious.register( cpuwidget, vicious.widgets.cpu, "<span color = '#FE9A2E'>CPU : $1% </span>")

-- MPD widget
mpdwidget = widget({ type = "textbox" })
vicious.register( mpdwidget, vicious.widgets.mpd,
            function (widget, args)
               if args["{state}"] == "Stop" then
                  return "not playing"
               elseif args["{state}"] == "Pause" then 
                  return "Paused : " .. args["{Artist}"] .. " - " .. args["{Title}"]
               else
                  return "Playing : ".. args["{Artist}"] .. " - " .. args["{Title}"]
               end
            end, 4)

-- Uptime
uptimewidget = widget({ type = "textbox" })
vicious.register( uptimewidget, vicious.widgets.uptime, "<span color = '#D97672'> Uptime : $1d $2h $3min </span>")

-- System
syswidget = widget({ type = "textbox" })
vicious.register( syswidget, vicious.widgets.os, "<span color = '#58ACFA'> Arch Linux : $2</span>")

-- Wifi widget
wifiwidget = widget({ type = "textbox" })
vicious.register( wifiwidget, vicious.widgets.wifi, "<span color = '#FE2EF7'>wifi : ${ssid} rate: ${rate}MB/s link: ${link}/70</span>", 5, "wlan0")

-- Battery usage
powermenu = awful.menu({items = {
			     { "Ondemand" , function () awful.util.spawn("sudo cpufreq-set -g ondemand -r", false) end },
			     { "Powersave" , function () awful.util.spawn("sudo cpufreq-set -g powersave -r", false) end },
			     { "Performance" , function () awful.util.spawn("sudo cpufreq-set -g performance -r", false) end },
			     { "pm-powersave" , function () awful.util.spawn("sudo pm-powersave", false) end }
			  }
		       })
battwidget = widget({ type = "textbox" })
vicious.register( battwidget, vicious.widgets.bat, "<span color = '#FFFF00'>Battery : state: $1 load: $2%</span>", 13, "BAT0" )
battwidget:buttons(awful.util.table.join(
					 awful.button({ }, 1, function () powermenu:toggle() end )
				   ))


-- ----------------------------------------------------------------------------------
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" }, "<span color = '#F78181'>%a, %d %b %Y ^ %I:%M %p</span>")

-- Create a separator text
separator = widget({ type = "textbox" })
separator.text = " >> " 

-- Create a systray
mysystray = widget({ type = "systray" })
-- Create a wibox for each screen and add it
topbar = {}
bottombar = {}
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
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
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
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    -- Top Wibox
    topbar[s] = awful.wibox({ position = "top", screen = s })
    -- Bottom Wibox
    bottombar[s] = awful.wibox({ position = "bottom", screen = s })
    -- Add widgets to the wibox - order matters
    topbar[s].widgets = {
        {
            mytaglist[s],
            mypromptbox[s],
            separator,
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        s == 1 and mysystray or nil,
        separator, 
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
    bottombar[s].widgets = {
		  {
			  mylauncher,
			  syswidget,
			  separator,
			  uptimewidget,
			  layout = awful.widget.layout.horizontal.leftright
		  },
        mytextclock,
        separator, 
		  mpdwidget,
		  separator,
		  cpuwidget,
        separator,
        memwidget,
		  separator,
		  wifiwidget,
		  separator,
		  battwidget,
        layout = awful.widget.layout.horizontal.rightleft

    }
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

    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "j",
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

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- User Added Keys
    awful.key({ modkey,           }, "b", function () awful.util.spawn("firefox") end),
    awful.key({ modkey,           }, "l", function () awful.util.spawn("/home/zeki/bin/myXlock") end),
    awful.key({ modkey,   "Shift" }, "f", function () awful.util.spawn("thunar") end), 
    -- Volume Control 

    awful.key({ " ",           }, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer set Master 5%+ unmute") end),
    awful.key({ " ",           }, "XF86AudioLowerVolume", function () awful.util.spawn("amixer set Master 5%- unmute") end),
    awful.key({ " ",           }, "XF86AudioMute", function () awful.util.spawn("amixer set Master toggle") end),


    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
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
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

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

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Autorun Applications
awful.util.spawn_with_shell("run_once volwheel")
awful.util.spawn_with_shell("run_once dropboxd")
awful.util.spawn_with_shell("run_once tomboy")
awful.util.spawn_with_shell("run_once parcellite")
awful.util.spawn_with_shell("run_once mpd /home/zeki/.mpd/mpd.conf")



