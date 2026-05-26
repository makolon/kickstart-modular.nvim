-- ~/.config/nvim/lua/plugins/image.lua
-- Eager-load image.nvim so hijack works when opening image files.
-- This prevents opening .png as raw binary text.

return {
  '3rd/image.nvim',
  lazy = false, -- IMPORTANT: load at startup
  dependencies = { 'nvim-lua/plenary.nvim' },
  build = false, -- using magick_cli, no rock build needed
  config = function()
    require('image').setup {
      backend = 'kitty',
      processor = 'magick_cli',

      -- Hijack image files so they render as images instead of binary text.
      hijack_file_patterns = {
        '*.png',
        '*.jpg',
        '*.jpeg',
        '*.gif',
        '*.webp',
        '*.avif',
      },
    }
  end,
}
