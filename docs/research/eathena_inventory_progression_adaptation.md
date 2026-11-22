# Referência eAthena/rAthena para inventário e progressão da Véspera

## Fontes verificadas

O eAthena original é um projeto histórico. Para uma base pública mantida e verificável foram consultados o [banco Pre-Renewal de itens do rAthena](https://github.com/rathena/rathena/blob/master/db/pre-re/item_db.yml), a [configuração de uso de itens](https://github.com/rathena/rathena/blob/master/conf/battle/items.conf), as [estruturas de inventário e equipamento](https://github.com/rathena/rathena/blob/master/src/map/pc.hpp), os [pontos base de classe](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/db/pre-re/job_basepoints.yml), os [bônus Job](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/db/pre-re/job_stats.yml) e o [cálculo de estado](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/src/map/status.cpp).

## Regras verificadas e adaptação

**Verificado nas fontes:** itens têm tipo e localização de equipamento; alguns são empilháveis e podem ter limites de quantidade; personagem possui inventário e posições de equipamento separados. O Ragnarok distingue progressão Base e Job e bônus por classe.

**Adaptação do RagnArena:** o inventário é salvo por personagem junto do nível e EXP. Há quatro posições iniciais: arma, armadura, capacete e acessório. Poções empilham até 99; equipamentos são individuais. Itens não se perdem ao morrer. O catálogo e os bônus são **números de teste próprios**, não cópia das bases do Ragnarok. A espada de ferro acrescenta 22 ATK, armadura de ferro 22 DEF e anel vital 150 HP. Os alvos estáticos entregam itens para validar a interface; eles não contam como eliminações PvP.

As curvas Base/Job já configuradas em `resources/arena_progression.json` permanecem próprias da arena. `settle_match` salva uma recompensa por personagem e identificador de partida, sem repetir créditos. O botão EXP teste usa essa mesma rotina e deve sair antes da produção. Ganho por participação, vitória, eliminações, assistências e habilidades depende de uma partida PvP 3D futura.

## Questões abertas

- Capacidade e peso do inventário, descarte, raridades e upgrade.
- Regras de drop, moeda e obtenção permanente em partidas com múltiplos jogadores.
- Balanceamento de dano, defesa, recuperação e equipamentos diante de PvP real.
- Autoridade do servidor para recompensas e inventário no multiplayer.
