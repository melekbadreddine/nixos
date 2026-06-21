{pkgs, ...}: {
  home.sessionVariables = {
    ANTHROPIC_BASE_URL = "http://localhost:11434";
    ANTHROPIC_AUTH_TOKEN = "ollama";

    ANTHROPIC_MODEL = "qwen2.5-coder:7b";
    ANTHROPIC_DEFAULT_SONNET_MODEL = "qwen2.5-coder:7b";
    ANTHROPIC_DEFAULT_HAIKU_MODEL = "gemma4:e4b";
    ANTHROPIC_DEFAULT_OPUS_MODEL = "glm-5.2:cloud";
  };

  home.file.".claude.json".text = ''
    {
      "mcpServers": {
        "copilot": {
          "command": "npx",
          "args": [
            "-y",
            "@aykahshi/copilot-mcp-server"
          ]
        }
      }
    }
  '';

  home.activation.ponytail = ''
    GLOBAL_CLAUDE_DIR="$HOME/.claude/plugins/ponytail"
    if [ ! -d "$GLOBAL_CLAUDE_DIR" ]; then
      echo "[ponytail] Cloning native tool extension into Claude configuration tree..."
      # Create target folder structural layouts
      mkdir -p "$HOME/.claude/plugins"

      # Clone the repository directly to grab the native execution engine hooks
      ${pkgs.git}/bin/git clone --depth=1 https://github.com/DietrichGebert/ponytail.git "$GLOBAL_CLAUDE_DIR"
    fi
  '';
}
