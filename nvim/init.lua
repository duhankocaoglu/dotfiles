-- ============================================================
-- Basic settings
-- ============================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.mouse = "a"
opt.clipboard = "unnamedplus"

opt.breakindent = true
opt.undofile = true

opt.ignorecase = true
opt.smartcase = true

opt.signcolumn = "yes"
opt.cursorline = true

opt.termguicolors = true

opt.splitright = true
opt.splitbelow = true

opt.scrolloff = 8
opt.sidescrolloff = 8

opt.updatetime = 200
opt.timeoutlen = 300

opt.showmode = false

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

opt.wrap = false

-- Rounded borders for floating windows
opt.winborder = "rounded"


-- ============================================================
-- Keymaps
-- ============================================================

local map = vim.keymap.set

map("n", "<leader>w", "<cmd>write<cr>", {
    desc = "Save file",
})

map("n", "<leader>q", "<cmd>quit<cr>", {
    desc = "Quit",
})

map("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Window movement
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", {
    desc = "Previous buffer",
})

map("n", "<S-l>", "<cmd>bnext<cr>", {
    desc = "Next buffer",
})

map("n", "<leader>bd", "<cmd>bdelete<cr>", {
    desc = "Delete buffer",
})

-- Move selected lines
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor centered
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")


-- ============================================================
-- lazy.nvim
-- ============================================================

local lazypath =
    vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)


-- ============================================================
-- Plugins
-- ============================================================

require("lazy").setup({

    -- ========================================================
    -- Theme
    -- ========================================================

    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,

        config = function()

            require("catppuccin").setup({
                flavour = "mocha",
            })

            vim.cmd.colorscheme("catppuccin")
        end,
    },


    -- ========================================================
    -- Icons
    -- ========================================================

    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },


    -- ========================================================
    -- Statusline
    -- ========================================================

    {
        "nvim-lualine/lualine.nvim",

        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },

        opts = {

            options = {

                theme = "catppuccin",

                globalstatus = true,

                component_separators = {
                    left = "│",
                    right = "│",
                },

                section_separators = {
                    left = "",
                    right = "",
                },
            },
        },
    },


    -- ========================================================
    -- Telescope
    -- ========================================================

    {
        "nvim-telescope/telescope.nvim",

        version = "*",

        dependencies = {

            "nvim-lua/plenary.nvim",

            "nvim-tree/nvim-web-devicons",

            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
        },

        config = function()

            local telescope = require("telescope")
            local builtin = require("telescope.builtin")

            telescope.setup({

                defaults = {

                    sorting_strategy = "ascending",

                    layout_config = {
                        prompt_position = "top",
                        width = 0.90,
                        height = 0.85,
                    },
                },
            })

            pcall(telescope.load_extension, "fzf")

            map("n", "<leader>ff", builtin.find_files, {
                desc = "Find files",
            })

            map("n", "<leader>fg", builtin.live_grep, {
                desc = "Live grep",
            })

            map("n", "<leader>fb", builtin.buffers, {
                desc = "Buffers",
            })

            map("n", "<leader>fh", builtin.help_tags, {
                desc = "Help",
            })

            map("n", "<leader>fr", builtin.oldfiles, {
                desc = "Recent files",
            })
        end,
    },


    -- ========================================================
    -- File explorer
    -- ========================================================

    {
        "stevearc/oil.nvim",

        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },

        opts = {

            default_file_explorer = true,

            view_options = {
                show_hidden = true,
            },
        },

        config = function(_, opts)

            require("oil").setup(opts)

            map("n", "-", "<cmd>Oil<cr>", {
                desc = "File explorer",
            })

            map("n", "<leader>e", "<cmd>Oil<cr>", {
                desc = "File explorer",
            })
        end,
    },


    -- ========================================================
    -- Git
    -- ========================================================

    {
        "lewis6991/gitsigns.nvim",

        opts = {

            current_line_blame = false,

            signs = {
                add = { text = "┃" },
                change = { text = "┃" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "┆" },
            },
        },
    },


    -- ========================================================
    -- Indentation guides
    -- ========================================================

    {
        "lukas-reineke/indent-blankline.nvim",

        main = "ibl",

        opts = {

            indent = {
                char = "│",
            },

            scope = {
                enabled = true,
            },
        },
    },


    -- ========================================================
    -- Auto pairs
    -- ========================================================

    {
        "windwp/nvim-autopairs",

        event = "InsertEnter",

        opts = {},
    },


    -- ========================================================
    -- Treesitter
    -- ========================================================

    {
        "nvim-treesitter/nvim-treesitter",

        lazy = false,

        build = ":TSUpdate",

        config = function()

            local treesitter =
                require("nvim-treesitter")

            treesitter.setup()

            treesitter.install({

                "bash",

                "c",
                "cpp",

                "css",
                "html",

                "javascript",
                "typescript",

                "json",

                "lua",

                "markdown",
                "markdown_inline",

                "python",

                "rust",

                "toml",

                "vim",
                "vimdoc",
            })

            vim.api.nvim_create_autocmd(
                "FileType",
                {
                    callback = function(args)

                        pcall(
                            vim.treesitter.start,
                            args.buf
                        )

                    end,
                }
            )
        end,
    },


    -- ========================================================
    -- Completion
    -- ========================================================

    {
        "saghen/blink.cmp",

        version = "1.*",

        dependencies = {
            "rafamadriz/friendly-snippets",
        },

        opts = {

            keymap = {
                preset = "default",
            },

            appearance = {
                nerd_font_variant = "mono",
            },

            completion = {

                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                },

                menu = {
                    border = "rounded",
                },
            },

            signature = {
                enabled = true,
            },

            sources = {

                default = {
                    "lsp",
                    "path",
                    "snippets",
                    "buffer",
                },
            },

            fuzzy = {
                implementation = "prefer_rust_with_warning",
            },
        },

        opts_extend = {
            "sources.default",
        },
    },


    -- ========================================================
    -- LSP
    -- ========================================================

    {
        "mason-org/mason-lspconfig.nvim",

        dependencies = {

            {
                "mason-org/mason.nvim",
                opts = {},
            },

            "neovim/nvim-lspconfig",

            "saghen/blink.cmp",
        },

        config = function()

            -- Completion capabilities
            vim.lsp.config("*", {

                capabilities =
                    require("blink.cmp")
                    .get_lsp_capabilities(),
            })


            -- Lua settings
            vim.lsp.config("lua_ls", {

                settings = {

                    Lua = {

                        diagnostics = {
                            globals = {
                                "vim",
                            },
                        },

                        workspace = {
                            checkThirdParty = false,
                        },
                    },
                },
            })


            require("mason-lspconfig").setup({

                ensure_installed = {

                    "lua_ls",

                    "rust_analyzer",

                    "pyright",

                    "clangd",
                },

                automatic_enable = true,
            })
        end,
    },
})


-- ============================================================
-- LSP keymaps
-- ============================================================

vim.api.nvim_create_autocmd(
    "LspAttach",
    {

        callback = function(event)

            local opts = {
                buffer = event.buf,
            }

            map(
                "n",
                "gd",
                vim.lsp.buf.definition,
                opts
            )

            map(
                "n",
                "K",
                vim.lsp.buf.hover,
                opts
            )

            map(
                "n",
                "<leader>rn",
                vim.lsp.buf.rename,
                opts
            )

            map(
                { "n", "v" },
                "<leader>ca",
                vim.lsp.buf.code_action,
                opts
            )

            map(
                "n",
                "<leader>lf",
                function()

                    vim.lsp.buf.format({
                        async = true,
                    })

                end,
                opts
            )

            map(
                "n",
                "<leader>d",
                vim.diagnostic.open_float,
                opts
            )

            map(
                "n",
                "]d",
                function()

                    vim.diagnostic.jump({
                        count = 1,
                        float = true,
                    })

                end,
                opts
            )

            map(
                "n",
                "[d",
                function()

                    vim.diagnostic.jump({
                        count = -1,
                        float = true,
                    })

                end,
                opts
            )
        end,
    }
)
