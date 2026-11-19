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

## Releases futuras

As regras planejadas de progressão, itens, classes, partida, conta e multiplayer estão em `BACKLOG.md`. Valores indicados como provisórios devem ser validados em testes de gameplay.
