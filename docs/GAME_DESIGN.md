# RagnArena — regras de jogo

## Release 0.1

- Visão top-down, movimento contínuo em 360° e direção de ataque indicada pelo personagem. A última direção de movimento é preservada quando o personagem para.
- Madeira destrutível com 45 HP; pedra e bordas permanentes.
- Dano em blocos comum a todas as classes: níveis 1–3 = 15, 4–7 = 23, 8–30 = 45.
- Cadência comum de ataque: 0,42 s no protótipo [Provisório, configurável em `arena.tscn`].
- Alcance do ataque básico: 92 px [Provisório].
- Velocidade de movimento: 260 px/s [Provisório].
- Mapa com blocos posicionados fora de grade rígida, usando formas geométricas. Quatro áreas de spawn de teste estão livres de caixas e têm cobertura de pedra no lado interno [Provisório].
- Nível de teste configurável de 1 a 30 no Inspector. Não há XP ou progressão nesta release.
- O ataque da release 0.1 consulta apenas obstáculos; dano PvP é uma regra separada a ser implementada na release 0.3.
- Resolução lógica 1280×720 com escala proporcional e orientação Android em paisagem.

## Release 0.2

- Nível 1–30 somente durante a partida. Cada caixa destruída concede 20 XP inicialmente [Provisório]. A meta do próximo nível é `arredondar(20 × 1,22^(nível − 1))` [Provisório]; nível 30 é o limite.
- Drop por caixa: 30% [Provisório]. Pesos iniciais [Provisórios]: Poção 30, Força 15, Botas 15, Escudo 15, Elixir 10, Amuleto XP 15. Todos os números ficam em `resources/balance.tres`.
- Itens no chão são coletados ao se aproximar; se o inventário estiver cheio, permanecem até coleta posterior ou 20 s [Provisório]. A remoção por fechamento da arena tem um gancho pronto; o fechamento em si pertence à release 0.4.
- Quatro slots de uso rápido. Poção e Elixir iguais empilham até três por slot. Força, Botas e Escudo ocupam um slot por unidade. O Amuleto XP ativa automaticamente e não usa slot.
- Poção cura 30% do HP máximo; Elixir cura 60%; HP máximo inicial 100 [Provisório]. Cura não ultrapassa o máximo e um item de cura não é consumido com HP cheio.
- Força aumenta em 20% o futuro dano PvP por 15 s; Botas aumentam em 15% a velocidade por 12 s; Escudo absorve 30 de dano ou dura 15 s; Amuleto aumenta XP em 25% por 15 s [todos Provisórios]. Buff igual ativado novamente renova duração sem somar potência. Para itens manuais, a coleta armazena e o uso ativa; a nova coleta do Amuleto renova automaticamente.
- Uso manual tem intervalo global de 2 s [Provisório]. Slots usam teclas 1–4 ou toque. Buffs e itens são limpos ao reiniciar.
- XP por dano PvP efetivo e eliminação tem funções preparadas, sem inimigos ou concessão fictícia nesta release.

## Release 0.3

- Quatro classes com atributos PvP provisórios em `resources/classes.tres`: Paladino resistente e corpo a corpo; Mago de controle e projéteis; Assassino ágil e furtivo; Arqueiro de alcance e armadilhas. HP, dano, defesa, alcance, velocidade, cadência e três recargas são configuráveis.
- Ataque básico na direção do olhar, repetido enquanto pressionado. A regra comum de dano e cadência contra caixas permanece independente da cadência PvP. Paredes e caixas bloqueiam projéteis; habilidades não multiplicam dano contra caixas.
- Paladino: Proteção Divina (Q) cria barreira temporária, Cura (E) recupera HP e Determinação (F) impede empurrão temporariamente; redução passiva de dano à distância. Determinação não impede congelamento.
- Mago: gelo com congelamento curto, barreira absorvente e bola de fogo. Assassino: invisibilidade até atacar, lâmina arremessada e velocidade; invisibilidade e velocidade podem coexistir. Arqueiro: rajada, impacto com empurrão e armadilha que imobiliza.
- Dano efetivo contra bots concede XP sem contar dano acima do HP restante; eliminação concede bônus. HP e dano crescem por nível; habilidades recebem bônus provisórios nos níveis 10, 20 e 30.
- Dois bots locais estacionários atacam ao alcance e servem para testar combate offline. Troca de classe por `Tab` ou botão **Classe** reinicia HP e recargas para facilitar comparação no protótipo. Isso não define fluxo de seleção de classe da release 0.5.
- A partir da correção 0.5.2, ataques dos bots são projéteis vermelhos visíveis; o dano ocorre apenas no impacto. Paredes e movimento podem bloquear ou desviar o disparo.

## Release 0.4

- A partida offline começa com jogador e 1–4 bots locais, configurável em `resources/match.tres`. Todos começam no nível 1, sem itens. O quinto spawn provisório fica no centro da arena; precisa de playtest.
- Eliminação não tem respawn. Quando o jogador morre, pode alternar o nome do sobrevivente observado; a arena inteira continua visível. A partida termina assim que resta um sobrevivente, mesmo antes do limite.
- Limite máximo de oito minutos. Se houver mais de um sobrevivente no limite, o protótipo registra **empate por tempo**; se todos morrerem simultaneamente, registra **empate**. Desempate definitivo permanece pendente.
- Aviso 30 s antes do fechamento, iniciado aos 5 minutos [Provisório]. Bordas avançam gradualmente até o fim do tempo. Paredes físicas bloqueiam movimento e projéteis; itens cobertos são removidos e participantes alcançados são conduzidos para dentro da área segura [Provisório].
- Resultado mostra vencedor ou empate, nível, XP e caixas destruídas. Nova partida recarrega a cena e limpa progresso, itens, efeitos, bots e caixas.

## Release 0.5

- Entrada local simulada. O dispositivo guarda um perfil com ID interno separado do nome do personagem. Nome de 3–16 caracteres ASCII, letras, números ou `_` [Provisório]; não pode ser alterado depois de criado neste perfil. Unicidade global dependerá do backend.
- Menu com Arena, Perfil e Configurações. Antes da arena, o jogador escolhe uma configuração salva. Podem existir várias configurações da mesma classe; cada uma guarda apenas ID, nome e classe. Habilidades permanecem fixas por classe.
- Perfil, configurações selecionadas e histórico local de até 50 resultados ficam em `user://profile_v1.json`. Dados de combate não são persistidos. Reiniciar a partida começa no nível 1, HP cheio, XP zero e inventário vazio.
- O histórico local serve para teste e não é confiável para ranking. Autenticação, unicidade global e persistência remota pertencem à release 0.6.

## Protótipo visual 0.7

- O ataque básico em linha alcança provisoriamente 152 unidades (aproximadamente dois quadros). Um golpe pode atingir o primeiro e o segundo alvo alinhados, cada um uma vez; parede de pedra ou fechamento interrompe o trajeto. Caixas mantêm o dano comum por nível; Paladino e Assassino também acertam oponentes nesse alcance. O terceiro quadro não é atingido.
- Toque ou clique em uma caixa ou oponente seleciona o alvo. O Paladino se aproxima até ter linha de ataque e golpeia; o botão de ataque também usa o alvo selecionado. Movimento manual interrompe a aproximação automática. O golpe parte da posição física do jogador para alcançar caixas encostadas.
- Arena de teste ampliada para 2560×1440 unidades, com área jogável interna de 2456×1336 e câmera seguindo o jogador em zoom 1,05 [Provisório]. O HUD permanece em coordenadas de tela.
- Spawns nos quatro cantos protegidos; quinto spawn no centro [Provisório]. Caixas de teste aumentadas de 12 para 24 para cobrir o mapa maior. O fechamento máximo passa provisoriamente a 480 unidades por borda.
- Minimap mostra somente o jogador e a área segura. Não revela a localização de oponentes fora da tela.

## Releases futuras

As regras planejadas de classes, partida, conta e multiplayer estão em `BACKLOG.md`. Valores indicados como provisórios devem ser validados em testes de gameplay.
