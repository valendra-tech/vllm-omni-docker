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

For this repository, the image name is `ghcr.io/valendra/vllm-docker` when it
is published under the `valendra` owner.

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
docker pull ghcr.io/valendra/vllm-docker:v0.23.0-cu129-ubuntu2404
docker pull ghcr.io/valendra/vllm-docker:v0.23.0-ubuntu2404
```

Use the image with the normal vLLM Docker command, for example:

```bash
docker run --gpus all --ipc=host --network host \
  ghcr.io/valendra/vllm-docker:v0.23.0-cu129-ubuntu2404 \
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
