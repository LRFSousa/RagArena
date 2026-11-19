# Pendências

## Release 0.7

- Validar em celular real se o zoom 0,85 mantém personagem, projéteis, itens e minimapa legíveis; comparar com zoom 1,0 e ajustar se necessário.
- Reavaliar distribuição das 24 caixas, distância entre spawns, quinto spawn e fechamento máximo de 480 unidades após playtest no mapa ampliado.
- Câmera espectadora ainda acompanha o local da eliminação; seguir outro sobrevivente fica para uma etapa posterior.
- Prototipar mundo maior e câmera mais afastada conforme referência do responsável; comparar zoom, legibilidade e navegação antes de fixar tamanho do mapa e spawns.
- Com o HUD já separado, a próxima etapa é introduzir a câmera seguindo o personagem e converter o toque para coordenadas corretas de tela/mundo; só depois ampliar os limites da arena.

- Validar arte, contraste, áreas de toque e desempenho em celulares Android reais. Os testes atuais são headless e não medem quadros por segundo nem ergonomia.
- Adicionar efeitos visuais específicos para cada habilidade, animações direcionais mais completas e revisão artística após playtest.
- Revisar o layout em proporções diferentes de 16:9; o Godot mantém a proporção lógica e pode deixar faixas laterais.
- A release 0.6 foi adiada pelo responsável. A base inicial está preservada na branch `release/0.6`; integração deve ocorrer depois da 0.7.

## Testes em dispositivo

- Confirmar se projéteis vermelhos e o sinal de dano do personagem são legíveis na tela do celular.
- Confirmar em Android e iOS reais se o teclado nativo abre no navegador. O botão **Teclado na tela** oferece alternativa independente do teclado do sistema.
- Testar entrada de nome pelo teclado virtual, persistência do perfil após fechar/reabrir o app e navegação do menu em Android real.
- Validar aviso e paredes de fechamento, painel de resultado, botão de nova partida e observação após eliminação em Android real.
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

## Balanceamento provisório da release 0.4

- Validar início do fechamento aos 5 minutos, aviso de 30 s, avanço das bordas e área final. Todos ficam em `resources/match.tres`.
- Definir spawn definitivo do quinto participante; o centro do mapa é apenas posição de teste.
- Decidir desempate ao fim dos oito minutos e em eliminações simultâneas. O protótipo registra empate nesses casos.
- Refinar condução dos personagens alcançados pelo fechamento; o protótipo os desloca para dentro da área segura após aviso, sem causar dano.
- Bots estacionários da 0.3 não disputam entre si. A simulação de 2–5 participantes valida o ciclo e os estados, mas ainda não reproduz uma partida competitiva.

## Limites da release 0.5

- O perfil usa armazenamento local do dispositivo/navegador. Limpar dados do app ou navegador apaga nome, configurações e histórico; ainda não há sincronização.
- A regra de nome 3–16 caracteres ASCII e o limite de 24 caracteres para nome da configuração são provisórios. Unicidade global depende do backend futuro.
- Histórico local serve apenas para testes; precisa de validação autoritativa para ranking ou estatísticas públicas.
- Definir migração do formato `profile_v1.json` quando conta e backend forem implementados.

## Releases posteriores

- Refinar atributos, dano PvP e cooldowns após playtests; valores da release 0.3 ainda não são decisões finais.
- Revisar quinto spawn, mapa, fechamento e desempate a partir de playtests da 0.4.
- Definir política de desconexão/reconexão, autenticação, hospedagem e matchmaking (release 0.6).
- Verificar disponibilidade comercial e jurídica do nome provisório RagnArena antes de publicação.

Os valores provisórios em `GAME_DESIGN.md` não são decisões finais de balanceamento. Consulte `releases/09_DECISOES_E_PENDENCIAS.md` para as decisões aprovadas.
