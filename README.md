# RagnArena

Protótipo offline top-down em Godot 4. A release 0.3 acrescenta quatro classes, habilidades e combate contra bots locais ao protótipo offline.

## Executar

Abra esta pasta no Godot 4 e execute a cena principal (`F6`) ou o projeto (`F5`). No desktop, use WASD ou setas para mover, espaço ou clique esquerdo para atacar, teclas `1`–`4` para usar itens `Q`, `E` e `F` para habilidades, `Tab` para trocar a classe de teste e `R` para reiniciar. Em tela de toque, arraste o joystick à esquerda, segure o botão circular à direita para repetir ataques e toque nos quatro slots para usar itens, nos botões Q/E/F para habilidades e em **Classe** para trocar de classe.

Caixas de madeira têm 45 HP e exigem 3, 2 ou 1 golpes nos níveis 1–3, 4–7 e 8–30. Destruí-las concede XP e pode gerar um item. O nível evolui automaticamente até 30. Pedras e limites da arena são permanentes. A propriedade `test_level` da cena `scenes/arena.tscn` permite forçar apenas o dano às caixas para depuração; o valor normal é `0`.

Os valores provisórios de XP, chance e pesos de drop, cura, duração de buffs e cooldown podem ser editados em `resources/balance.tres` no Inspector. O combate da release 0.3 continua offline. Os bots são alvos de teste estacionários que atacam ao alcance. Atributos e recargas provisórios ficam em `resources/classes.tres`.

A janela usa uma área lógica de 1280×720, escalada com preservação de proporção. O projeto está configurado em paisagem para Android. As quatro áreas marcadas nas extremidades são espaços de spawn de teste; um personagem local e dois bots de teste são instanciados nesta release.

## Estrutura

- `scenes/`: cenas `main`, `arena`, `player`, `crate` e `wall`.
- `scripts/arena.gd`: mapa, controles, HUD e ataque.
- `scripts/player.gd`: movimento com colisão.
- `scripts/obstacle.gd`: caixas e paredes.
- `scripts/combat_rules.gd`: dano exclusivo contra caixas.
- `scripts/progression.gd`: XP e nível por partida.
- `scripts/player_inventory.gd`: quatro slots, itens, HP, cooldown e efeitos.
- `scripts/ground_item.gd`: itens provisórios no chão e expiração.
- `resources/balance.tres` e `resources/classes.tres`: parâmetros editáveis de itens, progressão e classes.
- `scripts/combat_system.gd`, `combat_bot.gd`, `combat_projectile.gd` e `combat_trap.gd`: combate local e efeitos.
- `tests/release01_smoke.gd` e `tests/release02_smoke.gd` e `tests/release03_smoke.gd`: testes de gameplay em modo headless.
- `docs/`: decisões, backlog e mudanças.

## Testes

No terminal com Godot 4 disponível:

```text
godot --headless --path . --editor --quit
godot --headless --path . --script res://tests/release01_smoke.gd
godot --headless --path . --script res://tests/release02_smoke.gd
godot --headless --path . --script res://tests/release03_smoke.gd
godot --headless --path . --quit-after 60
```

O alvo é Android em paisagem, mas ainda falta uma validação manual em aparelho real.

## Teste no Android

O APK de depuração e as instruções de instalação estão descritos em `docs/ANDROID_TESTE.md`.

## Teste no navegador

Jogue no navegador em https://lrfsousa.github.io/RagArena/ (preferencialmente em paisagem). Veja `docs/WEB_TESTE.md` para exportação e hospedagem.
