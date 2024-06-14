--------------------------------------------------------------------------------
-- 表示系の設定
--
-- シンタックスハイライト有効化
vim.opt.syntax = 'on'
-- True Colors関連設定
if vim.fn.has('termguicolors') == 1 then
  -- iTerm2等が標準で出力する環境変数をチェックする
  -- NOTE: Alacrittyについては設定ファイルでセットしておくこと
  -- See also: https://github.com/termstandard/colors/blob/master/README.md#checking-for-colorterm
  if vim.env.COLORTERM == 'truecolor' then
    -- True Colorsを有効にする ( GUI用の色設定を使う )
    vim.opt.termguicolors = true
    -- tmux環境用の設定
    if vim.env.TMUX then
      -- TODO: 以下vim用設定をneovimでどうやるか
      -- let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
      -- let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    end
  end
end
-- タイトルを表示する
vim.opt.title = true
-- 行番号を表示する
vim.opt.number = true
-- ルーラーを表示する
vim.opt.ruler = true
-- 長い行を折り返さないで表示
vim.opt.wrap = true
-- 行末、タブ、折り返し、文末などを表示する
vim.opt.list = true
-- 行末、タブ、折り返し、文末などの記号設定
vim.opt.listchars = {tab='^ ', trail='-', extends='>', precedes='<'}
-- () [] {} がかかれたとき、対応するカッコを強調表示する
vim.opt.showmatch = true
-- カーソル行の強調表示
vim.opt.cursorline = true
-- ファイル名やディレクトリを補完するときに大文字と小文字を区別しない
vim.opt.wildignorecase = true
-- zshのような補完にする
vim.opt.wildmode = {'list', 'full'}
-- 補完候補を表示しない(上とダブるので)
vim.opt.wildmenu = false
-- 折りたたみ表示を無効化する
vim.opt.foldenable = false
-- ○や□の文字が崩れる問題を回避
-- 正しく適用されない場合は以下を参照
-- https://gist.github.com/lo48576/194f05f9266761d6925495237594edbc
vim.opt.ambiwidth = 'double'

--------------------------------------------------------------------------------
-- ステータス行の表示設定
--
-- 常にステータス行を表示 (詳細は:he laststatus)
vim.opt.laststatus = 2

--------------------------------------------------------------------------------
-- 検索関連
--
-- 検索時に大文字小文字を無視 (noignorecase:無視しない)
vim.opt.ignorecase = true
-- 大文字小文字の両方が含まれている場合は大文字小文字を区別
vim.opt.smartcase = true
-- 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
vim.opt.wrapscan = true
-- 検索文字列入力時に順次対象文字列にヒットさせる
vim.opt.incsearch = true
-- 検索にマッチしたテキストをハイライト表示したままにする
vim.opt.hlsearch = true
-- ctagsファイルを再帰的に検索
vim.opt.tags:append('../tags')

--------------------------------------------------------------------------------
-- 編集に関する設定
--
-- 文字コード設定
vim.opt.fileencodings = {'ucs-bom', 'utf-8', 'cp932', 'sjis', 'euc-jp', 'latin1'}
-- モードライン有効化
vim.opt.modeline = true
-- モードラインの検索行数
vim.opt.modelines = 3
-- 改行時に前の行のインデントを継続する
vim.opt.autoindent = true
-- 改行時に入力された行の末尾に合わせて次の行のインデントを増減する
vim.opt.smartindent = true
-- タブの画面上での幅
vim.opt.tabstop = 2
-- <Tab> の挿入や <BS> の使用等の編集操作をするときに、<Tab> が対応する空白の数。
vim.opt.softtabstop = 2
-- インデントの各段階に使われる空白の数。
vim.opt.shiftwidth = 2
-- タブをスペースに展開する
vim.opt.expandtab = true
-- クリップボードにコピー
vim.opt.clipboard = 'unnamedplus'
-- backspaceキーの挙動を設定する
--   indent        : 行頭の空白の削除を許す
--   eol           : 改行の削除を許す
--   start         : 挿入モードの開始位置での削除を許す
vim.opt.backspace = {'indent', 'eol', 'start'}

--------------------------------------------------------------------------------
-- ファイル操作
--
-- バックアップファイル有効化
vim.opt.backup = true
-- バックアップファイルの拡張子
vim.opt.backupext = '.bak'
-- バックアップファイル作成先ディレクトリ
vim.opt.backupdir = vim.fn.expand('~/.local/state/nvim/backup/')
-- バックアップファイルを作成しないディレクトリ
vim.opt.backupskip = {'/tmp/*'}
-- スワップファイル有効化
vim.opt.swapfile = true
-- スワップファイル作成先ディレクトリ
vim.opt.directory = vim.fn.expand('~/.local/state/nvim/swap/')
-- アンドゥ永続化
vim.opt.undofile = true
-- アンドゥファイル作成先ディレクトリ
vim.opt.undodir = vim.fn.expand('~/.local/state/nvim/undo/')
-- コマンド履歴記録数
vim.opt.history = 10000
