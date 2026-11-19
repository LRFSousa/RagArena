# Relatório da release 0.1 — Arena e controles

- **Data:** 18/11/2026
- **Branch / commit / PR:** branch local `main`; commit inicial `57ac639`; configuração de exportação Android em commit posterior; sem PR.
- **Escopo entregue:** projeto Godot 4 com cenas `main`, `arena`, `player`, `crate`, `wall`; mapa offline com quatro áreas de spawn de teste, paredes e 12 caixas; personagem geométrico, movimento 360°, joystick virtual, teclado, ataque direcional repetido, colisões, HUD e reinício.
- **Balanceamento de teste:** caixas com 45 HP; dano exclusivo contra caixas de 15/23/45 conforme nível 1–3/4–7/8–30. Nível de teste, alcance e cadência configuráveis na cena de arena. Sem XP, itens ou PvP nesta release.

## Arquivos principais

- `project.godot`, `README.md`.
- `scenes/main.tscn`, `scenes/arena.tscn`, `scenes/player.tscn`, `scenes/crate.tscn`, `scenes/wall.tscn`.
- `scripts/arena.gd`, `scripts/player.gd`, `scripts/obstacle.gd`, `scripts/combat_rules.gd`.
- `tests/release01_smoke.gd`.
- `docs/BACKLOG.md`, `docs/CHANGELOG.md`, `docs/GAME_DESIGN.md`, `docs/PENDENCIAS.md`, `docs/releases/01_MVP_0_1_ARENA.md`.

## Critérios de aceite

| Critério | Estado | Evidência |
| --- | --- | --- |
| Movimento desktop sem atravessar paredes | Atendido em headless | Teste de tecla e colisão com limite externo. |
| Joystick em celular | Parcialmente verificado | Eventos de toque simulados; validação manual em aparelho pendente. |
| Ataque direcional e cadência | Atendido em headless | Testes de direção correta/oposta e ataque segurado. |
| Caixa 45 HP destruída em 3/2/1 golpes | Atendido em headless | Testes nos níveis 1, 4 e 8. |
| Ataque não atravessa parede | Atendido em headless | Teste com parede entre jogador e caixa. |
| Reinício sem erros | Atendido em headless | Teste de reinício e limpeza de contadores. |
| Arte final | Fora do escopo | Formas geométricas provisórias. |

## Testes executados

Executados com Godot 4.7.2:

```text
godot --headless --path . --editor --quit
godot --headless --path . --script res://tests/release01_smoke.gd
godot --headless --path . --quit-after 60
```

A suíte passou sem falhas; importação e execução por 60 quadros terminaram sem erros. A suíte verifica funções de dano, HP, contadores, HUD, direção, cadência, bloqueio por parede, toque simulado, colisão e reinício.

## Validação manual recomendada

1. No Godot, execute `scenes/main.tscn`; mova com WASD/setas contra paredes e caixas.
2. Segure espaço e confirme três golpes para destruir uma caixa com nível de teste 1; repita com níveis 4 e 8 no Inspector.
3. Pressione `R` e confirme que os contadores retornam ao estado inicial.
4. Em Android paisagem, arraste o joystick e segure o botão de ataque; confira escala e legibilidade.

## Problemas e decisões pendentes

Nenhum erro bloqueante conhecido na execução headless. A experiência visual e a ergonomia em Android real ainda não foram verificadas. Valores de velocidade, alcance e cadência são provisórios. As demais decisões em aberto constam de `docs/PENDENCIAS.md`.

## Próxima ação

Preparar a release 0.2 a partir de `docs/releases/02_MVP_0_2_PROGRESSAO_ITENS.md`. O planejamento inicial consta de `docs/RELATORIOS/INICIO_02.md`; nenhum código da release 0.2 foi implementado durante esta entrega.



## Complemento de 19/11/2026 — Android

APK de depuração exportado com Godot 4.7.2. Assinatura v2/v3 verificada com `apksigner`, manifesto inspecionado com `aapt` (pacote `com.lrfsousa.ragnarena`, orientação paisagem, API mínima 24). Não havia dispositivo conectado a `adb devices`; teste físico permanece pendente. Ver `docs/ANDROID_TESTE.md`.


## Complemento de 19/11/2026 — publicação Web

O repositório foi tornado público com autorização do responsável. `main` e `gh-pages` foram enviados ao GitHub; Pages foi ativado a partir de `gh-pages/`. A URL https://lrfsousa.github.io/RagArena/ respondeu com HTTP 200 e exibiu a arena no navegador integrado, sem erros no console. Teste de toque em celular real ainda pendente.
