# vLLM OpenAI GHCR mirror

This repository is a GitHub Container Registry (GHCR) mirror of the official
[`vllm/vllm-openai`](https://hub.docker.com/r/vllm/vllm-openai) container
images. Use the GHCR image as a drop-in replacement when you want to pull the
vLLM image from this repository instead of Docker Hub.

The images are copied as published. This repository does not rebuild, modify,
or maintain a separate vLLM implementation.

## Use the mirror

Replace the source image:

```text
docker.io/vllm/vllm-openai:<tag>
```

with the corresponding image from this repository:

```text
ghcr.io/<owner>/<repository>:<tag>
```

For this repository, the image name is:

```text
ghcr.io/valendra-tech/vllm-docker
```

### Available tags

The mirror currently publishes two CUDA variants for each vLLM version:

| CUDA variant | Docker Hub source tag | GHCR mirror tag |
| --- | --- | --- |
| CUDA 12.9 (`cu129`) | `v0.23.0-cu129-ubuntu2404` | `v0.23.0-cu129-ubuntu2404` |
| CUDA 13 (`cu13`) | `v0.23.0-ubuntu2404` | `v0.23.0-ubuntu2404` |

The tag is unchanged when the image is copied. Only the registry and image
owner/name change.

### Pull an image

```bash
docker pull ghcr.io/valendra-tech/vllm-docker:v0.23.0-cu129-ubuntu2404
docker pull ghcr.io/valendra-tech/vllm-docker:v0.23.0-ubuntu2404
```

For a reproducible pull, use an immutable digest reference:

```bash
docker pull ghcr.io/valendra-tech/vllm-docker@sha256:e37c8b17a13f0a4f294472b39281ca0405a5488f4ab0f395dbdc8147e8f2db7d
```

The general digest format is:

```text
ghcr.io/valendra-tech/vllm-docker@sha256:<digest>
```

Use the image with the normal vLLM Docker command, for example:

```bash
docker run --gpus all --ipc=host --network host \
  ghcr.io/valendra-tech/vllm-docker:v0.23.0-cu129-ubuntu2404 \
  --model <model-name>
```

For a private GHCR package, authenticate before pulling with a GitHub token
that has the `read:packages` permission:

```bash
echo "$CR_PAT" | docker login ghcr.io -u GITHUB_USER --password-stdin
```

## Keeping the mirror up to date

GitHub Actions keeps the GHCR package synchronized with Docker Hub:

- [Mirror vLLM version](.github/workflows/mirror-vllm.yml) manually mirrors a
  requested version. Enter `0.23.0` or `v0.23.0` in the **vllm_version** input.
- [Mirror latest vLLM image](.github/workflows/mirror-vllm-daily.yml) runs every
  day at `03:17 UTC`, finds the newest version with both CUDA tags, and mirrors
  both variants. It can also be started manually.
- [Mirror vLLM image](.github/workflows/mirror-vllm-reusable.yml) contains the
  shared copy logic and the `cu129`/`cu13` matrix.

The workflows use `GITHUB_TOKEN` and publish the package as
`ghcr.io/<owner>/<repository>`. The repository's Actions settings must allow
the workflow to write packages:

```yaml
permissions:
  contents: read
  packages: write
```
