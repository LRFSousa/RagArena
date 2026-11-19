# Relatório da release 0.3 — Classes e combate local

- **Data:** 19/11/2026
- **Escopo:** combate offline contra bots de teste, quatro classes e três habilidades por classe. Sem rede, conta ou regras completas de partida.
- **Código:** `scripts/class_balance.gd`, `scripts/combat_system.gd`, `scripts/combat_bot.gd`, `scripts/combat_projectile.gd`, `scripts/combat_trap.gd`, `resources/classes.tres`, integração em `scripts/arena.gd` e `scripts/player_inventory.gd`.

## Implementado

| Requisito | Resultado |
| --- | --- |
| Paladino | Corpo a corpo, resistência a ataque à distância, autocura, Determinação contra empurrão e golpe. |
| Mago | Projétil de gelo com congelamento, barreira absorvente e bola de fogo. |
| Assassino | Corpo a corpo rápido, invisibilidade até atacar, lâmina e velocidade combinável. |
| Arqueiro | Ataque de alcance, rajada de três flechas, flecha de impacto e armadilha que imobiliza. |
| Dados | HP, dano, defesa, alcance, velocidade, cadência, recargas, estados e bots configuráveis no recurso de classes. Valores provisórios. |
| Progressão | XP pelo dano efetivo e eliminação, sem contar dano excedente ou morte repetida; HP e dano crescem por nível, habilidades melhoram nos níveis 10/20/30. |
| Colisão | Paredes e caixas bloqueiam projéteis. Habilidades não aumentam dano contra caixas; ataque comum mantém 15/23/45 e cadência própria. |
| Controles | Teclas Q/E/F ou botões de toque; Tab ou botão Classe para comparar as classes. Ataque continua direcional e repetido ao segurar. |

## Testes

Executados com Godot 4.7.2:

```text
godot --headless --path . --editor --quit
godot --headless --path . --script res://tests/release01_smoke.gd
godot --headless --path . --script res://tests/release02_smoke.gd
godot --headless --path . --script res://tests/release03_smoke.gd
godot --headless --path . --quit-after 60
```

As três suítes passaram. A suíte 0.3 verificou atributos, marcos de nível, XP efetivo, XP de eliminação, recargas, cura, proteção, barreira, congelamento, invisibilidade com velocidade, armadilha, colisão de projéteis com caixa e parede, além de dano e cadência comuns contra caixas nas quatro classes. As regras da 0.1 e o inventário da 0.2 não regrediram.

## Como validar manualmente

1. Abra a arena, use `Tab` ou **Classe** para alternar entre Paladino, Mago, Assassino e Arqueiro.
2. Mova com WASD/joystick e segure Espaço/botão de ataque. Use `Q`, `E`, `F` ou os botões correspondentes.
3. Ataque os bots, confira HP, nível, XP e recargas; use os botões provisórios **Dano** e **Item** para testar cura, escudo e força.
4. Atire contra caixas e pedras para conferir cobertura. Reinicie com `R` ou reabra o jogo para limpar progressão.

## Limitações e pendências

- Os bots são estacionários e atacam quando o jogador chega perto; ainda não simulam tomada de decisão de jogadores reais.
- Valores de dano, HP, alcance, recargas e crescimento são hipóteses de balanceamento. Playtest em Android real ainda é necessário.
- Formas geométricas e textos são provisórios. Não há multiplayer, tela de seleção de classe ou ciclo completo da partida nesta release.
