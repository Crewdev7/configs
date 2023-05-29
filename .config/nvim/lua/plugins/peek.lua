return {
  'toppair/peek.nvim',
  build = 'deno task --quiet build:fast',
  config = function ()
    -- Using protected call
    local status_ok, peek = pcall(require, "peek")
    if not status_ok then
      return
    end

    peek.setup {
      auto_load = true,        -- whether to automatically load preview when
      -- entering another markdown buffer
      close_on_bdelete = true, -- close preview window on buffer delete

      syntax = true,           -- enable syntax highlighting, affects performance

      theme = 'light',         -- 'dark' or 'light'

      update_on_change = true,

      app = 'browser', -- 'webview', 'browser', string or a table of strings
      -- explained below

      -- relevant if update_on_change is true
      throttle_at = 200000,   -- start throttling when file exceeds this
      -- amount of bytes in size
      throttle_time = 'auto', -- minimum amount of time in milliseconds
      -- that has to pass before starting new render
    }

    vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
    vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})
  end
}
