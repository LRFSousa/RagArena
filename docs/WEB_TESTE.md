# Teste do RagnArena no navegador

A release 0.5 pode ser exportada para Web com o preset `Web` de `export_presets.cfg`. O projeto usa o renderer Compatibility e exportação sem threads, adequada a hospedagem estática.

## Gerar

Instale Godot 4.7.2 e seus templates Web da mesma versão. Na raiz do projeto:

```text
godot --headless --path . --editor --quit
godot --headless --path . --export-release Web web_build/index.html
```

Sirva a pasta `web_build` por HTTP/HTTPS; abrir `index.html` diretamente como `file://` não é um teste válido. O jogo carrega arquivos `index.js`, `index.wasm` e `index.pck` além da página HTML.

## GitHub Pages

Prévia isolada da release 0.7 (câmera e mapa ampliado): https://lrfsousa.github.io/RagArena/preview-07/. Abra no celular em paisagem. A página principal continua na versão estável 0.5.2. A prévia usa o mesmo fluxo local de personagem e configuração antes da Arena.

Revisão do minimapa no canto superior direito e golpe de dois quadros: https://lrfsousa.github.io/RagArena/preview-07-range2/. O endereço separado evita carregar o pacote antigo do cache e permite comparar as duas versões.

Prévia dos quatro sprites de caminhada do Espadachim: https://lrfsousa.github.io/RagArena/preview-07-swordsman/. Crie um personagem da classe Paladino para testar o visual provisório. A animação muda conforme a direção do movimento.

Prévia com o salto entre quadros corrigido: https://lrfsousa.github.io/RagArena/preview-07-swordsman-aligned/. Use este endereço para conferir o alinhamento atualizado.

Prévia do HUD mobile com itens acima das habilidades no canto inferior direito: https://lrfsousa.github.io/RagArena/preview-07-mobile-hud/. Abra em paisagem, crie ou selecione um personagem Paladino e entre na Arena.

Prévia dos efeitos do Espadachim: https://lrfsousa.github.io/RagArena/preview-07-swordsman-effects/. Selecione Paladino; use o ataque básico e os botões Q (Proteção Divina), E (Cura) e F (Determinação).

Prévia com os ícones das quatro ações enviados pelo responsável: https://lrfsousa.github.io/RagArena/preview-07-swordsman-icons/. Abra em paisagem e selecione Paladino.

Os arquivos exportados podem ser colocados na raiz de um branch `gh-pages`, junto com `.nojekyll`. Depois, em **Settings → Pages**, escolha esse branch como origem. O endereço público é `https://lrfsousa.github.io/RagArena/`.

O repositório `LRFSousa/RagArena` foi tornado público por autorização do responsável em 19/11/2026. O Pages usa a branch `gh-pages` e está disponível em https://lrfsousa.github.io/RagArena/.

## Limites de validação

Na versão 0.5.2, bots disparam projéteis vermelhos; o HP só deve diminuir após impacto.

O perfil local usa os dados do navegador. Abrir em outro navegador ou limpar os dados cria um perfil separado.

Se o teclado do celular não abrir ao tocar no campo de nome, use **Teclado na tela**, digite e toque em **Concluir**. O mesmo controle está disponível ao nomear configurações.

Na versão 0.5.1 publicada, o botão abriu o teclado no navegador integrado e toques nas letras preencheram o campo de nome. A ergonomia em celular real ainda precisa de validação.

A exportação, a integridade do WebAssembly e o carregamento público dos arquivos foram verificados. A tela de criação do personagem da 0.5 renderizou no navegador integrado; o fluxo completo passou em testes headless. Ainda falta validar toda a navegação no navegador e os controles por toque e desempenho em celular real em paisagem.
