Llama.CPP in Docker and config for VSCode Continue plugin
==

Note: **I'm just testing. This is highly experimental!**

## Hardware recomendado

Modelos orientados a laptops con **~16GB de RAM libre** y GPU integrada (iGPU) que
comparte la memoria del sistema. Probado en: Ryzen 5 5500U + Radeon Vega 7 + 30GB RAM.

- Con `--gpu-layers` la iGPU se usa vía Vulkan (muy útil para modelos <=14B).
- Evita modelos >10GB de pesos si tienes poca RAM libre: la iGPU no tiene VRAM propia
  y todo se mapea a la RAM del sistema.

## Modelos incluidos

| Archivo | Tamaño | Uso |
|---|---|---|
| `qwen2.5-coder-1.5b-instruct-q4_k_m.gguf` | 1.1GB | Autocompletado (VSCode) |
| `qwen2.5-coder-7b-instruct-q4_k_m.gguf` | 4.7GB | Código / edición / chat |
| `Qwen3-8B-Q4_K_M.gguf` | 5.0GB | Chat general / agente |

## Uso

0. Install [Docker+Docker-Compose](https://gist.github.com/Koratsuki/cb4e065e8fe7ad3ea3cf34df9bd25c94).
1. Download the models:

```bash
./download-models.sh
```

   (coloca archivos `.gguf` en `./models` si lo prefieres manualmente)
2. Run:

```bash
docker-compose up -d
```

3. Verify the server is up:

```bash
curl http://localhost:8080/health
# {"status":"ok", ...}  o carga del modelo en curso
```

4. Example Continue plugin config for Visual Studio Code inside `./vscode/config.yaml`.

5. Testing models

| ![Image 1. Testing models. ](imgs/models.png) |
|:--:|
| *Image 1. Testing models.* |

## Tips

- El nombre del modelo en la API es el **nombre del archivo sin `.gguf`** (p.ej.
  `qwen2.5-coder-7b-instruct-q4_k_m`). Si renombras archivos, ajusta `vscode/config.yaml`.
- Si el contenedor no acelera por GPU, revisa los logs con `docker-compose logs llama`
  (Vulkan debe aparecer como backend). Con una sola iGPU el device es `0`.

References:
==

[1] https://github.com/ggml-org/llama.cpp/blob/master/docs/docker.md

[2] https://github.com/ggml-org/llama.cpp#obtaining-and-quantizing-models

[3] https://coffeejourneys.blog/home-lab-local-llms-docker-amd/

[4] https://dev.to/hrodrig/21-toks-gemma-4-on-a-ryzen-mini-pc-llamacpp-vulkan-and-the-messy-truth-about-local-chat-m82