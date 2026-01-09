{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Only packages that Neovim needs to talk to directly (LSPs)
    extraPackages = with pkgs; [
      lua-language-server
      stylua
      nil # Nix LSP
    ];
  };

  # Symlink my GitHub config to ~/.config/nvim
  home.file.".config/nvim" = {
    source = pkgs.fetchFromGitHub {
      owner = "melekbadreddine";
      repo = "neovim";
      rev = "master";
      sha256 = "sha256-0000000000000000000000000000000000000000000="; 
    };
    recursive = true;
  };
}

