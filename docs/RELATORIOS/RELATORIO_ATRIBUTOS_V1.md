# Relatório — Sistema de Atributos V1

## Implementação

- `resources/attribute_points_v1.json` contém os 40 totais acumulados da referência rAthena, com marcos 48/80/135/210/305. No Base 1, seis atributos começam em 5; os 48 pontos de criação já foram gastos (quatro incrementos de custo 2 para cada atributo). Portanto, o saldo inicial livre é zero.
- `scripts/arena_attributes.gd` valida a tabela, calcula a diferença entre marcos, custo progressivo Pre-Renewal e valores base/bônus/efetivo. O bônus V1 é zero, reservado para classe, equipamento e efeitos futuros. O máximo de investimento por atributo é 99.
- `LocalProfileStore` salva atributos, pontos livres e marcos já concedidos por personagem. A recompensa pode cruzar vários níveis Base/Job: concede a soma das diferenças da tabela Base e 1 ponto por Job Level, apenas uma vez. O teto continua 40, sem alterar curvas EXP ou combate.
- Perfis v1/v2 migram para v3: personagens existentes recebem os pontos correspondentes ao nível atual, sem duplicação no próximo carregamento. O arquivo anterior fica em `.bak`; a migração v1 também preserva `.v1.bak`.
- Janela compartilhada mostra seis atributos, base + bônus = efetivo, custo, saldo, Base/Job e valores provisórios de combate. Disponível no menu de personagens anterior e na Arena01 3D. Na prévia 3D, `EXP teste` usa o mesmo pagamento idempotente de arena com identificador exclusivo, para testes manuais. Na primeira abertura, a prévia cria um Espadachim local se necessário.

## Testes executados

- `tests/arena_attributes_smoke.gd`: marcos, custos, 48 pontos iniciais, múltiplos níveis numa recompensa, pagamento único, gasto pela janela, persistência após recarregar, teto Base/Job 40, isolamento entre personagens e migração v2 idempotente.
- `tests/arena_progression_smoke.gd`: curvas e recompensas anteriores, nove personagens, recuperação por `.bak` e migração v1.
- `tests/arena_participation_smoke.gd`: morte, vitória, empate e abandono continuam pagando conforme a regra anterior.
- `tests/arena01_playtest_smoke.gd`: EXP teste na arena, janela aberta, toque no ataque bloqueado pela janela e demais testes de movimento, colisão, câmera e ataque.
- `tests/arena_3d_mobile_preview_smoke.gd`: controles e habilidades da prévia anterior.

## Limitações e decisões futuras

- Os novos atributos e pontos de habilidade são persistentes, mas não alteram as fórmulas de combate nem podem comprar habilidades nesta V1. Os derivados exibidos são os valores provisórios do combate atual.
- A Arena01 é uma prévia de testes com alvos estáticos; a recompensa de EXP é simulada pelo botão de desenvolvimento. As partidas reais ainda estão no fluxo anterior de `scenes/main.tscn`.
- Validar visualmente a janela e a persistência do navegador em celular real. Decidir valores de bônus, fórmulas PvP, limite de atributos e consumo dos pontos de habilidade antes da próxima etapa.
