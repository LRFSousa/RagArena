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

Arena 3D com barra de habilidades, poções, minimapa e câmera orbital: https://lrfsousa.github.io/RagArena/arena-3d-mobile/. Abra em paisagem. Use o controle esquerdo para andar, arraste uma região livre para girar, use pinça ou +/− para zoom. O cenário é provisório e autoral; os mapas do cliente Ragnarok continuam fora do pacote público.

Teste da Arena01 de 160 × 160 m: https://lrfsousa.github.io/RagArena/arena01-playtest/. Mantém os mesmos controles e inclui os dois morros com rampas, ruínas, cercas, rochas e três alvos. O zoom máximo enquadra toda a arena. Toque em **EXP teste** para receber uma recompensa simulada e em **Atributos** para distribuir pontos; feche e reabra a página para conferir persistência local. Veja `docs/ARENA01_VALIDACAO.md` e `docs/RELATORIOS/RELATORIO_ATRIBUTOS_V1.md`.

No computador, use o clique esquerdo nos ícones de ataque, habilidades, poções, alvo e zoom. O botão direito do mouse gira a câmera e a roda aproxima ou afasta; WASD move o personagem.

Prévia histórica da release 0.7 em 2D: https://lrfsousa.github.io/RagArena/preview-07/. A página principal agora inicia a arena 3D; esta prévia antiga permanece apenas para comparação.

Revisão do minimapa no canto superior direito e golpe de dois quadros: https://lrfsousa.github.io/RagArena/preview-07-range2/. O endereço separado evita carregar o pacote antigo do cache e permite comparar as duas versões.

Prévia dos quatro sprites de caminhada do Espadachim: https://lrfsousa.github.io/RagArena/preview-07-swordsman/. Crie um personagem da classe Paladino para testar o visual provisório. A animação muda conforme a direção do movimento.

Prévia com o salto entre quadros corrigido: https://lrfsousa.github.io/RagArena/preview-07-swordsman-aligned/. Use este endereço para conferir o alinhamento atualizado.

Prévia do HUD mobile com itens acima das habilidades no canto inferior direito: https://lrfsousa.github.io/RagArena/preview-07-mobile-hud/. Abra em paisagem, crie ou selecione um personagem Paladino e entre na Arena.

Prévia dos efeitos do Espadachim: https://lrfsousa.github.io/RagArena/preview-07-swordsman-effects/. Selecione Paladino; use o ataque básico e os botões Q (Proteção Divina), E (Cura) e F (Determinação).

Prévia com os ícones das quatro ações enviados pelo responsável: https://lrfsousa.github.io/RagArena/preview-07-swordsman-icons/. Abra em paisagem e selecione Paladino.

Prévia dos controles mobile circulares: https://lrfsousa.github.io/RagArena/preview-07-mobile-controls/. Poções acima, Q/E/F em diagonal e ataque maior à direita. Abra em paisagem e selecione Paladino.

Prévia com câmera mais próxima (zoom 1,05): https://lrfsousa.github.io/RagArena/preview-07-zoom105/. Compare com a prévia anterior (zoom 0,85) no mesmo celular.

Prévia com o Espadachim em tamanho dobrado e câmera mantida em 1,05: https://lrfsousa.github.io/RagArena/preview-07-swordsman-x2/. Selecione Paladino para conferir o sprite.

Prévia do ataque por seleção: https://lrfsousa.github.io/RagArena/preview-07-target-attack-final/. Toque numa caixa ou bot; o Paladino se aproxima e ataca. Também é possível usar o botão de ataque com o alvo selecionado.

Os arquivos exportados podem ser colocados na raiz de um branch `gh-pages`, junto com `.nojekyll`. Depois, em **Settings → Pages**, escolha esse branch como origem. O endereço público é `https://lrfsousa.github.io/RagArena/`.

O repositório `LRFSousa/RagArena` foi tornado público por autorização do responsável em 19/11/2026. O Pages usa a branch `gh-pages` e está disponível em https://lrfsousa.github.io/RagArena/.

## Limites de validação

Na versão 0.5.2, bots disparam projéteis vermelhos; o HP só deve diminuir após impacto.

O perfil local usa os dados do navegador. Abrir em outro navegador ou limpar os dados cria um perfil separado.

Se o teclado do celular não abrir ao tocar no campo de nome, use **Teclado na tela**, digite e toque em **Concluir**. O mesmo controle está disponível ao nomear configurações.

Na versão 0.5.1 publicada, o botão abriu o teclado no navegador integrado e toques nas letras preencheram o campo de nome. A ergonomia em celular real ainda precisa de validação.

A exportação, a integridade do WebAssembly e o carregamento público dos arquivos foram verificados. A tela de criação do personagem da 0.5 renderizou no navegador integrado; o fluxo completo passou em testes headless. Ainda falta validar toda a navegação no navegador e os controles por toque e desempenho em celular real em paisagem.
