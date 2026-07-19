# vLLM-Omni GHCR mirror and multi-CUDA builds

This repository provides GitHub Container Registry (GHCR) images for
[vLLM-Omni](https://github.com/vllm-project/vllm-omni) in two ways:

1. **Mirror** — copies the official `vllm/vllm-omni` images from Docker Hub as-is.
2. **Multi-CUDA builds** — builds vLLM-Omni on top of different CUDA base images, producing variants that the upstream does not publish (CUDA 12.9 and CUDA 13).

Use the GHCR image as a drop-in replacement when you want to pull from this
repository instead of Docker Hub, or when you need a CUDA variant not available
upstream.

## Available images

The repository publishes images at:

```text
ghcr.io/valendra-tech/vllm-omni-docker
```

### Mirrored images (official upstream)

These are copied unchanged from `docker.io/vllm/vllm-omni`:

| Tag | Source |
| --- | --- |
| `v0.24.0` | `vllm/vllm-omni:v0.24.0` |
| `v0.22.0` | `vllm/vllm-omni:v0.22.0` |
| `latest` | `vllm/vllm-omni:latest` |
| `cosmos3` | `vllm/vllm-omni:cosmos3` |

All mirrored tags are multi-arch (amd64, arm64).

### Multi-CUDA build images

Built from vLLM-Omni source on top of `vllm/vllm-openai` base images with
different CUDA variants. These are **not** published upstream.

| CUDA variant | Tag example |
| --- | --- |
| CUDA 12.9 (`cu129`) | `v0.24.0-cu129` |
| CUDA 13 (`cu13`) | `v0.24.0-cu13` |

## Pull an image

```bash
docker pull ghcr.io/valendra-tech/vllm-omni-docker:v0.24.0
docker pull ghcr.io/valendra-tech/vllm-omni-docker:v0.24.0-cu129
docker pull ghcr.io/valendra-tech/vllm-omni-docker:v0.24.0-cu13
```

For a private GHCR package, authenticate before pulling:

```bash
echo "$CR_PAT" | docker login ghcr.io -u GITHUB_USER --password-stdin
```

## Run

```bash
docker run --gpus all --ipc=host --network host \
  ghcr.io/valendra-tech/vllm-omni-docker:v0.24.0-cu129 \
  --model <model-name>
```

## Keeping images up to date

### Mirror workflows

- [Mirror vLLM-Omni reference](.github/workflows/mirror-vllm.yml) — manually
  mirror a requested tag. Enter `v0.24.0`, `0.24.0`, `cosmos3`, or `latest`.
- [Mirror latest vLLM-Omni image](.github/workflows/mirror-vllm-daily.yml) —
  runs daily at `03:17 UTC`, finds the newest release tag and mirrors it. Can
  also be started manually.
- [Mirror vLLM-Omni image](.github/workflows/mirror-vllm-reusable.yml) —
  reusable copy logic shared by the workflows above.

### Build workflow (multi-CUDA)

- [Build vLLM-Omni multi-CUDA](.github/workflows/build.yml) — builds vLLM-Omni
  for multiple CUDA variants in parallel using a matrix. Inputs:
  - `vllm_omni_version`: git tag or branch to clone (default: `v0.24.0`)
  - `vllm_base_version`: matching vLLM base version (default: `0.24.0`)

The build workflow produces two images per vLLM-Omni version:

| CUDA | Tag | Base image |
| --- | --- | --- |
| CUDA 12.9 | `v0.24.0-cu129` | `vllm/vllm-openai:v0.24.0-cu129-ubuntu2404` |
| CUDA 13 | `v0.24.0-cu13` | `vllm/vllm-openai:v0.24.0-ubuntu2404` |

## How the Dockerfile works

The `Dockerfile` at the repository root:

1. Starts from a `vllm/vllm-openai` base image with the target CUDA version.
2. Clones the vLLM-Omni source at the requested version.
3. Installs the vLLM-Omni Python package on top.

The vLLM base image provides the CUDA toolkit, PyTorch, and vLLM core. The
vLLM-Omni layer adds omni-modality support (audio, image/video, TTS, diffusion,
robot policies).

Build args:

| Arg | Default | Description |
| --- | --- | --- |
| `VLLM_OMNI_VERSION` | `main` | vLLM-Omni git tag or branch |
| `BASE_IMAGE` | `vllm/vllm-openai:v0.25.0` | vLLM base image with CUDA variant |
