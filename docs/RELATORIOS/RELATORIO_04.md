# Relatório da release 0.4 — Partida local

- **Data:** 19/11/2026
- **Escopo:** ciclo offline de partida com 2–5 participantes simulados. Rede, conta e bots competitivos ficam para releases posteriores.
- **Código:** `scripts/match_settings.gd`, `resources/match.tres`, `scripts/match_controller.gd`, `scripts/arena.gd`, `scripts/combat_system.gd`, `tests/release04_smoke.gd`.

## Implementado

| Requisito | Resultado |
| --- | --- |
| Participantes e início | Jogador mais 1–4 bots, spawn inicial, nível 1, HP e inventário limpos. Quinto spawn central provisório. |
| Eliminação | Sem respawn. Jogador eliminado deixa de agir e pode alternar o sobrevivente observado. |
| Encerramento | Sobrevivente único encerra imediatamente. Tempo máximo de 8 minutos. Empate provisório se o tempo acabar com vários vivos ou todos forem eliminados juntos. |
| Fechamento | Aviso 30 s antes de 5 minutos, bordas avançam por paredes físicas, itens cobertos desaparecem, personagens alcançados são conduzidos à área segura. |
| Resultado e reinício | Painel com vencedor/empate, nível, XP e caixas; botão de nova partida e tecla R recarregam a cena. |
| Dados | Participantes, tempo, aviso e geometria do fechamento em `resources/match.tres`. |

## Testes

Executados no Godot 4.7.2:

```text
godot --headless --path . --editor --quit
godot --headless --path . --script res://tests/release01_smoke.gd
godot --headless --path . --script res://tests/release02_smoke.gd
godot --headless --path . --script res://tests/release03_smoke.gd
godot --headless --path . --script res://tests/release04_smoke.gd
godot --headless --path . --quit-after 60
```

As quatro suítes passaram. A 0.4 verificou 2–5 participantes, início limpo, fechamento em cada contagem, último sobrevivente, aviso, remoção de item, parede física, ataque contra parede, empate por tempo, espectador, eliminação simultânea e nova partida por toque sem estado antigo.

## Verificação manual

1. Inicie a partida e observe cronômetro e vivos. Destrua caixas e ataque bots.
2. Pressione `T` ou toque em **+60s teste** repetidamente para chegar ao aviso e ao fechamento; confira bordas e itens no chão.
3. Use **Dano** para eliminar o jogador; `Tab` ou **Ver** alterna o nome do sobrevivente observado.
4. Ao terminar, pressione `R` ou toque em **Nova partida**; confirme nível 1, HP cheio, itens vazios, bots e caixas restaurados.

## Pendências e limitações

- Bots continuam estacionários e não lutam entre si. A simulação valida a lógica de partida, ainda sem confronto competitivo real.
- Quinto spawn central, condução de personagens na borda, aviso e ritmo do fechamento são provisórios e exigem playtest.
- Regra definitiva de desempate por tempo ou eliminações simultâneas permanece pendente; o protótipo mostra empate.
- Legibilidade e controles em Android real ainda precisam de validação.
