# Pendências

## Testes em dispositivo

- Validar a HUD de classes e os três botões de habilidade em Android real; testar latência visual, precisão do toque e desempenho com projéteis.
- Validar controles de toque, slots, desempenho e legibilidade da release 0.2 em celular real em paisagem. Eventos de toque foram simulados em teste headless.
- Testar ergonomia em telas de diferentes proporções e tamanhos; os parâmetros visuais continuam provisórios.

## Balanceamento provisório da release 0.2

- Validar curva `20 × 1,22^(nível − 1)`, XP de 20 por caixa e valores futuros de XP por dano PvP efetivo e eliminação.
- Validar 30% de chance de drop e pesos iniciais 30/15/15/15/10/15 para os seis itens.
- Validar HP máximo inicial 100, distância de coleta 38 px, efeitos, duração, expiração e intervalo de uso configurados em `resources/balance.tres`.

## Balanceamento provisório da release 0.3

- Validar atributos e três recargas de cada classe no recurso `resources/classes.tres`; as quatro classes usam dados provisórios.
- Validar HP e dano ganhos por nível, bônus de habilidades nos níveis 10/20/30, XP de 1 por dano efetivo e 60 por eliminação.
- Refinar comportamento dos bots, animações e efeitos de habilidades. Bots atuais são alvos estacionários que atacam quando o jogador se aproxima; não representam um jogador real.
- Testar cobertura, pressão corpo a corpo e equilíbrio das quatro classes em aparelho real. A Flecha de Impacto empurra apenas bots e a armadilha usa forma geométrica provisória.

## Releases posteriores

- Refinar atributos, dano PvP e cooldowns após playtests; valores da release 0.3 ainda não são decisões finais.
- Definir quinto spawn, tamanho final do mapa, cronograma de fechamento e desempate (release 0.4).
- Definir política de desconexão/reconexão, autenticação, hospedagem e matchmaking (release 0.6).
- Verificar disponibilidade comercial e jurídica do nome provisório RagnArena antes de publicação.

Os valores provisórios em `GAME_DESIGN.md` não são decisões finais de balanceamento. Consulte `releases/09_DECISOES_E_PENDENCIAS.md` para as decisões aprovadas.
