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

## Releases futuras

As regras planejadas de classes, partida, conta e multiplayer estão em `BACKLOG.md`. Valores indicados como provisórios devem ser validados em testes de gameplay.
