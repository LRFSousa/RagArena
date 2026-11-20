# Preparação do mapa para 3D

Análise da cena isolada de montanha, seus arquivos, testes e impacto: `docs/ARENA_3D_EXPERIMENTAL_ANALISE.md`. Nenhuma cena 3D foi incorporada ainda.

O layout lógico da Arena está em `scripts/arena_map_layout.gd`: tamanho do mundo, área jogável, cinco pontos de spawn, 17 paredes e 24 caixas. `arena.gd` instancia a representação 2D desses dados; `match_controller.gd` usa os mesmos limites e spawns. Assim, a geometria não precisa ser redigitada ao criar uma cena `Node3D`.

## Convenção de coordenadas

- `Vector2(x, y)` representa uma posição no chão. Em 3D, corresponde a `Vector3(x, altura, y)`; o eixo vertical passa a ser o Y de `Vector3`.
- `ground_to_3d()` converte uma posição; `footprint_to_3d()` converte largura e profundidade em dimensões X/Z com altura explícita.
- As coordenadas atuais permanecem em unidades lógicas do jogo. A escala física, altura das paredes, altura da câmera e ângulo de projeção serão definidos em um protótipo 3D antes de substituir a cena jogável.

## Próxima implementação

Criar uma cena 3D separada que leia `ArenaMapLayout`, instancie chão, paredes e caixas com colisão 3D e projete a posição do jogador no mesmo plano. Depois adaptar câmera, movimento, seleção por toque (raio da câmera ao chão), navegação, golpes e minimapa. A cena 2D continua sendo a versão jogável até esses sistemas e o desempenho mobile serem validados. Não misturar física 2D e 3D na mesma partida.

`tests/map_layout_smoke.gd` verifica contagens, dimensões, spawns, ligação da cena atual e conversão de coordenadas. Esse teste não valida renderização ou colisão 3D, que ainda não foram implementadas.
