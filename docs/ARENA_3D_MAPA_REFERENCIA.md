# Arena 3D: mapa provisório local

## Resultado

O mapa completo `mjolnir_01` foi convertido a partir de `C:\Gravity\Ragnarok Online\data.grf` usando o [ragx](https://github.com/joaopedrosgs/ragx). O GLB visual ocupa cerca de 20 MB. Uma segunda exportação do GAT gera apenas as células caminháveis, usadas como colisão estática. Ambos vêm da mesma instalação do cliente.

A cena `scenes/experimental/ragnarok_map_reference.tscn` instancia esses arquivos, o Espadachim de teste e uma câmera inclinada. É independente da arena 2D e da graybox 3D anterior. WASD move o personagem; segurar C amplia a visão. Ao cair abaixo do mapa, o personagem retorna ao ponto inicial. Não há combate nesta cena.

## Arquivos locais

Coloque os seguintes arquivos em `assets/experimental/ro_reference/`:

- `mjolnir_01.glb`: cenário completo exportado pelo ragx com `--format glb --world-scale 0.2`.
- `mjolnir_01_nav.gltf` e `mjolnir_01_nav.bin`: superfície caminhável gerada por `MapBuilder.build_nav_gltf()` com a mesma escala e cliente.

A pasta está no `.gitignore`. Os arquivos originais e convertidos do Ragnarok pertencem à Gravity e não são incluídos no GitHub, na build web ou em APKs. A cena exibe uma mensagem se eles não estiverem presentes.

## Verificação

```text
godot --headless --path . --script res://tests/ragnarok_map_reference_smoke.gd
godot --path . --scene res://scenes/experimental/ragnarok_map_reference.tscn
```

O teste automatizado conferiu carregamento do mapa, malha de colisão GAT, ator apoiado no chão e câmera. A navegação em trilhas, pontes e diferentes alturas ainda precisa de teste manual. A malha GAT delimita o piso caminhável; objetos decorativos não possuem colisores individuais. A conversão visual tem milhares de nós e ainda não foi avaliada para Android.
