ifneq ($(wildcard .env),)
    include .env
    export
endif

PORT ?= 10080
CTX_SIZE ?= 32768
N_GL ?= 40
MODEL_ALIAS ?= llama_model

.PHONY: run-llm run-llm-cli help

help:
	@echo "Usage:"
	@echo "  make run-llm     - Start HTTP server (llama serve)"
	@echo "  make run-llm-cli - Launch terminal chat (llama cli)"

## run-llm HTTP/WebUI server via unified llama binary
run-llm:
	@mkdir -p "$(MODEL_DIR)"
	@echo "Starting llama serve..."
	@echo "Model: $(MODEL_ID)"
	@echo "Cache Directory: $(MODEL_DIR)"
	LLAMA_CACHE="$(MODEL_DIR)" HF_HOME="$(MODEL_DIR)" llama serve \
		-hf "$(MODEL_ID)" -a "$(MODEL_ALIAS)" \
		-t 6 \
		-c $(CTX_SIZE) \
		--port $(PORT) \
		--host 0.0.0.0 \
		--cache-type-k q4_0 \
		--cache-type-v q4_0 \
		--no-mmproj \
		--flash-attn on \
		--load-mode none

## run-llm interactive terminal chat via unified llama binary
run-llm-cli:
	@mkdir -p "$(MODEL_DIR)"
	LLAMA_CACHE="$(MODEL_DIR)" HF_HOME="$(MODEL_DIR)" llama cli \
		-hf "$(MODEL_ID)" \
		-c $(CTX_SIZE) \
		-t 8 \
		--cache-type-k q4_0 \
		--cache-type-v q4_0 \
		--flash-attn on \
		--load-mode none
