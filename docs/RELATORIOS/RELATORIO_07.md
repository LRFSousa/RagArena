# Relatório da release 0.7 — em desenvolvimento

## Implementado

- Minimap movido para o canto superior direito; interface jogável não mostra botões de depuração. O teclado de teste continua disponível em cenas de desenvolvimento.
- Golpe básico em linha alcança provisoriamente 152 unidades e percorre dois quadros, atingindo alvos alinhados uma vez cada. Paredes de pedra e fechamento barram o golpe.
- Etapa seguinte: mundo de 2560×1440 unidades, câmera seguindo o jogador com zoom 0,85 e limites de mapa, 24 caixas, spawns afastados e cobertura perto dos quatro cantos. O HUD continua fixo em coordenadas de tela.
- Minimap provisório mostra jogador e área segura sem expor a localização de oponentes.
- Primeira etapa do mapa maior: HUD desenhado em `CanvasLayer`, independente da câmera futura. Ataque visual continua no mundo; posições de controles e tamanho atual da arena foram mantidos.
- Guia de estilo provisório, fonte reproduzível e doze PNGs: quatro atlas de classes (64×64 por quadro, quatro colunas, cinco linhas), dois tiles 32×32 e seis ícones 16×16.
- Personagem usa quadros de parado, caminhada, ataque, dano e morte; classe selecionada troca o atlas. Caixas, paredes e itens usam texturas pixeladas.
- HUD reorganizado para HP, nível, XP, cronômetro, inventário, efeitos e recargas. Ataque e habilidades têm alvos de toque separados.
- Áudio sintético para impacto, coleta, habilidade e eliminação.
- A 0.6 foi colocada em espera a pedido do responsável; a 0.7 parte da versão estável 0.5.2.

## Testes

Godot 4.7.2 em modo headless: `release01_smoke`, `release02_smoke`, `release03_smoke`, `release04_smoke`, `release05_smoke` e `health_damage_regression` passaram com código de saída zero após integração visual. `release07_smoke` passou para atlas, troca de classe, quadros de ataque/dano/morte, HUD e separação dos botões de toque. A importação dos PNGs pelo editor Godot também foi executada.

Após separar o HUD, as mesmas sete suítes foram executadas novamente e passaram. `release07_smoke` agora verifica também que rótulos e controles pertencem ao `CanvasLayer`.

Após adicionar câmera e ampliar o mapa, as sete suítes passaram novamente com código de saída zero e sem `SCRIPT ERROR`/`ERROR` nos logs. A suíte 0.7 verifica câmera, tamanho do mundo, spawn fora da tela e toque de ataque após deslocar o personagem no mundo. A exportação Web do Godot 4.7.2 gerou `index.html`, `index.js`, `index.wasm` e `index.pck`.

Após a correção do alcance e minimapa, passaram também `tests/release07_attack_range.gd` e as sete suítes anteriores, todas sem erros nos logs. O teste novo cobre duas caixas, dois oponentes, terceiro quadro fora de alcance e parede entre os alvos.

A prévia foi publicada em `https://lrfsousa.github.io/RagArena/preview-07/` sem substituir a raiz estável. O fluxo `pages build and deployment` do commit `fd55d65` concluiu com sucesso. Página, `.pck` e `.wasm` responderam HTTP 200. O navegador integrado exibiu a tela de entrada local e não registrou erros de console; a navegação completa e o jogo em celular real ainda dependem de teste manual.

## Limites e problemas

- Os sprites são provisórios e de baixa complexidade. Ainda faltam efeitos visuais específicos de habilidades, variantes direcionais mais ricas e revisão artística.
- Testes headless não validam aparência final, desempenho, ergonomia nem áudio audível em Android. Uma tentativa de captura de viewport headless falhou porque esse modo usa renderizador sem textura de tela; isso não indica erro de execução do jogo.
- A release não está marcada como concluída até teste em aparelhos reais e resolução dos itens pendentes.
- O zoom 0,85, os novos spawns, 24 caixas e o fechamento de 480 unidades são provisórios. A câmera de espectador ainda não acompanha sobreviventes após eliminação.
