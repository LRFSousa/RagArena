# RagnArena — MVP 0.3 — Quatro classes e PvP local

**Status:** Planejada

## Objetivo
Implementar combate e habilidades contra alvos de teste/bots simples, sem rede.
## Tarefas
- [ ] Criar dados de classe independentes de sprites: Paladino (resistência), Mago (controle), Assassino (mobilidade), Arqueiro (alcance).
- [ ] Definir atributos PvP por classe em dados configuráveis: HP, dano, defesa, alcance, velocidade, cadência e cooldown.
- [ ] Implementar ataque básico direcional com pressionar-e-segurar; NÃO implementar travamento de alvo no MVP.
- [ ] Paladino: ataque corpo a corpo, proteção contra dano à distância, autocura, Determinação/Endure contra empurrões/interrupções leves (não anula congelamento).
- [ ] Mago: Rajada de Gelo (congelamento curto), Barreira Arcana, Bola de Fogo.
- [ ] Assassino: Invisibilidade (termina ao atacar), Lâmina Arremessada, Passos Velozes; permitir combinação invisibilidade + velocidade.
- [ ] Arqueiro: Rajada de Flechas, Flecha de Impacto (empurrão), Armadilha (imobilização).
- [ ] Criar alvos/bots simples para testar alcance, projéteis, colisão com caixas/paredes, estados, dano, cura e morte.
- [ ] Conceder XP por dano PvP efetivamente causado e bônus por eliminação; evitar XP por dano acima da vida restante.
- [ ] Garantir dano contra caixas igual por faixa de nível para todas as classes, independentemente da cadência de PvP; balancear dano em área contra caixas.
## Critérios de aceite
- Cada classe possui ataque + três habilidades utilizáveis e testáveis; controles direcionais funcionam.
- Colisões bloqueiam projéteis, cooldowns impedem spam e condições de controle expiram.
- Combinações aprovadas permanecem possíveis; valores exatos de atributos e cooldowns são provisórios.

## Contrato de execução do Codex
- Ler `docs/GAME_DESIGN.md`, `docs/BACKLOG.md` e os documentos da release antes de alterar código.
- Implementar somente o escopo desta release; registrar dependências ou dúvidas em `docs/PENDENCIAS.md`, sem inventar regras definitivas.
- Manter Godot 4 + GDScript; cenas e scripts desacoplados, dados de balanceamento configuráveis e recursos visuais provisórios.
- Ao terminar, executar testes disponíveis, registrar comandos, resultados, limitações e passos manuais de validação.
- Criar/atualizar obrigatoriamente `docs/CHANGELOG.md`, `docs/BACKLOG.md`, `docs/RELATORIOS/RELATORIO_03.md` e documentação técnica pertinente. Não marcar como concluído sem teste/evidência.
- Não iniciar a próxima release automaticamente se houver erros bloqueantes. Preparar commit/PR quando houver repositório remoto configurado; não alegar publicação sem realizá-la.
