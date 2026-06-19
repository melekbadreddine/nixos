{...}: {
  # LiteLLM config file
  home.file.".config/litellm/config.yaml".text = ''
    model_list:
      - model_name: claude-sonnet-4-6
        litellm_params:
          model: nvidia_nim/qwen/qwen3.5-122b-a10b
          api_key: env/NVIDIA_NIM_API_KEY

      - model_name: claude-opus-4-6
        litellm_params:
          model: nvidia_nim/z-ai/glm5
          api_key: env/NVIDIA_NIM_API_KEY

      - model_name: claude-haiku-4-5
        litellm_params:
          model: nvidia_nim/moonshotai/kimi-k2.5
          api_key: env/NVIDIA_NIM_API_KEY

    litellm_settings:
      drop_params: true

    general_settings:
      master_key: "sk-litellm-local"
  '';

  # Claude CLI environment mapping
  home.sessionVariables = {
    ANTHROPIC_BASE_URL = "http://localhost:4000";
    ANTHROPIC_API_KEY = "sk-litellm-local";

    ANTHROPIC_MODEL = "claude-sonnet-4-6";
    ANTHROPIC_DEFAULT_OPUS_MODEL = "claude-opus-4-6";
    ANTHROPIC_DEFAULT_SONNET_MODEL = "claude-sonnet-4-6";
    ANTHROPIC_DEFAULT_HAIKU_MODEL = "claude-haiku-4-5";
  };

  # Ponytail bootstrap
  home.activation.ponytail = ''
    if [ ! -d "$HOME/.claude/skills/ponytail" ]; then
      echo "[ponytail] installing skill..."
      npx -y skills add DietrichGebert/ponytail
    fi
  '';
}
