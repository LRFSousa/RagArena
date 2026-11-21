# Arena 3D: mapa provisório local

## Resultado

O mapa completo `mjolnir_01` foi convertido a partir de `C:\Gravity\Ragnarok Online\data.grf` usando o [ragx](https://github.com/joaopedrosgs/ragx). O GLB visual ocupa cerca de 20 MB. Uma segunda exportação do GAT gera apenas as células caminháveis, usadas como colisão estática. Ambos vêm da mesma instalação do cliente.

A cena `scenes/experimental/ragnarok_map_reference.tscn` instancia esses arquivos, o Espadachim de teste e uma câmera inclinada com órbita de 360° e zoom. É independente da arena 2D e da graybox 3D anterior. Se `assets/characters/swordsman/Espadachim.glb` estiver disponível, usa o modelo 3D do usuário com altura ajustada ao colisor; caso contrário, exibe o sprite anterior. A tecla T alterna as duas visualizações. WASD move o personagem em relação à direção atual da câmera; botão direito do mouse arrastado gira a câmera; a roda aproxima ou afasta. Em tela sensível ao toque, arrastar com um dedo gira e o gesto de pinça controla o zoom. Ao cair abaixo do mapa, o personagem retorna ao ponto inicial. Não há combate nesta cena.

## Arquivos locais

Coloque os seguintes arquivos em `assets/experimental/ro_reference/`:

- `mjolnir_01.glb`: cenário completo exportado pelo ragx com `--format glb --world-scale 0.2`.
- `mjolnir_01_nav.gltf` e `mjolnir_01_nav.bin`: superfície caminhável gerada por `MapBuilder.build_nav_gltf()` com a mesma escala e cliente.
- `mjolnir_02.glb`, `mjolnir_02_nav.gltf` e `mjolnir_02_nav.bin`: mapa vizinho e sua malha caminhável, exportados do mesmo cliente e com a mesma escala.
- `prontera.glb`, `prontera_nav.gltf` e `prontera_nav.bin`: cidade e sua malha caminhável para a cena experimental `scenes/experimental/prontera_reference.tscn`.

A pasta está no `.gitignore`. Os arquivos originais e convertidos do Ragnarok pertencem à Gravity e não são incluídos no GitHub, na build web ou em APKs. A cena exibe uma mensagem se eles não estiverem presentes.

Os arquivos `Espadachim.glb`, `Espadachim Caminhando.glb` e `Espadachim Atacando.glb` foram gerados pelo usuário no Tripo AI e mantidos localmente para esta prévia, evitando aumentar o download do jogo. Os dois GLBs novos possuem esqueleto, mas não contêm trilhas de animação; suas malhas, poses e dados binários são iguais. O Godot aplica uma caminhada e um golpe provisórios aos ossos, troca o modelo usado durante o golpe e desenha um arco dourado de teste. Use WASD para caminhar e Espaço ou clique esquerdo para acionar o golpe visual. Essa ação não causa dano nem modifica o combate da arena. Os GLBs rigados não exibiram uma espada na prévia; o equipamento precisa ser conferido no arquivo exportado.

## Verificação

```text
godot --headless --path . --script res://tests/ragnarok_map_reference_smoke.gd
godot --headless --path . --script res://tests/map_portals_smoke.gd
godot --path . --scene res://scenes/experimental/ragnarok_map_reference.tscn
godot --path . --scene res://scenes/experimental/prontera_reference.tscn
```

O teste automatizado conferiu carregamento do mapa, malha de colisão GAT, modelos 3D quando presentes, alternância com sprite, poses de caminhada e ataque, retorno ao modelo de caminhada, ator apoiado no chão, órbita, limites de zoom e movimento relativo à câmera em diferentes ângulos.

## Limites de navegação experimental

- O personagem permanece no nível de altura em que nasceu. O piso à frente é consultado antes de cada passo; bordas, morros e mudanças de nível sem passagem designada bloqueiam o movimento. Futuras rampas e escadas deverão ser cadastradas como passagens explícitas.
- `mjolnir_01` já contém seu mapa inteiro. A ponte a leste termina no limite do arquivo e no Ragnarok leva ao mapa vizinho `mjolnir_02`; não há terreno inferior dentro de `mjolnir_01` depois dessa borda. A extremidade da ponte agora aciona a transição para o outro mapa, com retorno pela ponte correspondente. Ambos os mapas são carregados inteiros, um de cada vez, sem modificar seus modelos visuais. As duas pontes desse acesso têm piso de colisão segmentado. A ponte principal é a única passagem de altura habilitada nesta prévia.
- Folhagens rasteiras identificadas no mapa como arbustos, mato, grama ou trepadeiras amarelas são atravessáveis (altura visual aproximada até o joelho). Flores altas, árvores, barris e outros modelos sólidos continuam com áreas circulares provisórias de bloqueio. O personagem pode se afastar caso já esteja dentro de uma área, evitando ficar preso ao tocar uma flor. A tecla **R** o devolve à última posição segura, e uma queda também aciona essa recuperação.
- O ponto inicial é escolhido somente quando há piso livre ao redor. A classificação da vegetação usa os nomes dos modelos importados, pois a conversão não fornece uma altura de colisão confiável por objeto. Uma folhagem sobre a borda de um penhasco não torna a borda atravessável. As áreas circulares são aproximações: ainda é necessário conferir manualmente a ponte inteira, rampas futuras e o contorno de cada objeto. A conversão visual tem milhares de nós e ainda não foi avaliada para Android.

## Prontera: casas e portais

A cena de Prontera exibe o mapa completo original com a superfície GAT caminhável e o Espadachim de teste. O cenário e o piso foram ampliados em **5×**, sem alterar o tamanho do personagem ou os arquivos GLB. A área caminhável passa de aproximadamente 62,4 × 78,4 para **312 × 392 unidades Godot**. As posições e áreas provisórias dos obstáculos acompanham a mesma escala. As paredes visuais das casas ainda não têm colisores ajustados às suas formas: o bloqueio provisório por posição de modelo não garante que portas sejam passáveis nem que todas as paredes sejam sólidas. O próximo passo é marcar cada parede externa e porta em dados separados do GLB, conferir as células GAT dentro das construções e definir volumes de portal com destino e ponto seguro de chegada. Nenhum portal de Prontera está ativo nesta etapa.
