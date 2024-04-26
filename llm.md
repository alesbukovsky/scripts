# `llm.md`

_CAUTION: This script is specific to MacOS._

Launches a LLM locally using [Ollama](https://ollama.com). Starts `Ollama.app` if not running yet. Uses model specified in `DEFAULT_LLM` environment variable if none given explicitly. Downloads the model if not present locally. 

Prerequisites:

* [Ollama](https://ollama.com/download)

Usage:
```
llm.sh [model]
```

Options:

* `-h`, `--help`
        
    Show usage description.

* `[model]`
        
    Model to launch, defaults to `DEFAULT_LLM`.

Example:
```
llm llama3
```
