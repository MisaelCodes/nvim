-- LPS stands for language server protocol, communication between
-- code editors and languages servers for language intelligense features. It is an open JSON/RPC standard


return {

    -- mason -> is gonna take care of installing the lsp 
    -- in our system and connect them to our editors.
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    -- mason-lspconfig -> is a sort of interface to install the server
    -- so that we have a bridge between mason and lspconfig
    -- through ensure install we can tell mason and neovim that we
    -- need to install certain languages servers.
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed={ "gopls", "lua_ls" }
            })
        end
    },
    -- nvim-lspconfig -> is used to hook up nvim to the installed
    -- language servers, it also gives key bindings and setup for
    -- communication with the ls
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({})
            lspconfig.gopls.setup({})
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
            vim.keymap.set({'n','v'}, '<leader>ca', vim.lsp.buf.code_action, {})
        end
    }
}
