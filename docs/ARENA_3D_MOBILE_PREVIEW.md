# Prévia mobile da arena 3D fechada

Cena: `scenes/experimental/arena_3d_mobile_preview.tscn`.

Esta prévia usa uma arena autoral provisória com três patamares, rampas, rochas e bordas fechadas. Não usa os mapas ou modelos do cliente Ragnarok. O GLB do Espadachim foi fornecido pelo responsável; o mesmo arquivo serve de base à caminhada e ao golpe animados provisoriamente pelo Godot.

## Controles

- Celular em paisagem: arraste o controle à esquerda para andar; use **ALVO** para alternar entre três bonecos de treino; **ATK** para golpear; **ESC**, **CURA** e **FOR** para testar Proteção, Cura e Determinação.
- Desktop: WASD, teclas 1–3 para alvos, Espaço para atacar, Q/E/F para as três habilidades e C para visão geral.
- O golpe causa 20 de dano ao alvo selecionado se estiver até 3,5 unidades de distância, com diferença de altura de até 1,2 unidade e sem rocha ou parede no caminho. Determinação acrescenta 10 de dano por 10 segundos. Cada alvo tem 100 HP e reinicia ao ser derrotado. Cura recupera 25 HP de teste; Proteção mostra um efeito temporário. Estes números servem apenas à prévia e não mudam o combate da arena 2D.

## Publicação e limites

Exportar a cena como `run/main_scene` de uma cópia temporária do projeto usando o preset Web. Publicar a exportação em uma pasta isolada do GitHub Pages para preservar o jogo 2D existente. Os arquivos locais de `assets/experimental/ro_reference/` nunca entram no pacote público.

O combate ainda usa bonecos estáticos, sem bots, inventário, progressão, partida, rede ou balanceamento definitivo. O toque e o desempenho precisam ser conferidos em celular real.
