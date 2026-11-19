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

O repositório de origem está privado. A [documentação do GitHub Pages](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site) informa que Pages em repositórios privados depende do plano da conta e que o site costuma ser público. A publicação precisa ser confirmada antes de expor esta build na internet.

## Limites de validação

A exportação e a integridade do WebAssembly foram verificadas localmente. Ainda falta abrir a página em um navegador real e conferir controles por toque e desempenho em celular.
