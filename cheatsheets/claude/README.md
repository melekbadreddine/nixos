# Claude Code via NVIDIA NIM Workaround

This document details the declarative workaround used to redirect the `claude` CLI tool to run open-weight coding models hosted via NVIDIA Inference Microservices (NIM).

This setup is inspired by and adapted from the implementation guide detailed in [Running Claude Code for Free with NVIDIA NIM](https://uright.ca/posts/running-claude-code-for-free-with-nvidia-nim/).

## Architecture Workflow


```

[ Claude Code CLI ]
│
▼ (Intercepts Anthropic Messages API format)
[ LiteLLM Proxy Container (Port 4000) ] ── (Drops incompatible parameters)
│
▼ (Translates to OpenAI-compatible API format)
[ NVIDIA NIM Cloud Endpoints ]
│
├─► Qwen 3.5 122B (Default Sonnet slot)
├─► GLM-5 744B MoE (Default Opus slot)
└─► Kimi K2.5 1T MoE (Default Haiku slot)

```

## Internal Setup Blueprint

The configuration is modularized and split across two core layers inside the dotfiles:

### 1. System Infrastructure Layer (`modules/core/litellm.nix`)
Spins up a declarative `docker` container engine that starts up automatically at boot. It securely fetches the encrypted API token directly from your `sops-nix` pipeline:
* **Container Source:** `docker.litellm.ai/berriai/litellm:main-stable`
* **Port:** `4000`
* **Credentials Binding:** `config.sops.secrets."NVIDIA_NIM_API_KEY".path`

### 2. User Space & Environment Layer (`home-manager/modules/programs/litellm.nix`)
Generates user configuration maps and sets global variables:
* **Config Target:** Writes out to `~/.config/litellm/config.yaml`
* **Target Overrides:** Sets `ANTHROPIC_BASE_URL` to `http://localhost:4000` and masks authentication requirements using a dummy local master token key (`sk-litellm-local`).

## Available Models & Mappings

The proxy dynamically tracks and hot-swaps incoming requests into these free flagship open-weight mirrors:

| Claude Expected Model Slot | Target NVIDIA NIM Infrastructure Model | Architecture Specs |
| :--- | :--- | :--- |
| **`claude-sonnet-4-6`** | `nvidia_nim/qwen/qwen3.5-122b-a10b` | Mixture of Experts (10B active), elite layout/syntax tracking. |
| **`claude-opus-4-6`** | `nvidia_nim/z-ai/glm5` | 744B MoE, deep algorithmic logic and multi-file tracking. |
| **`claude-haiku-4-5`** | `nvidia_nim/moonshotai/kimi-k2.5` | 1-Trillion Parameter MoE, fast boilerplate execution. |

## Troubleshooting & Diagnostics

If the CLI throws formatting blocks or drops connection lines, test the internal container endpoints directly from your shell:

### Check Container Engine Logs
```bash
docker logs -f litellm-nim

```

### Validate Local Mapping Resolution

```bash
curl http://localhost:4000/v1/models -H "Authorization: Bearer sk-litellm-local"

```

### Check Decrypted Secret Generation (Root required)

```bash
sudo cat /run/secrets/NVIDIA_NIM_API_KEY

```

*(If empty or throwing errors, make sure your local `secrets/secrets.yaml` is tracked by git via `git add` before rebuilding).*
