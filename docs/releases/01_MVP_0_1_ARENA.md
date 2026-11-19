# RagnArena — MVP 0.1 — Arena e controles

**Status:** Implementada; testes headless aprovados, validação manual em Android pendente

## Objetivo
Criar uma arena offline jogável com formas geométricas, movimentação e destruição de blocos.
## Tarefas
- [x] Inicializar projeto Godot 4, resolução horizontal adaptável e cenas `main`, `arena`, `player`, `crate`, `wall`.
- [x] Criar mapa de teste com posições de spawn protegidas, paredes permanentes e caixas destrutíveis sem padrão rígido de tabuleiro.
- [x] Implementar movimentação contínua em 360°, joystick virtual provisório e controles de teclado para depuração.
- [x] Implementar colisão de jogador com paredes/caixas e impedir sair dos limites.
- [x] Implementar direção de olhar a partir do último movimento; ataque básico direcional, segurando para repetir no ritmo configurado.
- [x] Caixas têm 45 HP; dano igual para todas as classes: níveis 1–3 = 15, 4–7 = 23, 8–30 = 45. Nesta release usar nível de teste configurável.
- [x] Separar dano contra caixas de dano PvP; ataques não atravessam obstáculos.
- [x] Exibir contadores provisórios de caixas destruídas e nível de teste.
## Critérios de aceite
- Jogador move-se no celular e no desktop, sem atravessar paredes.
- Ataques respeitam a direção e a cadência; caixa de 45 HP é destruída em 3/2/1 golpes conforme faixa.
- Arena pode ser reiniciada sem erros; arte final não é exigida.

## Contrato de execução do Codex
- Ler `docs/GAME_DESIGN.md`, `docs/BACKLOG.md` e os documentos da release antes de alterar código.
- Implementar somente o escopo desta release; registrar dependências ou dúvidas em `docs/PENDENCIAS.md`, sem inventar regras definitivas.
- Manter Godot 4 + GDScript; cenas e scripts desacoplados, dados de balanceamento configuráveis e recursos visuais provisórios.
- Ao terminar, executar testes disponíveis, registrar comandos, resultados, limitações e passos manuais de validação.
- Criar/atualizar obrigatoriamente `docs/CHANGELOG.md`, `docs/BACKLOG.md`, `docs/RELATORIOS/RELATORIO_01.md` e documentação técnica pertinente. Não marcar como concluído sem teste/evidência.
- Não iniciar a próxima release automaticamente se houver erros bloqueantes. Preparar commit/PR quando houver repositório remoto configurado; não alegar publicação sem realizá-la.

