# RagnArena — Release 1.0 — Beta e publicação

**Status:** Planejada

## Objetivo
Entregar versão Android estável, com testes e distribuição controlada antes do lançamento público.
## Tarefas
- [ ] Executar testes regressivos de movimentação, colisão, combate, XP, itens, encerramento e multiplayer.
- [ ] Balancear quatro classes e itens com dados de partidas; registrar ajustes e motivos.
- [ ] Configurar exportação Android, assinatura, versão, ícone, permissões e pacote.
- [ ] Automatizar verificações e, se viável, builds APK/AAB em CI; disponibilizar artefatos de teste.
- [ ] Realizar testes fechados com múltiplos aparelhos e redes; corrigir bugs bloqueantes.
- [ ] Criar política de privacidade e informações de loja compatíveis com recursos efetivamente usados.
- [ ] Verificar disponibilidade comercial de `RagnArena` (nome provisório) antes de publicação.
- [ ] Documentar implantação, monitoramento, rollback e custos operacionais do servidor.
## Critérios de aceite
- Build Android instalável, fluxo completo de login a resultado e testes de multiplayer documentados.
- Sem falhas críticas conhecidas; publicação apenas após revisão humana e requisitos da loja.

## Contrato de execução do Codex
- Ler `docs/GAME_DESIGN.md`, `docs/BACKLOG.md` e os documentos da release antes de alterar código.
- Implementar somente o escopo desta release; registrar dependências ou dúvidas em `docs/PENDENCIAS.md`, sem inventar regras definitivas.
- Manter Godot 4 + GDScript; cenas e scripts desacoplados, dados de balanceamento configuráveis e recursos visuais provisórios.
- Ao terminar, executar testes disponíveis, registrar comandos, resultados, limitações e passos manuais de validação.
- Criar/atualizar obrigatoriamente `docs/CHANGELOG.md`, `docs/BACKLOG.md`, `docs/RELATORIOS/RELATORIO_08.md` e documentação técnica pertinente. Não marcar como concluído sem teste/evidência.
- Não iniciar a próxima release automaticamente se houver erros bloqueantes. Preparar commit/PR quando houver repositório remoto configurado; não alegar publicação sem realizá-la.
