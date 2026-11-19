# RagnArena — MVP 0.6 — Multiplayer e backend

**Status:** Planejada

## Objetivo
Transformar o protótipo em partidas online de 2–5 jogadores com servidor autoritativo.
## Tarefas
- [ ] Definir arquitetura cliente/servidor, protocolo, modelo de salas, hospedagem e limites de custo antes de implementar.
- [ ] Implementar autenticação apropriada e identidade persistente; validar nomes únicos no servidor.
- [ ] Criar fila/sala de 2 a 5 jogadores, escolha de configuração e início sincronizado.
- [ ] Servidor autoritativo para movimento validado, ataques, dano, colisão, XP, itens, inventário, buffs, eliminações, tempo e fechamento.
- [ ] Sincronizar estado com interpolação/predição apenas quando necessário; tratar latência e perda de pacotes.
- [ ] Implementar desconexão, abandono, timeout e espectador; definir política de reconexão antes de codificar.
- [ ] Registrar resultados e estatísticas persistentes com proteção básica contra manipulação pelo cliente.
- [ ] Testar partidas reais com 2, 3, 4 e 5 clientes, inclusive rede instável e ações simultâneas.
## Critérios de aceite
- Cinco clientes conseguem concluir uma partida sem divergência de vencedor/HP/itens/XP.
- Cliente não pode informar arbitrariamente dano, XP ou vitória; servidor decide.
## Pendências de decisão
Hospedagem, provedor de autenticação, custos, reconexão, abandono e empate.

## Contrato de execução do Codex
- Ler `docs/GAME_DESIGN.md`, `docs/BACKLOG.md` e os documentos da release antes de alterar código.
- Implementar somente o escopo desta release; registrar dependências ou dúvidas em `docs/PENDENCIAS.md`, sem inventar regras definitivas.
- Manter Godot 4 + GDScript; cenas e scripts desacoplados, dados de balanceamento configuráveis e recursos visuais provisórios.
- Ao terminar, executar testes disponíveis, registrar comandos, resultados, limitações e passos manuais de validação.
- Criar/atualizar obrigatoriamente `docs/CHANGELOG.md`, `docs/BACKLOG.md`, `docs/RELATORIOS/RELATORIO_06.md` e documentação técnica pertinente. Não marcar como concluído sem teste/evidência.
- Não iniciar a próxima release automaticamente se houver erros bloqueantes. Preparar commit/PR quando houver repositório remoto configurado; não alegar publicação sem realizá-la.
