# Atributos secundários — Arena01

## Implementado

- O botão **Atributos** mostra simultaneamente o painel de distribuição e o painel de visão geral, seguindo as duas áreas da referência enviada. Os valores mudam ao gastar pontos e são lidos do perfil persistente.
- `arena_derived_stats.gd` centraliza uma escala própria para a arena. FOR, DES e SOR compõem ATK físico; VIT e Base Level compõem HP máximo; INT compõe SP e M.ATK; AGI compõe esquiva e velocidade de ataque. DEF, M.DEF, acerto e regeneração também são derivados. As fórmulas foram simplificadas a partir dos papéis documentados em `docs/research/ragnarok_progression_reference.md`, sem copiar código rAthena.
- Na Arena01, ATK calculado determina o dano do ataque básico do Espadachim. O bônus de Determinação continua +10 e o alcance continua em dois blocos. HP máximo acompanha VIT/Base Level e o HP atual não ultrapassa o novo máximo. Nenhum atributo aumenta a velocidade de caminhada.

## Testes

- `arena_derived_stats_smoke.gd`: efeitos de FOR, VIT, INT, DES e AGI, velocidade de caminhada fixa e alcance preservado.
- `arena_attributes_smoke.gd`: os dois painéis, distribuição e persistência.
- `arena01_playtest_smoke.gd`: dano calculado no golpe, orientação, rampas, câmera e controles.

## Limite desta etapa

SP, regeneração, M.ATK, M.DEF, acerto, esquiva e velocidade de ataque são exibidos, mas as mecânicas correspondentes ainda não existem na Arena01. O protótipo 2D mantém seu balanceamento anterior. Fórmulas e escala precisam ser calibradas em partidas PvP antes de valê-las para todas as classes.
