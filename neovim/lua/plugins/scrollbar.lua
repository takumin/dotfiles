return {
  {
    'petertriho/nvim-scrollbar',
    event = {
      'BufWinEnter',
      'CmdwinLeave',
      'TabEnter',
      'TermEnter',
      'TextChanged',
      'VimResized',
      'WinEnter',
      'WinScrolled',
    },
    config = true,
  },
}
