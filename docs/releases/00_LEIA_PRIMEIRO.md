# RagnArena — Guia de execução

**Nome provisório:** RagnArena. **Engine:** Godot 4. **Linguagem:** GDScript. **Alvo:** Android em paisagem. **Método:** releases incrementais, com protótipo offline primeiro.

## Como usar
1. Coloque os arquivos desta pasta em `docs/releases/` no repositório.
2. Crie `docs/GAME_DESIGN.md`, `docs/BACKLOG.md`, `docs/CHANGELOG.md` e `docs/PENDENCIAS.md` a partir das orientações do `09_DECISOES_E_PENDENCIAS.md`.
3. Envie ao Codex uma release por vez, começando por `01_MVP_0_1_ARENA.md`.
4. Exija relatório final de implementação, testes e pendências; valide antes de iniciar a próxima.
5. Não executar releases dependentes em paralelo no mesmo branch; tarefas independentes podem ser paralelizadas com branches separados e revisão.

## Prompt reutilizável para Codex
> Leia `docs/releases/00_LEIA_PRIMEIRO.md`, `docs/releases/09_DECISOES_E_PENDENCIAS.md` e `docs/releases/XX_...md`. Implemente apenas a release indicada. Não invente regras definitivas. Execute os testes disponíveis e atualize obrigatoriamente os arquivos Markdown de backlog, changelog, pendências e relatório da release. Ao concluir, informe arquivos alterados, testes executados, critérios de aceite atendidos e limitações. Não comece a próxima release sem aprovação.

## Status
As releases 0.1, 0.2 e 0.3 foram implementadas e validadas em modo headless; a validação manual da 0.3 em celular está pendente. As releases seguintes permanecem planejadas. Números de balanceamento são hipóteses iniciais, sujeitos a testes.
