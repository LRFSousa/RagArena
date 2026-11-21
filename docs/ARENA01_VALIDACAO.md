# Validação da Arena01

A cena `scenes/Arena01.tscn`, criada pelo responsável, é agora a cena inicial do protótipo 3D. A versão de desenvolvimento liga o Espadachim, câmera orbital, controles mobile, minimapa, três alvos de treino, ataque básico, Proteção, Cura, Determinação e poções locais de teste. A versão jogável tem 160 × 160 m; `scenes/Arena01_80x80_backup.tscn` e `scripts/experimental/arena01_playtest_80x80_backup.gd` preservam a versão anterior.

## Ajustes necessários para jogar

- Ativadas colisões nas formas CSG: piso, morros, rampas, ruínas, cercas e rochas. Antes, vários objetos eram apenas visuais.
- Mantida a proteção contra quedas, com exceção espacial para as duas rampas que dão acesso aos morros. A sondagem vertical anterior lia o piso sob a rampa e impedia a subida.
- Fechadas na cena jogável as aberturas centrais de 8 m dos muros norte e sul. Não foram criados portais nem entrada em edifícios.
- Removida da cópia versionada a segunda cápsula de colisão do Espadachim; o script do personagem já cria uma.
- O minimapa usa os limites de 160 × 160 m da Arena01 e marca os dois morros, o jogador e os alvos.

## Ampliação para 160 × 160 m

- O piso e os muros externos foram ampliados apenas em comprimento e deslocados para os limites ±80 m. Os dois morros ficaram em quadrantes opostos, em (−48, −48) e (48, 48), com 24 × 24 × 5 m cada.
- As quatro rampas foram deslocadas junto com os morros, sem alteração do perfil de 5 m de subida por 10 m de percurso. Duas rampas CSG precisaram de um colisor inclinado invisível para permitir a subida; a geometria visível e a inclinação foram mantidas.
- A ruína foi centralizada; muros internos, cercas e rochas foram espalhados pelo terreno. Suas dimensões individuais foram preservadas. O Espadachim inicia em (0, −16) e os três alvos ficam no piso e no alto de cada morro.
- A câmera agora vai de 12 a 420 m. Ao afastar, o foco transita do personagem para o centro da arena. No limite máximo, os quatro cantos permanecem dentro da tela nos ângulos testados.
- O Espadachim inicia voltado para o alvo próximo. A caminhada atualiza a direção visual conforme a câmera; ao atacar um alvo já à frente, o corpo mantém essa direção em vez de girar para o lado. Um alvo fora de alcance ou bloqueado não gira o personagem.

## Testes

`tests/arena01_playtest_smoke.gd`: carregamento da cena, presença do modelo e da interface, colisões físicas em morro e rocha, fechamento das bordas, movimentação, ataque, bônus de dano, seleção de alvo, poção e subida por ambas as rampas. O teste passou no Godot 4.7.2. A prévia anterior também passou após a mudança do minimapa.

A versão ampliada é testada contra o backup de 80 × 80 m: tamanhos dos objetos, colisão de cobertura na ruína, piso nos quatro quadrantes, subida e descida das quatro rampas, direção do ataque, movimento relativo à câmera, minimapa e projeção dos quatro cantos da arena com zoom máximo em várias rotações e inclinações.

Os botões também respondem ao clique esquerdo no computador. O teste cobre ataque, Proteção, seleção de alvo, elixir e zoom pelo mouse. Toques que gerem um clique sintético são ignorados por uma curta janela de 120 ms para evitar ação duplicada.

## Pendências

Validar manualmente em celular a escala do personagem, legibilidade do minimapa, fluidez da cena CSG e gestos de câmera. Os alvos são bonecos estáticos; a migração de bots, progressão e inventário persistente continua pendente.
