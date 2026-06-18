{...}: {
  # 1. Declaratively writes the config map inside the home directory
  home.file.".config/litellm/config.yaml".text = ''
    model_list:
      - model_name: claude-sonnet-4-6
        litellm_params:
          model: nvidia_nim/qwen/qwen3.5-122b-a10b
          api_key: "NVIDIA_NIM_API_KEY"
      - model_name: claude-opus-4-6
        litellm_params:
          model: nvidia_nim/z-ai/glm5
          api_key: "NVIDIA_NIM_API_KEY"
      - model_name: claude-haiku-4-5
        litellm_params:
          model: nvidia_nim/moonshotai/kimi-k2.5
          api_key: "NVIDIA_NIM_API_KEY"

    litellm_settings:
      drop_params: true

    general_settings:
      master_key: "sk-litellm-local"
  '';

  # 2. Exports standard terminal variables directly to the session layout
  home.sessionVariables = {
    # Forces 'claude' CLI utility paths to point to the proxy container
    ANTHROPIC_BASE_URL = "http://localhost:4000";
    ANTHROPIC_API_KEY = "sk-litellm-local";

    # Tool mapping routing parameters
    ANTHROPIC_MODEL = "claude-sonnet-4-6";
    ANTHROPIC_DEFAULT_OPUS_MODEL = "claude-opus-4-6";
    ANTHROPIC_DEFAULT_SONNET_MODEL = "claude-sonnet-4-6";
    ANTHROPIC_DEFAULT_HAIKU_MODEL = "claude-haiku-4-5";
  };
}
