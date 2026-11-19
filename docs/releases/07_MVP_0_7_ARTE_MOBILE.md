# RagnArena — MVP 0.7 — Arte e usabilidade mobile

**Status:** Planejada

## Objetivo
Substituir placeholders por identidade visual original e ajustar ergonomia Android.
## Tarefas
- [ ] Criar guia de estilo pixel art top-down 3/4, com personagens originais e escala coerente.
- [ ] Criar sprites das quatro classes, animações idle/caminhada/ataque/dano/morte, efeitos de habilidade, caixas, paredes e itens.
- [ ] Usar como referência visual a arena vibrante aprovada, sem copiar assets de Ragnarök/Bomberman.
- [ ] Preparar sprite sheets e importação Godot; tamanho inicial de estudo: personagem 64×64 por quadro e tile 32×32, sujeito a teste.
- [ ] Refinar joystick à esquerda; ataque básico e três habilidades à direita; quatro slots de itens próximos ao HP; cronômetro central.
- [ ] Testar legibilidade, áreas de toque, desempenho, múltiplas resoluções e proporções de tela Android.
- [ ] Implementar áudio e feedback visual mínimo para acerto, coleta, habilidade e eliminação.
## Critérios de aceite
- Todas as classes visualmente distinguíveis; comandos utilizáveis em aparelho real sem sobreposição.
- Efeitos não prejudicam leitura do combate; performance medida em aparelhos de teste.

## Contrato de execução do Codex
- Ler `docs/GAME_DESIGN.md`, `docs/BACKLOG.md` e os documentos da release antes de alterar código.
- Implementar somente o escopo desta release; registrar dependências ou dúvidas em `docs/PENDENCIAS.md`, sem inventar regras definitivas.
- Manter Godot 4 + GDScript; cenas e scripts desacoplados, dados de balanceamento configuráveis e recursos visuais provisórios.
- Ao terminar, executar testes disponíveis, registrar comandos, resultados, limitações e passos manuais de validação.
- Criar/atualizar obrigatoriamente `docs/CHANGELOG.md`, `docs/BACKLOG.md`, `docs/RELATORIOS/RELATORIO_07.md` e documentação técnica pertinente. Não marcar como concluído sem teste/evidência.
- Não iniciar a próxima release automaticamente se houver erros bloqueantes. Preparar commit/PR quando houver repositório remoto configurado; não alegar publicação sem realizá-la.
