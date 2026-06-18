{
  pkgs,
  lib,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = lib.mkForce true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withPython3 = false;
    withRuby = false;

    extraPackages = with pkgs; [
      lua-language-server
      stylua
    ];
  };

  xdg.configFile."nvim/init.lua".text = ''
    require("config.lazy")
  '';

  xdg.configFile."nvim/lua/config/lazy.lua".text = ''
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
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

    require("lazy").setup({
      spec = {
        { "LazyVim/LazyVim", import = "lazyvim.plugins" },
        { import = "plugins" },
      },
      defaults = {
        lazy = false,
        version = false,
      },
      install = { colorscheme = { "tokyonight", "habamax" } },
      checker = { enabled = true },
      performance = {
        rtp = {
          disabled_plugins = {
            "gzip",
            "tarPlugin",
            "tohtml",
            "tutor",
            "zipPlugin",
          },
        },
      },
    })
  '';

  xdg.configFile."nvim/lua/config/keymaps.lua".text = ''
    -- Keymaps are automatically loaded on the VeryLazy event
    -- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
    -- Add any additional keymaps here
  '';

  xdg.configFile."nvim/lua/config/options.lua".text = ''
    -- Options are automatically loaded before plugins.lua
    vim.g.mapleader = " "
    vim.g.maplocalleader = "\\"

    vim.opt.mouse = "a"

    -- Add any additional options here
  '';

  xdg.configFile."nvim/lua/config/autocmds.lua".text = ''
    -- Autocmds are automatically loaded on the VeryLazy event
    -- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
    -- Add any additional autocmds here
  '';
}
