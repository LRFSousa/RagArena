# Relatório — progressão Base EXP e Job EXP

## Implementado

- Conta local com até nove personagens de classe fixa e Base/Job Level e EXP próprios; seleção de personagem antes da arena.
- Tabelas acumuladas e configuráveis de níveis 1–40 com os marcos definidos pelo responsável, sem copiar dados do rAthena.
- Recompensas por minutos completos, eliminações, assistências registradas e habilidades efetivas, respeitando os limites de cinco eventos. Bônus de conclusão e vitória somente com vencedor.
- Morte encerra a participação, reduz Base e Job EXP da participação em 25% e retorna à seleção. Abandono paga eventos válidos sem bônus finais nem penalidade.
- Persistência v2, migração do perfil v1 com identidade/presets/histórico, cópia de segurança, recuperação de cópia anterior e deduplicação por personagem e partida.
- A EXP permanente não altera os atributos ou habilidades do combate existente. O HUD identifica o nível/EXP temporários como dados da partida.

## Testes realizados

- `arena_progression_smoke.gd`: tabelas, marcos, teto, minutos, limites, morte, empate, nove personagens, isolamento, dupla liquidação, persistência, backup e migração v1 — passou.
- `arena_participation_smoke.gd`: morte e retorno, empate, vitória e abandono em partidas reais da cena 2D — passou.
- `release04_smoke.gd`: encerramento da participação na morte e regras de resultado — passou após adaptar os critérios à nova regra de morte.
- `release05_smoke.gd`: entrada local, perfil/presets legados, seleção de personagem, classe fixa e reinício — passou após adaptar o teste ao novo fluxo.
- `health_damage_regression.gd`, `release07_target_attack.gd`, `release07_attack_range.gd`, `release07_swordsman.gd` — passaram. Godot 4.7.2 headless foi usado.
- Alguns testes em modo headless registraram aviso de log `user://` inacessível no sandbox e avisos de objetos liberados na saída; as asserções passaram. Teste em celular e servidor real ainda não foram executados.

## Limitações e próximos passos

- A contabilidade é local porque o servidor multiplayer ainda não existe. Antes de usar a progressão online, o servidor deve validar tempo, dano, assistência, resultado e `match_id`, e ser a única autoridade de pagamento.
- Assistências e janela de dez segundos estão representadas no cálculo, mas não ocorrem no protótipo atual com bots que não combatem entre si.
- O Noviço usa combate provisório do Paladino; IDs Espadachim/Gatuno mapeiam para Paladino/Assassino. Kits próprios são posteriores.
- O ataque atual ainda alcança múltiplos alvos alinhados, enquanto a regra planejada do Espadachim é um alvo. O combate ficou intacto nesta entrega conforme a restrição.
- Validar em celular o ritmo de progressão e a recuperação do perfil; ajustar a curva somente com migração explícita após distribuição.
