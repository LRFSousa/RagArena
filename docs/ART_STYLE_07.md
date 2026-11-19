# Guia visual provisório — release 0.7

## Direção

Fantasia original em pixel art top-down 3/4. Silhuetas simples, contorno azul escuro e cores fortes para leitura em tela pequena. Nenhum asset de outra franquia foi copiado. Personagens ocupam quadros transparentes de 64×64 px, objetos 32×32 px e itens 16×16 px. O filtro de textura no jogo é `nearest`.

## Classes

| Classe | Silhueta | Cores principais |
| --- | --- | --- |
| Paladino | Elmo claro e escudo lateral | dourado, marfim, azul |
| Mago | Chapéu alto e cajado | violeta, azul claro, âmbar |
| Assassino | Capuz baixo e lâmina curta | verde escuro, carvão, vermelho |
| Arqueiro | Boné/chapéu baixo e arco | couro, verde claro, areia |

Cada atlas tem quatro colunas de quadros e cinco linhas: parado, caminhada, ataque, dano e morte. O script `tools/generate_art.gd` é a fonte reproduzível dos PNGs. As poses e o acabamento são provisórios; movimento, tamanho e contraste precisam de validação em aparelho real.

## Interface

Faixa superior para HP/nível/XP e cronômetro. Quatro itens ficam abaixo do HP. Efeitos aparecem em uma faixa curta. Joystick permanece à esquerda; três habilidades e ataque ficam à direita. O botão de ataque tem alvo de toque separado das habilidades. O layout lógico é 1280×720 em paisagem, escalado pelo Godot mantendo a proporção.

## Áudio

Quatro sinais sintéticos discretos, gerados em `scripts/game_audio.gd`: impacto, coleta, habilidade e eliminação. São provisórios e não usam arquivos com licença externa. A intensidade e a clareza devem ser avaliadas no celular.
