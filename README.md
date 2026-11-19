# RagnArena

Protótipo offline top-down em Godot 4. A release 0.1 usa formas geométricas para validar movimentação e abertura de caminhos.

## Executar

Abra esta pasta no Godot 4 e execute a cena principal (`F6`) ou o projeto (`F5`). No desktop, use WASD ou setas para mover, espaço ou clique esquerdo para atacar e `R` para reiniciar. Em tela de toque, arraste o joystick à esquerda e segure o botão circular à direita para repetir ataques.

Caixas de madeira têm 45 HP e exigem 3, 2 ou 1 golpes nos níveis de teste 1–3, 4–7 e 8–30. Pedras e limites da arena são permanentes. O nível de teste pode ser alterado na propriedade `test_level` da cena `scenes/arena.tscn` no Inspector. A progressão real pertence à release 0.2.

A janela usa uma área lógica de 1280×720, escalada com preservação de proporção. O projeto está configurado em paisagem para Android. As quatro áreas marcadas nas extremidades são espaços de spawn de teste; apenas um personagem local é instanciado nesta release.

## Estrutura

- `scenes/`: cenas `main`, `arena`, `player`, `crate` e `wall`.
- `scripts/arena.gd`: mapa, controles, HUD e ataque.
- `scripts/player.gd`: movimento com colisão.
- `scripts/obstacle.gd`: caixas e paredes.
- `scripts/combat_rules.gd`: dano exclusivo contra caixas.
- `tests/release01_smoke.gd`: testes de gameplay em modo headless.
- `docs/`: decisões, backlog e mudanças.

## Testes

No terminal com Godot 4 disponível:

```text
godot --headless --path . --editor --quit
godot --headless --path . --script res://tests/release01_smoke.gd
godot --headless --path . --quit-after 60
```

O alvo é Android em paisagem, mas ainda falta uma validação manual em aparelho real.

## Teste no Android

O APK de depuração e as instruções de instalação estão descritos em `docs/ANDROID_TESTE.md`.

## Teste no navegador

Jogue no navegador em https://lrfsousa.github.io/RagArena/ (preferencialmente em paisagem). Veja `docs/WEB_TESTE.md` para exportação e hospedagem.
