# Relatório — Véspera, cidade e inventário V1

## Entrega

- Arena Véspera 160 × 160 m com muralhas existentes, praça, vias abertas, oito casas, igreja em terraço e escadaria central acessível. Casas e igreja possuem bloqueios; o interior dos prédios não é jogável.
- Inventário local permanente por personagem: poções, arma, armadura, capacete e acessório. Equipamentos alteram os secundários de ATK, DEF ou HP. A janela Inventário permite equipar e mostra o estoque; os atalhos consomem as poções salvas.
- O Espadachim recebe kit inicial uma única vez. Alvos estáticos concedem itens de teste. A progressão Base/Job existente permanece e a interface mostra ambos os níveis; o botão EXP teste permite validar evolução.

## Testes

- Importação Godot 4.7.2 e teste `vespera_smoke.gd`: carregamento do cenário, perímetro, materiais, escadaria e colisores.
- Teste `vespera_inventory_smoke.gd`: limite de item, equipar, secundários, consumo, persistência após reabrir e EXP concedida uma vez por partida.

## Limites conhecidos

- Ainda é um teste 3D com alvos imóveis, sem salas ou PvP. Drops e kit são provisórios. Não há base para calibrar o balanceamento final até partidas reais.
- As duas escadas laterais estão apenas como referência visual; a subida funcional é a escadaria central. Proporção, caminho e desempenho precisam de teste manual em celular.
