local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- 設定ファイルの自動リロード
config.automatically_reload_config = true
-- カラースキーマ
config.color_scheme = "Tokyo Night"
-- フォントサイズ
config.font_size = 16.0
-- 背景透過
config.window_background_opacity = 0.85
-- WezTermのタブが一つの時はタブバーを非表示
config.hide_tab_bar_if_only_one_tab = true

return config
