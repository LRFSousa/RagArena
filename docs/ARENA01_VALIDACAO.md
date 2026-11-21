# Validação da Arena01

A cena `scenes/Arena01.tscn`, criada pelo responsável, é agora a cena inicial do protótipo 3D. A versão de desenvolvimento liga o Espadachim, câmera orbital, controles mobile, minimapa, três alvos de treino, ataque básico, Proteção, Cura, Determinação e poções locais de teste.

## Ajustes necessários para jogar

- Ativadas colisões nas formas CSG: piso, morros, rampas, ruínas, cercas e rochas. Antes, vários objetos eram apenas visuais.
- Mantida a proteção contra quedas, com exceção espacial para as duas rampas que dão acesso aos morros. A sondagem vertical anterior lia o piso sob a rampa e impedia a subida.
- Fechadas na cena jogável as aberturas centrais de 8 m dos muros norte e sul. Não foram criados portais nem entrada em edifícios.
- Removida da cópia versionada a segunda cápsula de colisão do Espadachim; o script do personagem já cria uma.
- O minimapa usa os limites de 80 × 80 unidades da Arena01 e marca os dois morros, o jogador e os alvos.

## Testes

`tests/arena01_playtest_smoke.gd`: carregamento da cena, presença do modelo e da interface, colisões físicas em morro e rocha, fechamento das bordas, movimentação, ataque, bônus de dano, seleção de alvo, poção e subida por ambas as rampas. O teste passou no Godot 4.7.2. A prévia anterior também passou após a mudança do minimapa.

Os botões também respondem ao clique esquerdo no computador. O teste cobre ataque, Proteção, seleção de alvo, elixir e zoom pelo mouse. Toques que gerem um clique sintético são ignorados por uma curta janela de 120 ms para evitar ação duplicada.

## Pendências

Validar manualmente em celular a escala do personagem, legibilidade do minimapa, fluidez da cena CSG e gestos de câmera. Os alvos são bonecos estáticos; a migração de bots, progressão e inventário persistente continua pendente.
