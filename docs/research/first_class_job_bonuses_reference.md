# Bônus das cinco classes iniciais — referência Pre-Renewal

Pesquisa em 22/11/2026. Fontes rAthena no commit `dd073ca4720b90e4eaf90fd5788eb7676f1b9146`: [`job_stats.yml`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/db/pre-re/job_stats.yml#L100-L363), [`job_basepoints.yml`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/db/pre-re/job_basepoints.yml) e [`status.cpp`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/src/map/status.cpp). Os bônus automáticos Job até o nível 40 foram implementados no RagnArena; há uma primeira curva própria de HP em teste, enquanto a de SP permanece pendente.

## Três mecanismos distintos

1. **Pontos distribuídos pelo jogador** ao ganhar Base Level. Permanecem separados dos bônus de classe.
2. **Bônus automáticos de atributo por Job Level**, em marcos específicos da primeira classe. `BonusStats` soma ao bônus exibido na janela (`base + bônus = efetivo`), sem consumir pontos livres.
3. **HP/SP base por classe e Base Level.** As tabelas `BaseHp` e `BaseSp` são distintas para cada classe; VIT e INT ainda modificam esses valores nas fórmulas do servidor. `HpFactor` e `SpIncrease` em `job_stats.yml` servem à fórmula alternativa quando as tabelas de HP/SP estão desligadas, então não devem ser somados novamente aos valores tabelados.

O ATK mágico **não** aparece como `BonusStats` independente do Mago: o bônus de INT eleva o atributo efetivo, que participa do cálculo de M.ATK. Da mesma forma, a FOR recebida pelo Espadachim contribui para ATK físico; HP maior é a curva de classe, com VIT adicional.

## Totais automáticos acumulados até Job Level 40

| Classe | FOR | AGI | VIT | INT | DES | SOR | Base HP no Base 40 | Base SP no Base 40 | Leitura |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| Espadachim | +4 | +1 | +3 | +0 | +3 | +1 | 810 | 90 | Forte em HP, FOR e VIT |
| Mago | +0 | +3 | +0 | +5 | +3 | +1 | 483 | 250 | INT, SP e magia; HP menor |
| Arqueiro | +3 | +2 | +0 | +1 | +5 | +1 | 654 | 90 | DES e ataque à distância |
| Noviço | +1 | +2 | +2 | +2 | +2 | +3 | 563 | 210 | Bônus distribuídos e SP elevado |
| Gatuno | +3 | +3 | +1 | +1 | +2 | +2 | 654 | 90 | AGI/FOR, esquiva e ataque rápido |

Cada classe recebe 12 pontos automáticos nesses marcos até Job 40, distribuídos de forma diferente. Os números de HP/SP são a **base tabelada antes de VIT/INT e outros modificadores**, não o máximo final do personagem. No Base 1, as bases HP/SP são respectivamente: Espadachim 40/12, Mago 40/16, Arqueiro 40/12, Noviço 40/15 e Gatuno 40/12.

## Adaptação no RagnArena

Os **marcos e a distribuição dos bônus Job** foram adotados para as cinco classes, preservando pontos livres por Base Level. O bônus é calculado no acesso, de modo que a janela mostre base investida + bônus da classe. O atributo efetivo alimenta os secundários; por exemplo, INT do Mago aumenta SP e M.ATK, FOR do Espadachim aumenta ATK. Para HP/SP base, configurar curvas próprias da arena em vez de importar literalmente 810/483/654 etc., pois o combate atual e a duração das partidas usam outra escala. A classe escolhida na criação já é fixa no perfil, mas o combate 3D ainda usa apenas o Espadachim.

**Pendências de decisão:** calibrar a curva de HP da arena em PvP real, definir a curva de SP por classe e o tratamento de SP atual ao subir de nível. A Arena01 mantém a porcentagem de HP atual quando o máximo muda. Não confundir bônus automático por Job com o ponto livre de habilidade concedido pelo mesmo Job Level.
