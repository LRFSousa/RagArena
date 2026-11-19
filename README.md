# RagnArena

Protótipo offline top-down em Godot 4. A release 0.5 acrescenta perfil e configurações locais ao ciclo de partida offline.

Para digitar no navegador do celular, toque no campo. Se o teclado não abrir, use o botão **Teclado na tela** abaixo dele, digite e toque em **Concluir**. Esse botão também funciona ao nomear configurações.

## Executar

Abra esta pasta no Godot 4 e execute o projeto (`F5`). Na primeira abertura, crie um nome local e uma configuração de classe; depois escolha a configuração em Arena. No desktop, use WASD ou setas para mover, espaço ou clique esquerdo para atacar, teclas `1`–`4` para usar itens, `Q`, `E` e `F` para habilidades, `Tab` para observar sobreviventes após eliminação, `T` para avançar 60 s no protótipo, `M` para voltar ao menu e `R` para iniciar nova partida. Em tela de toque, arraste o joystick à esquerda, segure o botão circular à direita para repetir ataques e toque nos quatro slots para usar itens, nos botões Q/E/F para habilidades, em **+60s teste** para avançar o relógio e em **Menu** para voltar.

Caixas de madeira têm 45 HP e exigem 3, 2 ou 1 golpes nos níveis 1–3, 4–7 e 8–30. Destruí-las concede XP e pode gerar um item. O nível evolui automaticamente até 30. Pedras e limites da arena são permanentes. A propriedade `test_level` da cena `scenes/arena.tscn` permite forçar apenas o dano às caixas para depuração; o valor normal é `0`.

Os valores provisórios de XP, chance e pesos de drop, cura, duração de buffs e cooldown podem ser editados em `resources/balance.tres` no Inspector. O perfil e as configurações ficam apenas no dispositivo ou navegador. A partida permanece offline. Os bots são alvos de teste estacionários que atacam ao alcance. Atributos e recargas provisórios ficam em `resources/classes.tres`; duração, participantes e fechamento ficam em `resources/match.tres`. O fechamento começa aos 5 minutos e a partida termina ao restar um sobrevivente ou após 8 minutos.

A janela usa uma área lógica de 1280×720, escalada com preservação de proporção. O projeto está configurado em paisagem para Android. As quatro áreas marcadas nas extremidades são espaços de spawn de teste; um personagem local e 1–4 bots de teste são instanciados conforme a configuração.

## Estrutura

- `scenes/`: cenas `main`, `arena`, `player`, `crate` e `wall`.
- `scripts/arena.gd`: mapa, controles, HUD e ataque.
- `scripts/player.gd`: movimento com colisão.
- `scripts/obstacle.gd`: caixas e paredes.
- `scripts/combat_rules.gd`: dano exclusivo contra caixas.
- `scripts/progression.gd`: XP e nível por partida.
- `scripts/player_inventory.gd`: quatro slots, itens, HP, cooldown e efeitos.
- `scripts/ground_item.gd`: itens provisórios no chão e expiração.
- `resources/balance.tres`, `resources/classes.tres` e `resources/match.tres`: parâmetros editáveis.
- `scripts/combat_system.gd`, `combat_bot.gd`, `combat_projectile.gd` e `combat_trap.gd`: combate local e efeitos.
- `scripts/match_controller.gd`: participantes, cronômetro, fechamento, espectador e resultado.
- `scripts/local_profile_store.gd` e `scripts/main_flow.gd`: perfil persistente local, menu e configurações.
- `tests/release01_smoke.gd` e `tests/release02_smoke.gd` e `tests/release03_smoke.gd` e `tests/release04_smoke.gd` e `tests/release05_smoke.gd`: testes de gameplay em modo headless.
- `docs/`: decisões, backlog e mudanças.

## Testes

No terminal com Godot 4 disponível:

```text
godot --headless --path . --editor --quit
godot --headless --path . --script res://tests/release01_smoke.gd
godot --headless --path . --script res://tests/release02_smoke.gd
godot --headless --path . --script res://tests/release03_smoke.gd
godot --headless --path . --script res://tests/release04_smoke.gd
godot --headless --path . --script res://tests/release05_smoke.gd
godot --headless --path . --quit-after 60
```

O alvo é Android em paisagem, mas ainda falta uma validação manual em aparelho real.

## Teste no Android

O APK de depuração e as instruções de instalação estão descritos em `docs/ANDROID_TESTE.md`.

## Teste no navegador

Jogue no navegador em https://lrfsousa.github.io/RagArena/ (preferencialmente em paisagem). Veja `docs/WEB_TESTE.md` para exportação e hospedagem.
