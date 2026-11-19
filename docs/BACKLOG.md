# RagnArena — Backlog de releases

**Status:** release 0.1 implementada e validada em modo headless; validação manual em Android pendente.  
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
- [ ] Implementar XP por bloco destruído e evolução automática de nível 1 a 30.
- [ ] Criar curva de XP configurável: níveis iniciais rápidos, progressão posterior mais lenta; sem exigir nível 30 em toda partida.
- [ ] Implementar chance inicial de 30% de drop por bloco destruído [Provisório].
- [ ] Implementar distribuição ponderada de seis itens [pesos pendentes].
- [ ] Implementar coleta automática e quatro espaços de inventário rápido.
- [ ] Se inventário cheio, deixar item no chão.
- [ ] Implementar Poção de Vida (+30% HP máximo), Bônus de Força (+20% dano PvP, 15 s), Botas de Velocidade (+15% velocidade, 12 s), Escudo Protetor (absorve 30 de dano ou dura 15 s), Elixir de Recuperação (+60% HP máximo) e Amuleto de XP (+25% XP, 15 s, ativação automática sem ocupar espaço).
- [ ] Implementar uso manual dos cinco itens armazenáveis e intervalo global provisório de 2 s.
- [ ] Implementar empilhamento inicial de até três poções iguais por slot; buffs ocupam um slot por unidade [Provisório].
- [ ] Impedir cura acima do HP máximo; buffs iguais não acumulam, nova coleta renova duração.
- [ ] Exibir quantidade e duração dos efeitos na HUD provisória.
- [ ] Remover itens no chão após até 20 s [Provisório].
**Aceite:** destruir bloco, ganhar XP, subir nível, coletar e usar itens com efeitos e limites corretos.

## Release 0.3 — Classes e combate PvP local
**Objetivo:** validar diferenças entre as quatro classes antes da rede.
- [ ] Implementar Paladino (resistência, ataque corpo a corpo, proteção contra dano à distância, autocura, Determinação/Endure).
- [ ] Implementar Mago (baixa resistência, magia à distância, Rajada de Gelo/congelamento, Barreira Arcana, Bola de Fogo).
- [ ] Implementar Assassino (corpo a corpo rápido, Invisibilidade, Lâmina Arremessada, Passos Velozes; permitir invisibilidade + velocidade).
- [ ] Implementar Arqueiro (longo alcance, Rajada de Flechas, Flecha de Impacto/repulsão, Armadilha/imobilização).
- [ ] Implementar ataque básico e três habilidades ativas por classe, acionadas manualmente.
- [ ] Implementar HP, dano PvP, defesa, alcance, velocidade e recargas configuráveis por classe.
- [ ] Implementar colisão de projéteis com blocos e paredes; cobertura relevante para classes corpo a corpo.
- [ ] Implementar XP por dano efetivamente causado e bônus por eliminação.
- [ ] Implementar crescimento de atributos por nível e melhorias de habilidades próximas aos níveis 10, 20 e 30 [marcos provisórios].
- [ ] Criar alvos/bots locais simples para testes; sem matchmaking nesta release.
**Aceite:** quatro classes com estilos distintos e habilidades funcionais, sem alterar a regra comum de dano a blocos.

## Release 0.4 — Regras da partida
**Objetivo:** concluir o ciclo de uma partida local.
- [ ] Suportar 2–5 participantes na lógica de partida (bots inicialmente).
- [ ] Posicionar jogadores em áreas iniciais protegidas; definir spawn do quinto participante [Pendente].
- [ ] Eliminação definitiva, sem respawn; espectador após eliminação.
- [ ] Encerrar imediatamente quando restar um sobrevivente, sem duração mínima.
- [ ] Cronômetro com duração máxima de 8 minutos.
- [ ] Iniciar aviso e fechamento progressivo da arena por volta de 5 minutos [Provisório].
- [ ] Fechamento por paredes intransponíveis nas bordas; remover itens engolidos pelo fechamento.
- [ ] Implementar condição de término aos 8 minutos e desempate/morte simultânea [Pendente].
- [ ] Exibir resultado e permitir iniciar outra partida; limpar nível, XP, atributos temporários e itens.
**Aceite:** partida local termina por último sobrevivente ou limite de tempo, sem progressão de combate persistente.

## Release 0.5 — Identidade, personagem e configurações
**Objetivo:** estruturar a experiência de conta sem conceder vantagens permanentes.
- [ ] Criar fluxo de login/cadastro (primeiro simulado localmente; autenticação real ligada ao backend na fase online).
- [ ] Criar um nome permanente de personagem por conta; ID interno separado do nome.
- [ ] Validar nome único ignorando caixa, de 3 a 16 caracteres, letras/números/sublinhado [regras provisórias].
- [ ] Criar menu principal com Arena, Perfil e Configurações.
- [ ] Criar tela de configurações salvas, inspirada em decks do Magic Arena: criar, nomear, editar, excluir e selecionar presets.
- [ ] Cada preset inicial contém nome da configuração e classe escolhida; permitir vários presets da mesma classe.
- [ ] Na entrada da Arena, selecionar preset/classe antes de entrar na fila.
- [ ] Preservar apenas identidade, presets e histórico; reiniciar nível 1, XP, atributos e inventário a cada partida.
- [ ] Planejar armazenamento de histórico, vitórias e derrotas; ranking pode vir depois.
**Aceite:** jogador mantém nome e configurações entre partidas, mas não leva vantagens de combate permanentes.

## Release 0.6 — Multiplayer online
**Objetivo:** partidas reais de 2–5 jogadores.
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
- [ ] Definir identidade visual original inspirada em fantasia pixel art top-down 3/4, sem copiar assets de jogos existentes.
- [ ] Criar visual consistente para Paladino, Mago, Assassino e Arqueiro.
- [ ] Produzir sprites/sprite sheets de idle, caminhada, ataque, dano, morte e efeitos das habilidades.
- [ ] Criar tiles de madeira, pedra, chão, itens e efeitos do fechamento.
- [ ] Refinar HUD paisagem: HP e quatro slots de itens no alto à esquerda, cronômetro central, joystick à esquerda e ataque + três habilidades à direita.
- [ ] Testar legibilidade, tamanhos dos botões e ergonomia em telas Android reais.
- [ ] Implementar áudio, feedback de dano, coleta, XP e efeitos temporários.
**Aceite:** interface clara no celular, sprites animados e desempenho adequado.

## Release 1.0 — Beta, balanceamento e lançamento
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

