# Progressão e distribuição de habilidades — Espadachim

## Entrega

O pagamento de partida existente continua concedendo Base EXP e Job EXP por tempo ativo, eliminações, assistências, uso efetivo de habilidades, conclusão e vitória. Base e Job sobem independentemente, podendo cruzar vários níveis na mesma recompensa. Base concede pontos de atributos pela tabela configurável; cada Job Level adicional concede um ponto de habilidade. O `match_id` impede recompensa duplicada.

O Espadachim agora pode gastar os pontos de Job nas sete habilidades principais da árvore documentada em `docs/research/swordsman_skill_tree_reference.md`. Cada rank custa um ponto, respeita máximo 10 e os requisitos Perícia com Espada 1 → Perícia com Espada de Duas Mãos, Golpe Fulminante 5 → Impacto Explosivo e Provocar 5 → Vigor. Ranks são salvos por personagem; perfis existentes recebem o campo `skill_ranks` vazio sem perder pontos. As três habilidades adicionais de missão são mostradas, mas aguardam regra de obtenção para a arena.

A janela **Habilidades** fica no menu e na Arena01. O botão **EXP teste** da Arena01 continua simulando o resultado de uma partida. A Arena01 ainda tem bonecos estáticos, sem partidas PvP ou recompensa automática; o pagamento real está ligado ao controlador da arena 2D.

## Testes

- `swordsman_skills_smoke.gd`: recompensa Job, gasto, pré-requisitos, isolamento entre personagens, persistência e pagamento único.
- `arena_attributes_smoke.gd` e `arena_progression_smoke.gd`: regressão de distribuição Base e recompensa de partida.
- `arena01_playtest_smoke.gd`: abertura da janela e bloqueio do ataque enquanto ela estiver aberta.

## Próxima integração

Aplicar os ranks comprados aos efeitos, custos de SP e durações já especificados para cada habilidade. As ações provisórias Proteção Divina, Cura e Determinação da prévia 3D ainda não foram substituídas por essa árvore.
