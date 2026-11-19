# RagnArena — MVP 0.4 — Regras de partida

**Status:** Planejada

## Objetivo
Fechar o ciclo de uma partida offline simulada antes de implementar rede.
## Tarefas
- [ ] Criar estado da partida: preparação, em andamento, encerrada e resultados.
- [ ] Suportar simulação de 2 a 5 participantes (jogador + bots/alvos automatizados para teste).
- [ ] Todos iniciam nível 1, inventário vazio e atributos iniciais da classe.
- [ ] Eliminação definitiva na partida, sem respawn; permitir observar os sobreviventes.
- [ ] Encerrar imediatamente quando restar apenas um jogador, inclusive antes de 8 minutos.
- [ ] Cronômetro com duração MÁXIMA de 8 minutos, sem duração mínima.
- [ ] Após cerca de 5 minutos, avisar e iniciar fechamento gradual das bordas por paredes intransponíveis; ajustar cronograma em configuração.
- [ ] Remover itens cobertos pela zona fechada; evitar prender personagens sem aviso/contrajogo razoável.
- [ ] Tela de resultado com vencedor e estatísticas mínimas; empate ou desempate em eliminações simultâneas fica como decisão pendente.
- [ ] Reiniciar estado integral entre partidas: nível, XP, HP, buffs, itens e caixas.
## Critérios de aceite
- Partida termina por último sobrevivente ou regra de limite de tempo; nenhum estado de partida anterior vaza para a seguinte.
- Fechamento e encerramento funcionam com 2, 3, 4 e 5 participantes simulados.

## Contrato de execução do Codex
- Ler `docs/GAME_DESIGN.md`, `docs/BACKLOG.md` e os documentos da release antes de alterar código.
- Implementar somente o escopo desta release; registrar dependências ou dúvidas em `docs/PENDENCIAS.md`, sem inventar regras definitivas.
- Manter Godot 4 + GDScript; cenas e scripts desacoplados, dados de balanceamento configuráveis e recursos visuais provisórios.
- Ao terminar, executar testes disponíveis, registrar comandos, resultados, limitações e passos manuais de validação.
- Criar/atualizar obrigatoriamente `docs/CHANGELOG.md`, `docs/BACKLOG.md`, `docs/RELATORIOS/RELATORIO_04.md` e documentação técnica pertinente. Não marcar como concluído sem teste/evidência.
- Não iniciar a próxima release automaticamente se houver erros bloqueantes. Preparar commit/PR quando houver repositório remoto configurado; não alegar publicação sem realizá-la.
