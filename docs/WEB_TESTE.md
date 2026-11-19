# Teste do RagnArena no navegador

A release 0.1 pode ser exportada para Web com o preset `Web` de `export_presets.cfg`. O projeto usa o renderer Compatibility e exportação sem threads, adequada a hospedagem estática.

## Gerar

Instale Godot 4.7.2 e seus templates Web da mesma versão. Na raiz do projeto:

```text
godot --headless --path . --editor --quit
godot --headless --path . --export-release Web web_build/index.html
```

Sirva a pasta `web_build` por HTTP/HTTPS; abrir `index.html` diretamente como `file://` não é um teste válido. O jogo carrega arquivos `index.js`, `index.wasm` e `index.pck` além da página HTML.

## GitHub Pages

Os arquivos exportados podem ser colocados na raiz de um branch `gh-pages`, junto com `.nojekyll`. Depois, em **Settings → Pages**, escolha esse branch como origem. O endereço esperado é `https://lrfsousa.github.io/RagArena/`, mas só estará válido após publicação bem-sucedida.

O repositório `LRFSousa/RagArena` foi tornado público por autorização do responsável em 19/11/2026. O Pages usa a branch `gh-pages` e está disponível em https://lrfsousa.github.io/RagArena/.

## Limites de validação

A exportação, a integridade do WebAssembly, o carregamento público dos arquivos e a renderização da arena no navegador integrado foram verificados. O console não mostrou erros. Ainda falta validar controles por toque e desempenho em celular real em paisagem.
