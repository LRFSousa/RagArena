# Relatório da release 0.2 — XP, consumíveis e inventário

- **Data:** 19/11/2026
- **Branch:** `release/0.2` durante implementação; integração em `main` após validação.
- **Escopo entregue:** progressão por caixa de nível 1 a 30; curva de XP e parâmetros editáveis; drops ponderados; seis itens; coleta automática; quatro slots; uso manual; HP, cooldown e buffs; HUD provisória; remoção de itens após 20 s e gancho de remoção pelo fechamento futuro.
- **Arquivos principais:** `resources/balance.tres`, `scripts/game_balance.gd`, `scripts/progression.gd`, `scripts/player_inventory.gd`, `scripts/ground_item.gd`, `scenes/ground_item.tscn`, `scripts/arena.gd`, `tests/release02_smoke.gd`.

## Critérios de aceite

| Critério | Resultado | Evidência |
| --- | --- | --- |
| Destruir caixa concede XP e sobe nível | Atendido | Testes de arena e progressão. |
| Nível limitado a 30 e curva configurável | Atendido | Teste de limite e recurso `balance.tres`. |
| Drop de 30% e pesos editáveis | Atendido na lógica | Testes com chances 0/100% e peso único; 30% provisório requer playtest estatístico. |
| Coleta, quatro slots e inventário cheio | Atendido | Teste de item no chão até liberar espaço. |
| Empilhamento e uso de cinco itens manuais | Atendido | Testes de poções, força, botas, escudo e elixir. |
| Amuleto automático sem slot | Atendido | Teste de coleta, bônus XP, renovação e expiração. |
| Buffs não somam, cooldown e expiração | Atendido | Testes de renovação, limite de HP, escudo e tempos. |
| Interface provisória | Atendido em código/headless | HUD e entradas de toque/teclado testadas; legibilidade em celular real pendente. |
| Reinício limpa progresso e inventário | Atendido | Teste de recarga da cena. |

## Testes executados

Com Godot 4.7.2:

```text
godot --headless --path . --editor --quit
godot --headless --path . --script res://tests/release01_smoke.gd
godot --headless --path . --script res://tests/release02_smoke.gd
godot --headless --path . --quit-after 60
```

As suítes 0.1 e 0.2 passaram, sem erros de parser ou recursos pendentes. A suíte 0.2 cobre XP, nível máximo, chance e pesos de drop, coleta, inventário cheio, empilhamento, cura, cooldown, força, velocidade, escudo, amuleto, expiração, controles e reinício.

## Verificação manual recomendada

1. Destrua caixas e observe XP e nível; após algumas caixas, o dano contra elas passa de 15 para 23.
2. Colete itens coloridos ao se aproximar; use teclas 1–4 no desktop ou toque nos slots no celular.
3. Confira quantidades e tempos dos efeitos, cura limitada ao HP máximo e item no chão quando os quatro slots estão cheios.
4. Use `H` ou o botão **Dano** para perder 25 HP e testar curas e escudo. Use `J` ou o botão **Item** para criar cada item em sequência. Esses controles são provisórios e podem ser desativados com `enable_debug_controls` na cena.
5. Pressione `R` no desktop ou reinicie o aplicativo no celular e confirme que nível, HP, itens e efeitos voltam ao estado inicial.

## Limitações e pendências

- HP máximo 100, curva de XP, chance/pesos de drop, alcance de coleta e durações são valores provisórios em `resources/balance.tres`.
- Não há inimigos nesta release. Força e escudo têm cálculos prontos para o combate futuro, e funções de XP por PvP/eliminação não são chamadas até a release 0.3.
- O fechamento da arena pertence à release 0.4; existe apenas o método de remoção dos itens cobertos.
- A experiência em Android real, especialmente legibilidade dos slots e controles por toque, ainda requer playtest.

## Documentação atualizada

`docs/BACKLOG.md`, `docs/CHANGELOG.md`, `docs/GAME_DESIGN.md`, `docs/PENDENCIAS.md`, `docs/releases/02_MVP_0_2_PROGRESSAO_ITENS.md`, `docs/releases/00_LEIA_PRIMEIRO.md` e este relatório.
