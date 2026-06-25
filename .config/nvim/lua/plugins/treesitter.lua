
return {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    config = function()
        require('nvim-treesitter').setup({
            ensure_installed = { "lua", "c" },
            auto_install = false,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
}
