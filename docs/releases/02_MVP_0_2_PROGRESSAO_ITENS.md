# RagnArena — MVP 0.2 — XP, consumíveis e inventário

**Status:** Implementada e testada em Godot headless; validação em celular pendente

## Objetivo
Validar o ciclo destruir caixa → ganhar XP → subir nível → obter/usar item.
## Tarefas
- [x] Implementar níveis 1–30 por partida, XP por caixa e curva configurável (rápida no início, mais lenta depois).
- [x] Preparar fontes futuras de XP por dano PvP efetivo e eliminação, sem fingir que já existem inimigos.
- [x] Atualizar dano contra caixas por faixa de nível; não atrelar ao ataque PvP.
- [x] Sortear drop em caixas: chance inicial provisória de 30%; pesos por item configuráveis.
- [x] Itens: Poção Vida +30% HP máximo; Força +20% dano PvP por 15 s; Velocidade +15% por 12 s; Escudo absorve 30 dano ou dura 15 s; Elixir +60% HP máximo; Amuleto XP +25% por 15 s.
- [x] Amuleto XP ativa automaticamente ao coletar e não ocupa inventário; demais itens coletados automaticamente para quatro slots de acesso rápido, uso manual.
- [x] Poções iguais empilham até 3/slot; outros consumíveis 1/slot; inventário cheio deixa item no chão.
- [x] Efeitos temporários iguais não somam potência; nova ativação renova duração; intervalo global provisório de 2 s entre usos manuais.
- [x] Recuperação não ultrapassa HP máximo; efeitos expiram corretamente; itens desaparecem após 20 s ou ao serem cobertos pelo fechamento futuro.
- [x] Interface provisória de HP, XP, nível, quatro slots, quantidade e tempo restante dos buffs.
## Critérios de aceite
- XP, subida de nível, drop, coleta, empilhamento, uso e expiração verificáveis.
- Todos os parâmetros ajustáveis em recurso/dados sem alterar lógica; ao reiniciar partida, XP/inventário zeram.
## Pontos de balanceamento ainda provisórios
Chance de drop, pesos, duração, bônus e intervalo de uso precisam de playtest; não fixar como regras imutáveis.

## Contrato de execução do Codex
- Ler `docs/GAME_DESIGN.md`, `docs/BACKLOG.md` e os documentos da release antes de alterar código.
- Implementar somente o escopo desta release; registrar dependências ou dúvidas em `docs/PENDENCIAS.md`, sem inventar regras definitivas.
- Manter Godot 4 + GDScript; cenas e scripts desacoplados, dados de balanceamento configuráveis e recursos visuais provisórios.
- Ao terminar, executar testes disponíveis, registrar comandos, resultados, limitações e passos manuais de validação.
- Criar/atualizar obrigatoriamente `docs/CHANGELOG.md`, `docs/BACKLOG.md`, `docs/RELATORIOS/RELATORIO_02.md` e documentação técnica pertinente. Não marcar como concluído sem teste/evidência.
- Não iniciar a próxima release automaticamente se houver erros bloqueantes. Preparar commit/PR quando houver repositório remoto configurado; não alegar publicação sem realizá-la.
