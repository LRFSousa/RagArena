# RagnArena — Backlog de releases

**Status:** releases 0.1 a 0.5 implementadas; 0.6 adiada por decisão do responsável; etapa técnica da 0.7 encerrada, com aceite mobile e arte final pendentes; preparação da 1.0 iniciada.
**Stack:** Godot 4 + GDScript. **Alvo:** Android (paisagem), testes iniciais em desktop.  
**Princípio:** validar gameplay com formas geométricas antes de sprites e interface final.

## Convenções
- **[Aprovado]** regra definida em conversa.
- **[Provisório]** número ou implementação sujeito a testes.
- **[Pendente]** decisão ainda necessária.
- Tarefas desmarcadas significam **não comprovadamente implementadas**.

## Release 0.1 — Protótipo offline: arena e movimentação
**Objetivo:** validar a movimentação e a abertura de caminhos.
- [x] Criar projeto Godot 4 com estrutura de cenas e scripts.
- [x] Criar arena top-down com blocos de madeira destrutíveis e paredes de pedra permanentes, posicionadas de forma não rigidamente quadriculada.
- [x] Criar personagem provisório (forma geométrica) com orientação visível.
- [x] Implementar movimentação contínua 360° por joystick virtual e equivalente para testes desktop.
- [x] Implementar colisão com paredes e blocos.
- [x] Implementar ataque básico na direção em que o personagem olha; manter botão pressionado repete ataques conforme cadência.
- [x] Implementar blocos com 45 HP e destruição quando HP chega a zero.
- [x] Implementar dano em blocos igual entre classes e dependente somente da faixa de nível: níveis 1–3 = 15; 4–7 = 23; 8–30 = 45. A cadência de ataque a blocos deve ser igual entre classes.
- [x] Criar HUD provisória mínima e reinício rápido da cena.
**Aceite:** mover-se sem atravessar obstáculos, atacar direcionalmente e abrir caminhos destruindo blocos.

**Evidência 0.1:** suíte `tests/release01_smoke.gd` passou para dano de 15/23/45, destruição em 3/2/1 golpes, direção, cadência, bloqueio por parede, toque simulado, colisão e reinício. Cenas `main`, `arena`, `player`, `crate` e `wall` separadas; quatro áreas de spawn de teste; nível de teste configurável; contadores na HUD. Teste manual em aparelho Android ainda pendente.

## Release 0.2 — Progressão, drops e inventário
**Objetivo:** validar a recompensa por destruir obstáculos e a gestão de itens.
- [x] Implementar XP por bloco destruído e evolução automática de nível 1 a 30.
- [x] Criar curva de XP configurável: níveis iniciais rápidos, progressão posterior mais lenta; sem exigir nível 30 em toda partida.
- [x] Implementar chance inicial de 30% de drop por bloco destruído [Provisório].
- [x] Implementar distribuição ponderada de seis itens [pesos pendentes].
- [x] Implementar coleta automática e quatro espaços de inventário rápido.
- [x] Se inventário cheio, deixar item no chão.
- [x] Implementar Poção de Vida (+30% HP máximo), Bônus de Força (+20% dano PvP, 15 s), Botas de Velocidade (+15% velocidade, 12 s), Escudo Protetor (absorve 30 de dano ou dura 15 s), Elixir de Recuperação (+60% HP máximo) e Amuleto de XP (+25% XP, 15 s, ativação automática sem ocupar espaço).
- [x] Implementar uso manual dos cinco itens armazenáveis e intervalo global provisório de 2 s.
- [x] Implementar empilhamento inicial de até três poções iguais por slot; buffs ocupam um slot por unidade [Provisório].
- [x] Impedir cura acima do HP máximo; buffs iguais não acumulam, nova coleta renova duração.
- [x] Exibir quantidade e duração dos efeitos na HUD provisória.
- [x] Remover itens no chão após até 20 s [Provisório].
**Aceite:** destruir bloco, ganhar XP, subir nível, coletar e usar itens com efeitos e limites corretos.

**Evidência 0.2:** `tests/release02_smoke.gd` passou para XP, nível máximo, drop, coleta, inventário cheio, empilhamento, cura, cooldown, buffs, escudo, expiração, controles e reinício. Testes da 0.1 seguem passando. Validação manual em celular pendente.

## Release 0.3 — Classes e combate PvP local
**Objetivo:** validar diferenças entre as quatro classes antes da rede.
- [x] Implementar Paladino (resistência, ataque corpo a corpo, proteção contra dano à distância, autocura, Determinação/Endure).
- [x] Implementar Mago (baixa resistência, magia à distância, Rajada de Gelo/congelamento, Barreira Arcana, Bola de Fogo).
- [x] Implementar Assassino (corpo a corpo rápido, Invisibilidade, Lâmina Arremessada, Passos Velozes; permitir invisibilidade + velocidade).
- [x] Implementar Arqueiro (longo alcance, Rajada de Flechas, Flecha de Impacto/repulsão, Armadilha/imobilização).
- [x] Implementar ataque básico e três habilidades ativas por classe, acionadas manualmente.
- [x] Implementar HP, dano PvP, defesa, alcance, velocidade e recargas configuráveis por classe.
- [x] Implementar colisão de projéteis com blocos e paredes; cobertura relevante para classes corpo a corpo.
- [x] Implementar XP por dano efetivamente causado e bônus por eliminação.
- [x] Implementar crescimento de atributos por nível e melhorias de habilidades próximas aos níveis 10, 20 e 30 [marcos provisórios].
- [x] Criar alvos/bots locais simples para testes; sem matchmaking nesta release.
**Aceite:** quatro classes com estilos distintos e habilidades funcionais, sem alterar a regra comum de dano a blocos.

**Evidência 0.3:** `tests/release03_smoke.gd` cobre atributos, crescimento, XP por dano efetivo e eliminação, proteção, cura, recargas, congelamento, barreira, invisibilidade com velocidade, armadilha e cobertura por caixa/parede. As suítes 0.1 e 0.2 seguem passando. Playtest em celular pendente.

## Release 0.4 — Regras da partida
**Objetivo:** concluir o ciclo de uma partida local.
- [x] Suportar 2–5 participantes na lógica de partida (bots inicialmente).
- [x] Posicionar jogadores em áreas iniciais protegidas; definir spawn do quinto participante [Pendente].
- [x] Eliminação definitiva, sem respawn; espectador após eliminação.
- [x] Encerrar imediatamente quando restar um sobrevivente, sem duração mínima.
- [x] Cronômetro com duração máxima de 8 minutos.
- [x] Iniciar aviso e fechamento progressivo da arena por volta de 5 minutos [Provisório].
- [x] Fechamento por paredes intransponíveis nas bordas; remover itens engolidos pelo fechamento.
- [x] Implementar condição de término aos 8 minutos e desempate/morte simultânea [Pendente].
- [x] Exibir resultado e permitir iniciar outra partida; limpar nível, XP, atributos temporários e itens.
**Aceite:** partida local termina por último sobrevivente ou limite de tempo, sem progressão de combate persistente.

**Evidência 0.4:** `tests/release04_smoke.gd` passou para 2–5 participantes, fechamento, paredes físicas, remoção de itens, eliminação, espectador, limite de tempo, empate provisório e reinício por toque. Suítes 0.1–0.3 seguem passando; playtest em celular pendente.

## Release 0.5 — Identidade, personagem e configurações
**Objetivo:** estruturar a experiência de conta sem conceder vantagens permanentes.
- [x] Criar fluxo de login/cadastro (primeiro simulado localmente; autenticação real ligada ao backend na fase online).
- [x] Criar um nome permanente de personagem por conta; ID interno separado do nome.
- [x] Validar nome único ignorando caixa, de 3 a 16 caracteres, letras/números/sublinhado [regras provisórias].
- [x] Criar menu principal com Arena, Perfil e Configurações.
- [x] Criar tela de configurações salvas, inspirada em decks do Magic Arena: criar, nomear, editar, excluir e selecionar presets.
- [x] Cada preset inicial contém nome da configuração e classe escolhida; permitir vários presets da mesma classe.
- [x] Na entrada da Arena, selecionar preset/classe antes de entrar na fila.
- [x] Preservar apenas identidade, presets e histórico; reiniciar nível 1, XP, atributos e inventário a cada partida.
- [x] Planejar armazenamento de histórico, vitórias e derrotas; ranking pode vir depois.
**Aceite:** jogador mantém nome e configurações entre partidas, mas não leva vantagens de combate permanentes.

**Evidência 0.5:** `tests/release05_smoke.gd` passou para validação do nome, ID interno, dois presets da mesma classe, edição, seleção, exclusão, persistência, histórico local e reinício sem vantagem. As suítes 0.1–0.4 seguem passando; unicidade global e login real dependem do backend.

**Correção 0.5.2:** `tests/health_damage_regression.gd` passou para HP estável sem ataque, dano só no impacto de projétil visível, desvio e cobertura.

## Release 0.6 — Multiplayer online
**Objetivo:** partidas reais de 2–5 jogadores.
**Ordem atual:** adiada para depois da 0.7. A base inicial está preservada na branch `release/0.6`.
- [ ] Definir arquitetura de servidor dedicado autoritativo, preferencialmente Godot headless/GDScript na primeira versão.
- [ ] Implementar autenticação real e persistência de conta, nome e presets.
- [ ] Implementar criação/entrada em sala ou fila de 2–5 jogadores.
- [ ] Sincronizar movimento, ataques, habilidades, colisões, destruição de blocos, drops, inventário, XP e eliminações.
- [ ] Validar no servidor dano, cooldowns, coleta, evolução e resultados.
- [ ] Implementar tratamento de latência, desconexão, abandono e reconexão [política pendente].
- [ ] Testar partidas em múltiplos dispositivos e condições de rede.
**Aceite:** partida online consistente, com resultado decidido pelo servidor.

## Release 0.7 — Arte, animação e interface mobile
**Objetivo:** substituir os placeholders sem comprometer a legibilidade.
**Fechamento técnico:** código, documentação e testes automatizados da etapa atual concluídos; os itens desmarcados seguem como pendências de aceite ou trabalho futuro. A release não recebeu aceite final em aparelho real.
- [x] Criar pasta `assets/characters/swordsman/` e integrar as quatro animações de caminhada fornecidas pelo responsável como teste visual da classe Paladino.
- [ ] Receber ou criar folhas de ataque, dano, morte e parado para o Espadachim; decidir se ele substitui definitivamente o Paladino ou será uma classe distinta.
- [x] Prototipar mapa maior que a tela, câmera seguindo o personagem e HUD fixo em `CanvasLayer`.
- [x] Extrair dimensões, spawns e obstáculos para um layout lógico compartilhado e definir a conversão X/Y do chão para X/Z em uma futura cena 3D.
- [ ] Comparar zoom e validar legibilidade da nova escala em celular.
- [x] Separar o HUD em `CanvasLayer`, mantendo o mapa e os controles atuais como primeira etapa do protótipo.
- [x] Adicionar minimapa provisório com limites, área segura e posição do jogador, sem revelar oponentes.
- [x] Posicionar o minimapa no canto superior direito e retirar botões de depuração da interface jogável.
- [x] Fazer o golpe em linha atingir alvos nos dois primeiros quadros sem atravessar paredes.
- [x] Criar guia de estilo provisório e atlas pixelados originais das quatro classes com cinco estados de animação.
- [x] Criar tiles pixelados de caixa e parede e ícones dos seis itens, gerados de forma reproduzível.
- [x] Integrar sprites do personagem, obstáculos e itens; compactar HUD e separar alvos de toque de ataque e habilidades.
- [x] Adicionar sinais de áudio provisórios para impacto, coleta, habilidade e eliminação.
- [ ] Produzir efeitos visuais específicos das habilidades e arte final com mais quadros e direções.
- [ ] Medir legibilidade, toque e desempenho em aparelhos Android reais e múltiplas proporções.
- [ ] Definir identidade visual original inspirada em fantasia pixel art top-down 3/4, sem copiar assets de jogos existentes.
- [ ] Criar visual consistente para Paladino, Mago, Assassino e Arqueiro.
- [ ] Produzir sprites/sprite sheets de idle, caminhada, ataque, dano, morte e efeitos das habilidades.
- [ ] Criar tiles de madeira, pedra, chão, itens e efeitos do fechamento.
- [ ] Refinar HUD paisagem: HP e quatro slots de itens no alto à esquerda, cronômetro central, joystick à esquerda e ataque + três habilidades à direita.
- [ ] Testar legibilidade, tamanhos dos botões e ergonomia em telas Android reais.
- [ ] Implementar áudio, feedback de dano, coleta, XP e efeitos temporários.
**Aceite:** interface clara no celular, sprites animados e desempenho adequado.

## Release 1.0 — Beta, balanceamento e lançamento
- [x] Atualizar versão do preset Android e gerar APK de depuração local reproduzível. Isso não satisfaz a assinatura e distribuição final.
- [ ] Instalar e validar o APK em aparelhos Android reais.
- [ ] Testar partidas completas de 2–5 jogadores.
- [ ] Balancear atributos, cooldowns, XP, drops e fechamento da arena a partir de testes reais.
- [ ] Testar classes em confrontos variados; preservar contra-jogo por mapa, habilidades e recargas.
- [ ] Corrigir bugs de sincronização, performance e usabilidade.
- [ ] Configurar builds Android e distribuição de testes.
- [ ] Preparar publicação, política de privacidade, informações da loja e monitoramento básico.
- [ ] Verificar disponibilidade comercial e jurídica do nome provisório **RagnArena**.
**Aceite:** build Android estável e testada para lançamento inicial.

## Fora do escopo inicial / ideias futuras
- [ ] Construções de habilidades (builds) com escolhas diferentes por classe, sem vantagens permanentes injustas.
- [ ] Personalizações cosméticas.
- [ ] Rankings e temporadas.
- [ ] Modo aventura persistente.
- [ ] Sistema de mira/travamento de alvo por pressionamento prolongado (explicitamente adiado).
- [ ] Monetização (modelo ainda não definido).

## Pendências de design para fechar com testes
1. Curva completa de XP e valores de XP por bloco, dano e eliminação.
2. Atributos-base e progressão exata de cada classe; cooldowns e efeitos finais.
3. Pesos relativos dos seis itens dentro dos 30% de chance de drop.
4. Desenho do mapa, spawn do quinto jogador e ritmo do fechamento.
5. Desempate por tempo ou mortes simultâneas.
6. Regras finais de inventário (empilhamento e expiração) e nome de personagem.
7. Política de desconexão/reconexão e formação de salas.
8. Regras para presets futuros além de nome + classe.

## Documentação contínua
- `docs/GAME_DESIGN.md`: regras aprovadas e parâmetros provisórios.
- `docs/BACKLOG.md`: releases, critérios de aceite, tarefas e pendências (este conteúdo).
- `docs/CHANGELOG.md`: alterações implementadas por versão.
- Em cada solicitação futura ao Codex, exigir atualização desses arquivos Markdown e indicação dos testes executados.
