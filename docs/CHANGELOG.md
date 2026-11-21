# Changelog

## Arena01 jogável para validação

- Integrada a cena autoral `Arena01.tscn` como entrada 3D, com Espadachim, câmera orbital, HUD mobile, minimapa de 80 × 80, três alvos e habilidades de teste. Colisões ativadas nos objetos CSG, rampas liberadas na proteção contra quedas e aberturas centrais das bordas fechadas. Relatório em `docs/ARENA01_VALIDACAO.md`.

## Interface 3D como entrada principal

- A arena 3D passou a ser a cena inicial. A interface mobile recebeu ícones de ataque e três habilidades no canto inferior direito, três poções acima, minimapa no canto superior direito e câmera orbital com rotação e zoom por toque. O movimento continua relativo à câmera. A arena 2D permanece apenas como código legado durante a migração.

## Prévia web da arena 3D fechada

- Criada cena experimental independente com arena provisória autoral, Espadachim 3D, controle de toque, três alvos com HP, ataque básico que causa dano e efeitos de Proteção, Cura e Determinação. Incluído um único GLB fornecido pelo responsável para a prévia pública; os mapas do cliente Ragnarok permanecem locais.

## Direção da arena fechada

- Registrado que Prontera e a transição experimental de Mjolnir são referências técnicas, não o fluxo final do jogo. A arena será fechada, sem portais internos ou entrada em casas; portais antes da partida ficam para definição posterior.

## Tamanho e braço direito do Espadachim 3D

- Ampliada a apresentação visual do Espadachim experimental em 1,5× (modelo e sprite alternativo). Corrigido o eixo de repouso do braço direito no rig importado, mantendo-o abaixado e vertical durante a caminhada; braços alternam a passada para frente e para trás. A física da arena 2D não foi modificada.

## Proporção de Prontera e caminhada do Espadachim

- Reduzida a ampliação experimental de Prontera de 5× para 4×. Corrigida a caminhada do rig 3D: as duas pernas e os dois braços oscilam ao longo da frente do personagem, em fases opostas, em vez de abrir lateralmente. A orientação do modelo acompanha o deslocamento.

## Escala de Prontera

- Ampliados cenário, piso caminhável e posições dos obstáculos provisórios de Prontera em 5× para acertar a proporção com o Espadachim. O personagem e os mapas Mjolnir conservam suas escalas. Corrigido o ponto inicial da cidade após uma transição de mapa no mesmo processo.

## Mapas completos de Mjolnir e prévia de Prontera

- A ponta leste da ponte de `mjolnir_01` agora leva ao mapa vizinho `mjolnir_02`, com retorno pela ponte oeste. Adicionado piso de colisão à ponte estreita do segundo mapa. Criada cena experimental de Prontera com mapa visual e malha GAT completos, mantendo os arquivos do cliente apenas localmente. Portais e paredes precisas das casas de Prontera aguardam definição.

## Trepadeiras amarelas atravessáveis

- Incluídos os modelos de trepadeira baixa do Mjolnir entre as folhagens atravessáveis; flores altas e limites do terreno continuam bloqueados.

## Folhagens atravessáveis no mapa experimental

- Arbustos, mato e grama baixos deixam de bloquear o Espadachim no mapa Mjolnir. Flores altas, árvores e objetos sólidos continuam bloqueados; penhascos permanecem intransponíveis fora das passagens designadas.

## Navegação segura no mapa 3D experimental

- Adicionados piso segmentado à ponte, bloqueio de bordas e mudanças de altura fora de passagens designadas, áreas provisórias para flores e demais obstáculos e recuperação pela tecla R ou após queda. O ponto de entrada agora exige piso livre ao redor. Teste automatizado cobre colisão da ponte, bloqueio e saída de obstáculo, recuperação e movimento.

## Caminhada e ataque do Espadachim 3D experimental

- Carregados localmente os GLBs `Espadachim Caminhando` e `Espadachim Atacando` na cena Mjolnir. Como os arquivos não incluem animações, adicionados movimentos provisórios dos ossos para caminhada e ataque, troca de modelo durante o golpe e arco dourado de teste ao pressionar Espaço. Não há dano ou alteração no combate existente.

## Prévia local do Espadachim 3D

- Integrado opcionalmente o `Espadachim.glb` enviado pelo usuário à cena experimental do mapa Mjolnir, com escala adequada ao colisor e rotação na direção do movimento. T alterna entre o modelo e o sprite; arquivo GLB permanece local e fora do repositório. O modelo ainda não inclui animações.

## Movimento relativo à câmera no mapa provisório

- WASD do Espadachim experimental agora acompanha a rotação da câmera, com vetores projetados no plano do chão; o sprite usa a direção do comando na tela. A arena 2D e a graybox 3D permanecem com os controles anteriores.

## Câmera do mapa provisório

- Adicionada câmera em perspectiva com órbita horizontal de 360°, inclinação limitada, zoom por roda do mouse ou pinça e rotação por arraste com botão direito ou toque. Atualizados controles e teste da cena local; movimentação e combate das arenas atuais preservados.

## Teste local com mapa completo de Ragnarok

- Convertido `mjolnir_01` da instalação local do usuário para GLB com `ragx` e extraída a malha caminhável GAT da mesma versão. Criada cena experimental independente com câmera, Espadachim e colisão na malha GAT. Arquivos convertidos ficam fora do controle de versão; arena 2D e combate não foram alterados.

## Graybox da arena 3D experimental

- Criada cena isolada com três patamares, rampas, passagem estreita, rochas, colisões 3D, personagem com sprite, câmera inclinada e visão geral. Adicionadas sondas de ataque/efeito entre alturas e teste automatizado de física. Arena 2D, movimentação e combate reais não foram alterados.

## Análise da arena 3D experimental

- Avaliada a viabilidade de uma cena isolada de montanha com patamares, rampas, barreiras, sprites 2D em 3D e câmera inclinada. Analisado o `ragx` para inspeção de GLB sem incorporar assets originais. Registrados arquivos, testes e impacto em `docs/ARENA_3D_EXPERIMENTAL_ANALISE.md`; nenhuma cena ou sistema jogável foi modificado.

## Progressão Base/Job de Arena

- Implementados personagens de classe fixa com até nove vagas, Base/Job EXP e Level persistentes e independentes, tabelas configuráveis 1–40 e migração segura do perfil v1.
- Integradas recompensas por tempo e ações, vitória/empate, penalidade de 25% na morte, abandono sem penalidade e proteção contra pagamento duplicado por partida.
- Adicionados testes de progressão e integração; combate, atributos e habilidades existentes mantidos. Autoridade de servidor e assistências multiplayer seguem pendentes.

## Planejamento da nova fase

- Preparada a primeira implementação de progressão persistente por personagem, com classe fixa, tabelas Base/Job configuráveis e recompensas de Arena propostas. A regra antiga de troca de classe foi substituída neste escopo por vários personagens independentes. Registradas incompatibilidades entre a curva clássica rAthena e os valores de EXP por partida, migração do perfil v1 e decisões pendentes. Nenhuma jogabilidade foi alterada.
- Criado backlog de definição em cinco tópicos, iniciando por Classes. Confirmadas cinco classes no beta (Espadachim, Mago, Arqueiro, Noviço e Gatuno), Base Level permanente 1–99 e Job Level separado, com propostas de duas ou mais ramificações futuras por classe. Documentada a diferença entre o protótipo atual e as novas regras; nenhuma jogabilidade foi alterada.
- Definida a troca de classe: Base Level e Base XP persistem; Job Level e Job XP recomeçam na classe escolhida, mesmo quando já utilizada anteriormente. Atualizados os critérios de dados e testes do backlog; nenhuma jogabilidade foi alterada.
- Iniciado o tópico Habilidades exclusivamente pelo Espadachim: inventariadas as três habilidades do protótipo, proposto contrato de alcance de dois blocos, progressão por Job Level e critérios de aceite; demais classes aguardam essa referência. Nenhuma jogabilidade foi alterada.
- Definido em conceito o kit inicial do Espadachim: Aumentar Recuperação de HP, Perícia com Espada, Golpe Fulminante e Vigor. Ataque básico de dois blocos atinge um alvo; ranks aprendidos sobrevivem ao reset de Job na troca de classe. Registradas pendências de balanceamento e de pontos para impedir duplicação. Nenhuma jogabilidade foi alterada.
- Alinhado o alcance de Golpe Fulminante ao ataque básico: ambos chegam a dois blocos e acertam um alvo por acionamento, inclusive caixas. Nenhuma jogabilidade foi alterada.
- Definida a progressão futura da linha Espadachim em três etapas: primeira evolução no Job Level 40, nova etapa com Job Level 0, novas habilidades e ranks anteriores preservados. Marcos de Job concedem pontos uma única vez por etapa para impedir duplicação após reset. Nenhuma jogabilidade foi alterada.

## 1.0 — preparação inicial da beta

- Preset Android atualizado para versão 0.7.0/código 8. Adicionado script de exportação de APK de depuração e documentação de teste em aparelho; lançamento e multiplayer seguem pendentes.

## 0.7.0 — etapa técnica encerrada; aceite mobile pendente

- Mapa lógico extraído para `arena_map_layout.gd`, compartilhado pela arena e pelas regras de partida. Convenção X/Z e conversores preparados para uma futura cena 3D, preservando o jogo 2D atual.

- Golpe do Paladino agora parte do centro físico e acerta caixas encostadas. Toque ou clique em caixa/oponente seleciona alvo; fora do alcance, o Paladino se aproxima e golpeia ao chegar. O botão de ataque usa o alvo selecionado.
- Espadachim ampliado visualmente de 25% para 50% do sprite, mantendo a câmera em zoom 1,05 e alinhando os pés ao ponto anterior.
- Câmera aproximada de zoom 0,85 para 1,05 a pedido do responsável; personagem, alvos e efeitos ficam maiores, com HUD fixo.
- Controles de itens e habilidades redesenhados em círculos: quatro poções na faixa superior, três habilidades em diagonal e ataque maior no canto inferior direito. As áreas de toque seguem os limites circulares.
- Os quatro ícones enviados para ataque, Proteção Divina, Cura e Determinação foram adicionados aos botões do Espadachim no HUD. Outras classes mantêm os controles provisórios.
- Espadachim/Paladino ganhou arco luminoso no golpe básico, escudo dourado na Proteção Divina (Q), aura verde na Cura (E) e energia dourada na Determinação (F). Q agora absorve dano, E cura e F mantém a resistência a empurrão; as três habilidades seguem suas recargas existentes.
- Personagem foi colocado acima das caixas na ordem de desenho para manter os efeitos visíveis durante o combate.
- HUD da Arena reorganizado: quatro itens de uso rápido com ícones acima das três habilidades no canto inferior direito; ataque permanece separado à direita.
- Caminhada do Espadachim alinhada quadro a quadro nas quatro direções; corrigido o salto lateral causado pela posição do desenho dentro das células do sprite.
- Sprites de caminhada do Espadachim fornecidos pelo responsável integrados às quatro direções no Paladino, com seis quadros por direção e escala visual de 25%.
- Minimapa deslocado para o canto superior direito; botões de depuração removidos da interface jogável.
- Ataque básico em linha percorre dois quadros e pode acertar dois alvos alinhados no mesmo golpe; paredes interrompem o ataque.
- Arena de teste ampliada para 2560×1440, com câmera seguindo o personagem em zoom 0,85 e HUD fixo. Spawns foram distribuídos pelo mapa; o total de caixas passou de 12 para 24.
- Minimap provisório mostra posição do jogador e área segura sem revelar oponentes. Fechamento máximo foi ajustado provisoriamente para a escala nova.
- HUD movido para um `CanvasLayer` independente do mundo; os efeitos de ataque permanecem no espaço da arena. Preparação para câmera móvel, sem mudar o tamanho do mapa nesta etapa.
- Atlas provisórios originais para Paladino, Mago, Assassino e Arqueiro, com quadros de parado, caminhada, ataque, dano e morte.
- Tiles de madeira e pedra e ícones para os seis itens substituem formas simples no jogo.
- HUD mais compacto, recargas mostradas nas habilidades e alvo de ataque separado dos botões próximos.
- Sinais sonoros sintéticos para impacto, coleta, uso de habilidade e eliminação.
- Release 0.6 colocada em espera; este trabalho parte da versão estável 0.5.2 e não altera a infraestrutura multiplayer.

## 0.5.2 — dano dos bots visível

- Bots agora disparam projéteis vermelhos. HP só diminui quando um projétil atinge o personagem; movimento e paredes podem evitar o dano.
- O personagem pisca em vermelho ao ser atingido; velocidade do projétil configurável em `resources/classes.tres`.
- Teste de regressão cobre HP parado, disparo, impacto, desvio e cobertura.

## 0.5.1 — digitação no navegador móvel

- Ativado o teclado virtual experimental da exportação Web do Godot.
- Adicionado botão **Teclado na tela** aos campos de personagem e configuração, com letras, números, `_`, espaço, apagar e concluir. O nome continua sujeito à validação existente.
- Teste automatizado passou para digitar e apagar pelo teclado alternativo e criar o personagem.

## 0.5.0 — identidade e configurações locais

- Perfil local com ID interno, nome público imutável, validação provisória e histórico de partidas no dispositivo.
- Entrada local, menu Arena/Perfil/Configurações e escolha de configuração antes da partida.
- Criação, edição, seleção e exclusão de múltiplas configurações; cada uma salva somente nome e classe.
- Classe escolhida aplicada à arena; nova partida reinicia nível, HP, XP e itens, preservando perfil e configurações.
- Suíte headless de persistência e fluxo completo. Sem login real ou garantia de nome único global.

## 0.4.0 — ciclo da partida local

- Estado da partida, simulação configurável de 2 a 5 participantes, eliminação definitiva e modo espectador.
- Encerramento imediato com sobrevivente único ou após oito minutos; empate provisório por tempo ou eliminação simultânea, sem desempate definitivo.
- Aviso e fechamento progressivo da arena com paredes físicas, condução dos participantes para a área segura e remoção de itens cobertos.
- Cronômetro, contagem de vivos, painel de resultado e botão de nova partida; regras provisórias em `resources/match.tres`.
- Suíte headless para 2–5 participantes, fechamento, resultado e reinício; avanço de 60 segundos para teste manual.

## 0.3.0 — classes e combate local

- Paladino, Mago, Assassino e Arqueiro com atributos configuráveis, ataque básico e três habilidades cada.
- Bots locais, dano PvP efetivo e XP por eliminação; projéteis bloqueados por paredes e caixas.
- Recargas, congelamento, imobilização, empurrão, barreira, invisibilidade, velocidade e proteção do Paladino.
- Crescimento de HP/dano por nível e marcos provisórios de habilidade nos níveis 10, 20 e 30.
- Controles de teclado e toque para classes e habilidades; testes headless da release 0.3.

## 0.2.0 — progressão, drops e inventário

- Níveis 1–30 por partida, XP por caixa e curva configurável; fontes futuras de XP PvP preparadas sem inimigos.
- Drop ponderado de seis itens com chance configurável; coleta automática e expiração de itens no chão.
- Quatro slots, empilhamento de poções, uso manual, cooldown global e efeitos temporários com renovação sem soma.
- HP, XP, nível, quantidades e efeitos mostrados na HUD provisória; teclas 1–4 e toque nos slots.
- Parâmetros iniciais reunidos em `resources/balance.tres` e suíte headless da release 0.2.

## 0.1.4 — publicação Web

- Repositório `LRFSousa/RagArena` tornado público e Pages ativado na branch `gh-pages`.
- Jogo acessível em https://lrfsousa.github.io/RagArena/; arena renderizada no navegador sem erros de console.

## 0.1.3 — preparação da versão Web

- Preset Web sem threads e guia para hospedagem estática/GitHub Pages.
- Exportação HTML5 concluída; WebAssembly validado; teste visual em navegador pendente.

## 0.1.2 — APK de teste Android

- Preset de exportação Android e importação ETC2/ASTC configurados.
- Ícone geométrico provisório e guia de instalação no celular.
- APK de depuração gerado e assinatura verificada; teste em aparelho real pendente.

## 0.1.1 — conclusão da release 0.1

- Cenas separadas para arena, jogador, caixa e parede; quatro áreas de spawn de teste protegidas por cobertura de pedra.
- Nível de teste configurável de 1 a 30 e regra de dano contra caixas isolada do futuro combate PvP.
- HUD com nível de teste, caixas destruídas e restantes.
- Orientação Android corrigida para paisagem; escala proporcional de 1280×720.
- Testes automatizados de dano, direção, cadência, bloqueio de ataques, toque simulado, colisão e reinício.

## 0.1.0 — protótipo inicial

- Projeto Godot 4 com arena top-down e obstáculos de madeira e pedra.
- Personagem geométrico, movimento contínuo e colisão.
- Ataque direcional repetido ao segurar, dano em blocos por faixa de nível e destruição aos 0 HP.
- Controles desktop e toque, HUD provisória e reinício rápido.

### Verificação

- Inspeção estática dos arquivos e das conexões de cena/scripts.
- Godot 4.7.2: importação headless do editor concluída sem erros.
- Godot 4.7.2: cena principal executada por 60 quadros em modo headless, saída 0 e sem erros.
- Teste manual de controles e jogabilidade visual ainda pendente em dispositivo/desktop interativo.
