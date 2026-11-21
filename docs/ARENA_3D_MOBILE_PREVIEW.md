# Prévia mobile da arena 3D fechada

Cena: `scenes/experimental/arena_3d_mobile_preview.tscn`.

Esta prévia usa uma arena autoral provisória com três patamares, rampas, rochas e bordas fechadas. Não usa os mapas ou modelos do cliente Ragnarok. O GLB do Espadachim foi fornecido pelo responsável; o mesmo arquivo serve de base à caminhada e ao golpe animados provisoriamente pelo Godot.

## Controles

- Celular em paisagem: arraste o controle à esquerda para andar. A barra no canto inferior direito tem ataque básico e os ícones de Proteção, Cura e Determinação. Os três atalhos acima usam poção de HP, elixir e poção de força. **ALVO** alterna entre os três bonecos de treino.
- O minimapa no canto superior direito mostra os três patamares, o personagem e os alvos. Arraste uma região livre da tela para girar a câmera; use dois dedos ou os botões **+** e **-** para aproximar e afastar.
- Desktop: WASD, teclas 1–3 para alvos, Espaço para atacar, Q/E/F para as três habilidades, botão direito do mouse para girar e roda para zoom. C aproxima a câmera.
- O golpe causa 20 de dano ao alvo selecionado se estiver até 3,5 unidades de distância, com diferença de altura de até 1,2 unidade e sem rocha ou parede no caminho. Determinação acrescenta 10 de dano por 10 segundos. Cada alvo tem 100 HP e reinicia ao ser derrotado. Cura recupera 25 HP de teste; Proteção mostra um efeito temporário. Estes números servem apenas à prévia e não mudam o combate da arena 2D.

## Publicação e limites

Prévia web: https://lrfsousa.github.io/RagArena/preview-3d-arena/. A cena 3D agora é a entrada principal do projeto. A exportação Web usa uma cópia mínima com apenas a arena 3D e seus recursos. Os arquivos locais de `assets/experimental/ro_reference/` não entram no pacote público. O download inicial soma cerca de 69 MB de arquivos Web, incluindo o runtime do Godot.

O combate ainda usa bonecos estáticos, sem bots, inventário persistente, progressão, partida, rede ou balanceamento definitivo. As poções da prévia são estoques locais de teste. O código 2D legado permanece no repositório para servir de referência durante a migração, mas deixa de ser a cena inicial. O toque e o desempenho precisam ser conferidos em celular real.
