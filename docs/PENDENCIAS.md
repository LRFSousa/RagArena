# Pendências

- Atributos V1: validar em celular a legibilidade e o toque na janela, a persistência após fechar e reabrir o navegador e o ritmo dos pontos em partidas reais. O botão “EXP teste” é temporário e deverá ser removido antes de uma build pública de produção.
- Definir bônus de classe/Job, impacto de FOR/AGI/VIT/INT/DES/SOR nas fórmulas PvP, limites finais e árvore de habilidades. Os pontos de habilidade são acumulados, mas ainda não podem ser gastos.

- Validar no celular a velocidade de 8 m/s e as bordas das quatro rampas da Arena01 após o ajuste de colisão lateral.

## Redesenho antes do próximo desenvolvimento

- Arena01 160 × 160 m: validar em computador e celular real a sensação de escala, a câmera na visão geral, o desempenho das formas CSG e se a direção visual do GLB de ataque coincide com a caminhada em todos os ângulos. O teste automatizado cobre geometria, física e enquadramento; avaliação visual do modelo permanece necessária.

- Arena01: conferir visualmente as quatro rampas, o contorno das ruínas e a leitura dos alvos no minimapa em aparelho real. Veja `docs/ARENA01_VALIDACAO.md`.

- Migrar para a arena 3D as regras completas da versão 2D: inventário e equipamentos persistentes, progressão, bots, partidas, colisões de ataques e seleção direta de alvos. A prévia 3D tem apenas ações e poções locais de teste.
- Validar em aparelho físico a rotação por arrasto, zoom por pinça, legibilidade do minimapa e sobreposição dos botões em telas menores.

- Prévia 3D mobile: validar em celular real joystick, botões, leitura do HUD, fluidez do Espadachim e pacote web. Os três bonecos estáticos e números de dano são apenas para testar ataques; integrar bots e regras finais de combate em etapa posterior.

- Conferir visualmente no Godot o Espadachim experimental 1,5× maior e a pose vertical do braço direito em todas as direções da câmera; os GLBs ainda não contêm animações próprias.

- Validar visualmente no Godot a caminhada 3D corrigida em todas as direções da câmera e a proporção de Prontera em 4×; os GLBs do Tripo AI continuam sem trilhas de animação próprias.

- Usar Prontera experimental somente para avaliar proporção, câmera, movimentação e desempenho do cenário 3D em 4×. Não planejar entrada em casas ou portais internos para a arena fechada.
- Definir posteriormente a área anterior à partida e seus portais de acesso à arena; essa etapa está fora da prévia 3D atual.
- Mjolnir: conferir manualmente a transição nas duas direções pela ponte entre `mjolnir_01` e `mjolnir_02`, inclusive câmera, desempenho e posição de chegada em aparelho real. Os mapas originais permanecem locais e fora das builds distribuídas.

- Conferir visualmente quais modelos de vegetação do Mjolnir ficam abaixo do joelho e ajustar a classificação por nome quando necessário. A altura física por modelo ainda não é confiável na importação atual; penhascos continuam bloqueados.

- Mapa Mjolnir experimental: validar manualmente a travessia completa da ponte e o contorno de flores, árvores e demais objetos; substituir as áreas circulares provisórias por colisores ajustados; cadastrar rampas e escadas autorizadas para trocar de nível. A tecla R recupera a última posição segura enquanto essa validação não termina.

- Arena 3D experimental: graybox e sondas de altura implementados em cena isolada; relatório em `docs/RELATORIOS/RELATORIO_ARENA_3D_EXPERIMENTAL.md`. Faltam teste em celular, navegação automática, toque, minimapa e avaliação da integração real de combate. Combate e movimentação atuais não devem ser alterados sem aprovação.
- Progressão Base/Job inicial implementada conforme `docs/PRIMEIRA_IMPLEMENTACAO_PROGRESSAO.md`; relatório em `docs/RELATORIOS/RELATORIO_PROGRESSAO_BASE_JOB.md`. Falta validar em celular a meta de 150/200 partidas e migrar a autoridade de recompensas ao servidor quando o multiplayer for desenvolvido.
- Assistências entre jogadores e janela de contribuição de 10 s aguardam multiplayer; no protótipo local a categoria está pronta no cálculo, mas não há outros jogadores nem combate entre bots para produzi-la. Noviço ainda usa combate provisório do Paladino.
- Depois da progressão, seguir os tópicos Classes, Habilidades, Atributos, Itens e Inventário, Navegação e Mapa de `docs/BACKLOG_NOVA_FASE.md`. Evolução em três etapas, papéis e ramificações futuras continuam pendentes.
- Habilidades: fechar primeiro o kit do Espadachim com duas passivas (Aumentar Recuperação de HP, Perícia com Espada), Golpe Fulminante e Vigor. Ataque básico e Golpe Fulminante têm o mesmo alcance de dois blocos e atingem um alvo, inclusive caixas. A linha terá três etapas; a primeira evolução será no Job Level 40, com Job reiniciado em 0 e ranks preservados. Cada marco de Job concede pontos uma vez por etapa. Faltam gasto de pontos entre etapas, condição da recuperação, custos e valores por rank. Usar o contrato resultante para as demais classes depois.

## Release 1.0

- Instalar o APK de depuração em aparelhos reais e verificar controles, persistência, desempenho e partida completa.
- Definir e executar assinatura de release, AAB, CI e distribuição controlada após os testes.
- Integrar a 0.6 adiada para validar login e partidas online antes do aceite da 1.0.
- Balancear com dados de partidas, revisar nome/marca e preparar privacidade e informações de loja antes de publicação.

## Release 0.7

- Etapa técnica encerrada; faltam aceite em aparelho real e arte final antes de considerar os critérios completos. O mapa 3D é uma evolução futura, descrita em `docs/MAPA_3D.md`; ainda faltam cena, física, câmera, navegação e testes mobile 3D.
- Validar em celular o toque para selecionar caixa/oponente e a aproximação automática em mapas com muitos obstáculos e alvos em movimento. O contorno por grade já cobre uma parede simples.
- Validar no celular a ergonomia da nova disposição circular, especialmente com os quatro espaços de itens e os ícones das habilidades em telas pequenas.
- Avaliar no celular a leitura dos novos ícones de habilidade em tamanho reduzido e o contraste das recargas.
- Conferir em celular real a leitura dos quatro efeitos do Espadachim sobre diferentes fundos, a duração da aura de proteção e a fluidez do arco de ataque.
- Conferir em celular real a ergonomia dos itens e habilidades no canto inferior direito, especialmente em telas com proporções diferentes de 16:9.
- Confirmar em aparelho real se o Espadachim em 50% de escala mantém boa leitura sem encobrir alvos próximos. A associação com Paladino é provisória; faltam arte própria de parado, ataque, dano e morte e decisão sobre o nome/classe final.
- Validar em celular o tamanho e a posição do minimapa no canto superior direito e a leitura do alcance de dois quadros. Ajustar os 152 px provisórios se a escala de arte mudar.
- Validar em celular real se o zoom 1,05 melhora a leitura do personagem e dos efeitos sem reduzir demais a visão dos oponentes; comparar com a prévia anterior em 0,85.
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

- Espadachim 3D experimental: exportar do Tripo animações reais de caminhada, ataque e habilidades. Os GLBs recebidos possuem rig, mas nenhuma trilha de animação e geometria idêntica; a prévia usa poses geradas no Godot. Conferir a espada/equipamento no modelo rigado, validar orientação e proporção em diferentes câmeras e medir desempenho. Os GLBs permanecem locais e não entram na build distribuída.

- Mapa completo `mjolnir_01`: validar visualmente trilhas, pontes, bordas e alturas durante a navegação manual. A colisão usa apenas células GAT caminháveis; objetos decorativos e penhascos ainda não têm colisores próprios. Medir custo de importação e desempenho em celular antes de qualquer integração. Substituir o mapa provisório por cenário autoral para distribuição.

- Refinar atributos, dano PvP e cooldowns após playtests; valores da release 0.3 ainda não são decisões finais.
- Revisar quinto spawn, mapa, fechamento e desempate a partir de playtests da 0.4.
- Definir política de desconexão/reconexão, autenticação, hospedagem e matchmaking (release 0.6).
- Verificar disponibilidade comercial e jurídica do nome provisório RagnArena antes de publicação.

Os valores provisórios em `GAME_DESIGN.md` não são decisões finais de balanceamento. Consulte `releases/09_DECISOES_E_PENDENCIAS.md` para as decisões aprovadas.
