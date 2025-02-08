-- Pull in the wezterm API
local wezterm = require 'wezterm'

local act = wezterm.action

-- This will hold the configuration.
local config = {
  set_environment_variables = {
    PATH = "/opt/homebrew/bin:" .. os.getenv("PATH")
  },
  default_prog = { "bash", "-c", "tmux a || tmux" },
  color_scheme = "Catppuccin Mocha",
  font = wezterm.font 'RobotoMono Nerd Font Mono',
  font_size = 18.0,
  initial_rows = 50,
  initial_cols = 170,
  line_height = 1.0,
  window_background_opacity = 0.9,
  window_frame = {
    font = wezterm.font('RobotoMono Nerd Font Mono', { bold = true }),
    font_size = 14,
  },
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = true,
  show_tab_index_in_tab_bar = true,
  switch_to_last_active_tab_when_closing_tab = true,
  tab_max_width = 25,
  keys = {
    -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
    { key = "LeftArrow", mods = "OPT", action = wezterm.action{SendString="\x1bb"} },
    -- Make Option-Right equivalent to Alt-f; forward-word
    { key = "RightArrow", mods="OPT", action = wezterm.action{SendString="\x1bf"} },
  }
}

-- Custom title and icon based on: https://github.com/protiumx/.dotfiles/blob/854d4b159a0a0512dc24cbc840af467ac84085f8/stow/wezterm/.config/wezterm/wezterm.lua#L291-L319
local process_icons = {
  ["bash"] = wezterm.nerdfonts.cod_terminal_bash,
  ["btm"] = wezterm.nerdfonts.mdi_chart_donut_variant,
  ["cargo"] = wezterm.nerdfonts.dev_rust,
  ["curl"] = wezterm.nerdfonts.mdi_flattr,
  ["docker"] = wezterm.nerdfonts.linux_docker,
  ["docker-compose"] = wezterm.nerdfonts.linux_docker,
  ["gh"] = wezterm.nerdfonts.dev_github_badge,
  ["git"] = wezterm.nerdfonts.fa_git,
  ["go"] = wezterm.nerdfonts.seti_go,
  ["htop"] = wezterm.nerdfonts.mdi_chart_donut_variant,
  ["kubectl"] = wezterm.nerdfonts.linux_docker,
  ["kuberlr"] = wezterm.nerdfonts.linux_docker,
  ["lazydocker"] = wezterm.nerdfonts.linux_docker,
  ["lazygit"] = wezterm.nerdfonts.oct_git_compare,
  ["lua"] = wezterm.nerdfonts.seti_lua,
  ["make"] = wezterm.nerdfonts.seti_makefile,
  ["node"] = wezterm.nerdfonts.mdi_hexagon,
  ["nvim"] = wezterm.nerdfonts.custom_vim,
  ["psql"] = "󱤢",
  ["ruby"] = wezterm.nerdfonts.cod_ruby,
  ["stern"] = wezterm.nerdfonts.linux_docker,
  ["sudo"] = wezterm.nerdfonts.fa_hashtag,
  ["usql"] = "󱤢",
  ["vim"] = wezterm.nerdfonts.dev_vim,
  ["wget"] = wezterm.nerdfonts.mdi_arrow_down_box,
  ["zsh"] = wezterm.nerdfonts.dev_terminal,
}

-- Return the Tab's current working directory
local function get_cwd(tab)
  return tab.active_pane.current_working_dir.file_path or ""
end

-- Remove all path components and return only the last value
local function remove_abs_path(path) return path:gsub("(.*[/\\])(.*)", "%2") end

-- Return the pretty path of the tab's current working directory
local function get_display_cwd(tab)
  local current_dir = get_cwd(tab)
  local HOME_DIR = string.format("file://%s", os.getenv("HOME"))
  return current_dir == HOME_DIR and "~/" or remove_abs_path(current_dir)
end

-- Return the concise name or icon of the running process for display
local function get_process(tab)
  if not tab.active_pane or tab.active_pane.foreground_process_name == "" then return "[?]" end

  local process_name = remove_abs_path(tab.active_pane.foreground_process_name)
  if process_name:find("kubectl") then process_name = "kubectl" end

  return process_icons[process_name] or string.format("[%s]", process_name)
end

-- Pretty format the tab title
function format_title(tab)
  local cwd = get_display_cwd(tab)
  local process = get_process(tab)
  return string.format("  %s %s  ", cwd, process)
end


wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local title = format_title(tab)
    if tab.is_active then
      return {
        { Background = { Color = '#B4E380' } },
        { Foreground = { Color = '#173B45' } },
        { Text = title },
      }
    end
    return title
  end
)

-- and finally, return the configuration to wezterm
return config
