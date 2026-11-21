# Arena 3D: mapa provisório local

## Resultado

O mapa completo `mjolnir_01` foi convertido a partir de `C:\Gravity\Ragnarok Online\data.grf` usando o [ragx](https://github.com/joaopedrosgs/ragx). O GLB visual ocupa cerca de 20 MB. Uma segunda exportação do GAT gera apenas as células caminháveis, usadas como colisão estática. Ambos vêm da mesma instalação do cliente.

A cena `scenes/experimental/ragnarok_map_reference.tscn` instancia esses arquivos, o Espadachim de teste e uma câmera inclinada com órbita de 360° e zoom. É independente da arena 2D e da graybox 3D anterior. Se `assets/characters/swordsman/Espadachim.glb` estiver disponível, usa o modelo 3D do usuário com altura ajustada ao colisor; caso contrário, exibe o sprite anterior. A tecla T alterna as duas visualizações. WASD move o personagem em relação à direção atual da câmera; botão direito do mouse arrastado gira a câmera; a roda aproxima ou afasta. Em tela sensível ao toque, arrastar com um dedo gira e o gesto de pinça controla o zoom. Ao cair abaixo do mapa, o personagem retorna ao ponto inicial. Não há combate nesta cena.

## Arquivos locais

Coloque os seguintes arquivos em `assets/experimental/ro_reference/`:

- `mjolnir_01.glb`: cenário completo exportado pelo ragx com `--format glb --world-scale 0.2`.
- `mjolnir_01_nav.gltf` e `mjolnir_01_nav.bin`: superfície caminhável gerada por `MapBuilder.build_nav_gltf()` com a mesma escala e cliente.

A pasta está no `.gitignore`. Os arquivos originais e convertidos do Ragnarok pertencem à Gravity e não são incluídos no GitHub, na build web ou em APKs. A cena exibe uma mensagem se eles não estiverem presentes.

Os arquivos `Espadachim.glb`, `Espadachim Caminhando.glb` e `Espadachim Atacando.glb` foram gerados pelo usuário no Tripo AI e mantidos localmente para esta prévia, evitando aumentar o download do jogo. Os dois GLBs novos possuem esqueleto, mas não contêm trilhas de animação; suas malhas, poses e dados binários são iguais. O Godot aplica uma caminhada e um golpe provisórios aos ossos, troca o modelo usado durante o golpe e desenha um arco dourado de teste. Use WASD para caminhar e Espaço ou clique esquerdo para acionar o golpe visual. Essa ação não causa dano nem modifica o combate da arena. Os GLBs rigados não exibiram uma espada na prévia; o equipamento precisa ser conferido no arquivo exportado.

## Verificação

```text
godot --headless --path . --script res://tests/ragnarok_map_reference_smoke.gd
godot --path . --scene res://scenes/experimental/ragnarok_map_reference.tscn
```

O teste automatizado conferiu carregamento do mapa, malha de colisão GAT, modelos 3D quando presentes, alternância com sprite, poses de caminhada e ataque, retorno ao modelo de caminhada, ator apoiado no chão, órbita, limites de zoom e movimento relativo à câmera em diferentes ângulos. A navegação em trilhas, pontes e diferentes alturas ainda precisa de teste manual. A malha GAT delimita o piso caminhável; objetos decorativos não possuem colisores individuais. A conversão visual tem milhares de nós e ainda não foi avaliada para Android.
