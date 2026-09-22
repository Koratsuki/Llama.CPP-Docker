Llama.CPP in Docker and config for VSCode Continue plugin
==

Note: **I'm just testing. This is highly experimental!**

## Recommended hardware

Models targeted at laptops with **~16GB of free RAM** and integrated GPU (iGPU) that
shares system memory. Tested on: Ryzen 5 5500U + Radeon Vega 7 + 30GB RAM.

- With `--gpu-layers` the iGPU is used via Vulkan (very useful for models <=14B).
- Avoid models >10GB of weights if you have little free RAM: the iGPU has no dedicated VRAM
  and everything is mapped to system RAM.

## Included models

| Archivo | Tamaño | Uso |
|---|---|---|
| `qwen2.5-coder-1.5b-instruct-q4_k_m.gguf` | 1.1GB | Autocomplete (VSCode) |
| `qwen2.5-coder-7b-instruct-q4_k_m.gguf` | 4.7GB | Code / edit / chat |
| `Qwen3-8B-Q4_K_M.gguf` | 5.0GB | General chat / agent |

## Uso

0. Install [Docker+Docker-Compose](https://gist.github.com/Koratsuki/cb4e065e8fe7ad3ea3cf34df9bd25c94).
1. Download the models:

```bash
./download-models.sh
```

   (place `.gguf` files in `./models` if you prefer to do it manually)
2. Run:

```bash
docker-compose up -d
```

3. Verify the server is up:

```bash
curl http://localhost:8080/health
# {"status":"ok", ...}  or model loading in progress
```

4. Example Continue plugin config for Visual Studio Code inside `./vscode/config.yaml`.

5. Testing models

| ![Image 1. Testing models. ](imgs/models.png) |
|:--:|
| *Image 1. Testing models.* |

## Tips

- The model name in the API is the **file name without `.gguf`** (e.g.
  `qwen2.5-coder-7b-instruct-q4_k_m`). If you rename files, adjust `vscode/config.yaml`.
- If the container doesn't speed up via GPU, check the logs with `docker-compose logs llama`
  (Vulkan should appear as the backend). With a single iGPU the device is `0`.

References:
==

[1] https://github.com/ggml-org/llama.cpp/blob/master/docs/docker.md

[2] https://github.com/ggml-org/llama.cpp#obtaining-and-quantizing-models

[3] https://coffeejourneys.blog/home-lab-local-llms-docker-amd/

[4] https://dev.to/hrodrig/21-toks-gemma-4-on-a-ryzen-mini-pc-llamacpp-vulkan-and-the-messy-truth-about-local-chat-m82