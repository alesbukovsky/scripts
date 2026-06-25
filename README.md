# Scripts and Tools

A grab-bag of personal CLI utilities.

- **`bin/`** — standalone, single-file scripts. Self-contained, just copy one
  wherever you need it.
- **`tools/`** — multi-file Python projects with dependencies. Each is its own
  [uv](https://docs.astral.sh/uv/) project; install with `uv tool install ./tools/<name>`.

## `bin/`

| Script | Description |
| --- | --- |
| [`aes.sh`](bin/aes.sh) | Passphrase-based file encryption. |
| [`catalog.groovy`](bin/catalog.groovy) | Organizes JPEGs by EXIF timestamp. |
| [`llm.sh`](bin/llm.sh) | Launch an LLM locally via Ollama. |
| [`pdfcut.sh`](bin/pdfcut.sh) | Split a large PDF by page ranges. |

## `tools/`

| Tool | Description |
| --- | --- |
| [`tiler`](tools/tiler) | Slice a large image into US Legal-sized tiles and stitch into a PDF. |
