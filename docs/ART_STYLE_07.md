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

## Direção aprovada para o próximo protótipo de câmera e mapa

O mapa deve ser maior que a tela, com câmera acompanhando o personagem e visão um pouco mais afastada. Jogadores e obstáculos poderão ficar fora do campo de visão. A referência enviada pelo responsável define a **organização**: mundo aberto ao centro, movimento no canto inferior esquerdo, habilidades e ataque no canto inferior direito, informações nas bordas. Não copiar personagens, ícones, cenários ou composição exata de outra franquia.

Primeiro teste proposto [Provisório]: mundo de cerca de 2560×1440 unidades e zoom de câmera em torno de 0,85, comparado com zoom 1,0 no mesmo aparelho. HUD deve usar `CanvasLayer` para permanecer fixo; toque deve continuar em coordenadas de tela e combate/colisões em coordenadas do mundo. Um minimapa simples ou indicadores de jogadores fora da tela podem ajudar a orientar o combate. A distância entre spawns, densidade de caixas e cronograma de fechamento precisam de novo playtest. Aumentar o mapa **não** aumenta por si só o limite de jogadores: a capacidade da rede e o equilíbrio da partida serão tratados na 0.6 e em testes posteriores.

## Áudio

Quatro sinais sintéticos discretos, gerados em `scripts/game_audio.gd`: impacto, coleta, habilidade e eliminação. São provisórios e não usam arquivos com licença externa. A intensidade e a clareza devem ser avaliadas no celular.
