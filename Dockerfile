
ARG BASE_IMAGE=vllm/vllm-openai:v0.25.0
FROM ${BASE_IMAGE}

ARG VLLM_OMNI_VERSION=main

WORKDIR /app

RUN apt-get update && \
    apt-get install -y git jq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch "${VLLM_OMNI_VERSION}" \
    https://github.com/vllm-project/vllm-omni.git /app/vllm-omni

RUN cd /app/vllm-omni && \
    uv pip install --python "$(python3 -c 'import sys; print(sys.executable)')" --no-cache-dir "."

RUN ln -sf /usr/bin/python3 /usr/bin/python

ENTRYPOINT []
