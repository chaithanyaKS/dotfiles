local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()
config.color_scheme = "Oxocarbon Dark (Gogh)"
config.default_domain = "WSL:Ubuntu-24.04"
config.window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
}
wezterm.font("JetBrains Mono", {weight="Regular", stretch="Normal", style="Normal"})
config.font_size = 12

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = true
-- config.window_decorations = "NONE"
config.show_new_tab_button_in_tab_bar = false

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 5000 }

local function get_projects()
  local success, stdout, stderr = wezterm.run_child_process({
    "wsl.exe",
    "-d",
    "Ubuntu-24.04",
    "--",
    "zsh",
    "-lc",
    "find ~/radware ~/notes -mindepth 1 -maxdepth 2 -type d"
  })

  if not success then
    wezterm.log_error(stderr)
    return {}
  end

  local projects = {}
  for line in stdout:gmatch("[^\r\n]+") do
    table.insert(projects, line)
  end
  if #projects == 0 then
  wezterm.log_error("No projects found")
  return
end

  return projects
end

-- 🔹 Build launcher entries
local function project_launcher(window, pane)
  local projects = get_projects()

  local choices = {}

  for _, path in ipairs(projects) do
    local name = path

    table.insert(choices, {
      label = name .. "  (" .. path .. ")",
      id = path,
    })
  end

  window:perform_action(
    act.InputSelector {
      title = "Select Project",
      choices = choices,
      fuzzy = true,

      action = wezterm.action_callback(function(window, pane, id, label)
        if not id then
          return
        end

        local name = id:match("([^/]+)$"):gsub("%.", "_")

        window:perform_action(
          act.SwitchToWorkspace {
            name = name,
            spawn = { cwd = id },
          },
          pane
        )
      end),
    },
    pane
  )
end



---[ BASE KEYBINDINGS
config.keys = {
  -- Send Ctrl+a to terminal when pressed twice
  { key = "a",  mods = "LEADER|CTRL", action = act.SendString("\x01") },

  -- Doom Mode trigger
  { key = 'w',   mods = 'LEADER', action = act.ActivateKeyTable { name = 'window_mode', one_shot = true } },
  { key = 'Tab', mods = 'LEADER', action = act.ActivateKeyTable { name = 'workspace_mode', one_shot = true } },

  -- Flat binding
  { key = '"',  mods = "LEADER|SHIFT", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
  { key = "%",  mods = "LEADER|SHIFT", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "o",  mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "z",  mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "c",  mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "n",  mods = "LEADER|CTRL", action = act.ActivateTabRelative(1)},
  { key = "p",  mods = "LEADER|CTRL", action = act.ActivateTabRelative(-1) },
  { key = 's',  mods = 'LEADER', action = wezterm.action.ShowLauncherArgs { flags = 'FUZZY|TABS|WORKSPACES' }, },
  { key = "f",  mods = "LEADER|CTRL", action = wezterm.action_callback(project_launcher), },

  -- Navigation
  { key = "h",  mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "j",  mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k",  mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "l",  mods = "LEADER", action = act.ActivatePaneDirection("Right") },

  -- Resizing
  { key = "H",  mods = "LEADER|SHIFT", action = act.AdjustPaneSize { "Left", 5 } },
  { key = "J",  mods = "LEADER|SHIFT", action = act.AdjustPaneSize { "Down", 5 } },
  { key = "K",  mods = "LEADER|SHIFT", action = act.AdjustPaneSize { "Up", 5 } },
  { key = "L",  mods = "LEADER|SHIFT", action = act.AdjustPaneSize { "Right", 5 } },

  -- Tab Navigation (1-9)
  { key = "1",  mods = "LEADER", action = act.ActivateTab(0) },
  { key = "2",  mods = "LEADER", action = act.ActivateTab(1) },
  { key = "3",  mods = "LEADER", action = act.ActivateTab(2) },
  { key = "4",  mods = "LEADER", action = act.ActivateTab(3) },
  { key = "5",  mods = "LEADER", action = act.ActivateTab(4) },
  { key = "6",  mods = "LEADER", action = act.ActivateTab(5) },
  { key = "7",  mods = "LEADER", action = act.ActivateTab(6) },
  { key = "8",  mods = "LEADER", action = act.ActivateTab(7) },
  { key = "9",  mods = "LEADER", action = act.ActivateTab(8) },

  -- Closing
  { key = "&",  mods = "LEADER|SHIFT", action = act.CloseCurrentTab { confirm = true } },
  { key = "d",  mods = "LEADER", action = act.CloseCurrentPane { confirm = true } },
  { key = "x",  mods = "LEADER", action = act.CloseCurrentPane { confirm = true } },
}

---[ Key Tables
config.key_tables = {

  -- Triggered by <leader> w
  window_mode = {
    { key = 'v', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 's', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 'h', action = act.ActivatePaneDirection('Left') },
    { key = 'j', action = act.ActivatePaneDirection('Down') },
    { key = 'k', action = act.ActivatePaneDirection('Up') },
    { key = 'l', action = act.ActivatePaneDirection('Right') },
    { key = 'q', action = act.CloseCurrentPane { confirm = true } },
    { key = 'c', action = act.CloseCurrentPane { confirm = true } },
    { key = 'H', action = act.AdjustPaneSize { 'Left', 5 } },
    { key = 'J', action = act.AdjustPaneSize { 'Down', 5 } },
    { key = 'K', action = act.AdjustPaneSize { 'Up', 5 } },
    { key = 'L', action = act.AdjustPaneSize { 'Right', 5 } },
    { key = 'Escape', action = 'PopKeyTable' },
  },

  -- Triggered by <leader> Tab
  workspace_mode = {
    { key = 'n', action = act.SpawnTab('CurrentPaneDomain') },
    { key = 'd', action = act.CloseCurrentTab { confirm = true } },
    { key = '[', action = act.ActivateTabRelative(-1) },
    { key = ']', action = act.ActivateTabRelative(1) },
    { key = 'Escape', action = 'PopKeyTable' },
  },
}

return config
