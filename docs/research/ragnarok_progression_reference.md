# Ragnarok Online como referência de progressão para o RagnArena

Pesquisa documental, 21/11/2026. **Nenhuma regra deste texto altera o jogo.** “Verificado” indica o que consta nas fontes; “Proposta” indica decisão sugerida para o RagnArena. Referência do rAthena fixada no commit [`dd073ca`](https://github.com/rathena/rathena/tree/dd073ca4720b90e4eaf90fd5788eb7676f1b9146), pois `master` pode mudar.

## 1. Fontes e arquivos analisados

### Instalação local do cliente

**Verificado:** a instalação está em `C:\Gravity\Ragnarok Online`. Foram examinados nomes e tipos dos arquivos acessíveis na raiz e em `System/`, além de buscas por nomes ligados a EXP, level, job, status e skill. A raiz contém `Ragexe.exe`, `Ragnarok.exe`, `data.grf` e `event.grf`; `System/` contém, entre outros, `iteminfo.lub`, `mapInfo.lub` e `achievement_list.lub`. Há imagens de interface de status e habilidades em `skin/`. Não foi encontrada nessa inspeção uma tabela legível de EXP de personagem, pontos por nível, fórmula de HP/SP ou árvore de classe que possa ser tomada como autoridade. Os executáveis, GRFs e arquivos `.lub` não foram descompilados nem alterados. **Conclusão limitada à inspeção não invasiva:** o cliente instalado confirma recursos de interface, mas as regras numéricas devem ser pesquisadas no servidor público, não inferidas de imagens ou arquivos compilados.

### rAthena público

| Assunto | Arquivo verificado |
|---|---|
| Curvas Base/Job por conjunto de classes | [`db/pre-re/job_exp.yml`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/db/pre-re/job_exp.yml), [`db/re/job_exp.yml`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/db/re/job_exp.yml) |
| Pontos de atributos por Base Level | [`db/pre-re/statpoint.yml`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/db/pre-re/statpoint.yml), [`db/re/statpoint.yml`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/db/re/statpoint.yml) |
| Bônus de atributos e parâmetros de classe | [`db/pre-re/job_stats.yml`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/db/pre-re/job_stats.yml), [`db/re/job_stats.yml`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/db/re/job_stats.yml) |
| HP/SP básico por classe e Base Level | [`db/pre-re/job_basepoints.yml`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/db/pre-re/job_basepoints.yml), [`db/re/job_basepoints.yml`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/db/re/job_basepoints.yml) |
| Ganho de EXP, level-up, pontos, custos e compra de skill | [`src/map/pc.cpp`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/src/map/pc.cpp) (`pc_gainexp`, `pc_checkbaselevelup`, `pc_checkjoblevelup`, `pc_need_status_point`, `pc_skillup`) |
| Cálculos de HP, SP, ATQ, defesa e velocidade | [`src/map/status.cpp`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/src/map/status.cpp) (`status_calc_maxhp_pc`, `status_calc_maxsp_pc`, `status_base_atk`, `status_calc_misc`, `status_base_amotion_pc`, `status_calc_speed`) |
| Árvore e requisitos de habilidades | [`db/pre-re/skill_tree.yml`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/db/pre-re/skill_tree.yml), [`db/re/skill_tree.yml`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/db/re/skill_tree.yml); parâmetros individuais em [`db/pre-re/skill_db.yml`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/db/pre-re/skill_db.yml) e equivalente `db/re/` |
| Alternância de regras e taxas | [`src/config/renewal.hpp`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/src/config/renewal.hpp), [`conf/battle/exp.conf`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/conf/battle/exp.conf) |

**Licença:** o repositório rAthena declara GPLv3 ou posterior nos cabeçalhos analisados e no [arquivo de licença](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/LICENSE). Esta pesquisa descreve mecanismos e usa poucos valores ilustrativos; não incorpora código, tabela integral ou assets ao RagnArena. Qualquer reutilização literal futura exige avaliação da licença. Os arquivos da instalação Gravity não são fonte de assets para distribuição.

## 2. Estrutura dos atributos — verificado no rAthena

| Atributo | Papel constatado nas fórmulas examinadas |
|---|---|
| STR | Participa do ATQ básico físico corpo a corpo. |
| AGI | Participa de esquiva e da cadência de ataque (ASPD); não equivale automaticamente à velocidade de caminhada. |
| VIT | Modifica HP máximo e defesa secundária. |
| INT | Modifica SP máximo e defesa mágica secundária; também entra em cálculos mágicos. |
| DEX | Participa de precisão e ATQ de armas à distância; influencia ASPD. |
| LUK | Participa de crítico, esquiva e parte do ATQ/precisão conforme o modo. |

O valor efetivo não é apenas o atributo investido: a base do personagem recebe bônus de Job Level, equipamentos, habilidades e estados antes dos cálculos finais. `job_stats.yml` registra `BonusStats` por nível e classe. Por exemplo, o Espadachim recebe `Str: 1` no Job 2, `Vit: 1` no Job 6 e `Dex: 1` no Job 10. Essas entradas são **bônus automáticos da classe**, distintos dos pontos livres obtidos via Base Level. O mesmo arquivo traz `HpFactor`, `SpIncrease` e outros parâmetros específicos; para o Espadachim Pre-Renewal, `HpFactor: 70` e `SpIncrease: 200`. Fonte: [`job_stats.yml`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/db/pre-re/job_stats.yml#L103-L129).

## 3. Níveis, tabelas e fórmulas — verificado no rAthena

### Base EXP e Job EXP

As tabelas `job_exp.yml` agrupam classes com curvas e tetos próprios. A entrada `Level: n, Exp: x` representa **EXP necessária para sair do nível n**, não EXP total acumulada. `pc_nextbaseexp` e `pc_nextjobexp` consultam a entrada da classe e do nível atual; os respectivos `pc_check*levelup` subtraem o custo, elevam o nível e podem repetir o processo conforme `multi_level_up` em `exp.conf`. No rAthena, o grupo do Espadachim tem Job máximo 50, diferente do teto inicial 40 decidido para o RagnArena. Fonte: [`pc.cpp`, EXP e level-up](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/src/map/pc.cpp#L8244-L8340) e [configuração](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/conf/battle/exp.conf).

Exemplos da curva **normal do grupo que inclui Espadachim** no commit pesquisado. A coluna “até 40” soma os custos de `Level: 1` a `Level: 39`; `Level: 40` já é o custo para 41.

| Modo | Trilha | 1→2 | 10→11 | 20→21 | 30→31 | 39→40 | Total até 40 |
|---|---|---:|---:|---:|---:|---:|---:|
| Pre-Renewal | Base | 9 | 320 | 1.620 | 7.995 | 30.543 | 199.603 |
| Pre-Renewal | Job Espadachim | 30 | 520 | 3.988 | 28.359 | 107.611 | 755.215 |
| Renewal | Base | 548 | 5.337 | 9.134 | 17.362 | 26.682 | 438.182 |
| Renewal | Job Espadachim | 60 | 2.290 | 8.090 | 22.870 | 46.180 | 524.640 |

Esses números são **comparativos, não proposta de tabela**. Outras classes e etapas podem usar grupos diferentes. O rAthena também permite taxas Base/Job, limite de ganho por evento, penalidade de morte e múltiplos level-ups por recompensa em `conf/battle/exp.conf`.

### Pontos de atributos e habilidades

`statpoint.yml` registra **total acumulado de pontos** por Base Level: 48 no Base 1, 80 no Base 10, 135 no Base 20, 210 no Base 30 e 305 no Base 40 em ambos os arquivos consultados. No level-up, `pc_gets_status_point(n)` concede a diferença `total(n+1) − total(n)`. Isso não significa que todos os pontos estejam livres, pois podem ter sido gastos. O custo para elevar um atributo aumenta com o valor atual: `pc_need_status_point` soma o custo de cada incremento; o macro de custo difere entre Pre-Renewal e Renewal. Fontes: [`statpoint.yml`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/db/pre-re/statpoint.yml), [`pc.cpp`, pontos e custo](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/src/map/pc.cpp#L8737-L8832).

Cada Job Level obtido aumenta `skill_point` em 1 em `pc_checkjoblevelup`; `pc_skillup` verifica ponto disponível, skill permanente e máximo da árvore antes de elevar o rank e gastar 1 ponto. A árvore do Espadachim Pre-Renewal lista, por exemplo, `SM_SWORD`, `SM_RECOVERY` e `SM_BASH` até rank 10; `SM_ENDURE` exige `SM_PROVOKE` 5. Isso é a regra do rAthena, **não um pré-requisito já aprovado para o RagnArena**. Fontes: [`pc.cpp`, Job level-up](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/src/map/pc.cpp#L8317-L8340), [`pc.cpp`, skill-up](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/src/map/pc.cpp#L9128-L9180), [`skill_tree.yml`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/db/pre-re/skill_tree.yml#L53-L82).

### HP, SP, ATQ, defesa e velocidade

**HP/SP:** `job_basepoints.yml` fornece `BaseHp` e `BaseSp` por classe e Base Level. `status_calc_maxhp_pc` começa com `base_hp[BaseLevel−1]` e multiplica por `1 + VIT/100`, antes de outros bônus de classe, equipamento, item e status; `status_calc_maxsp_pc` faz o análogo com `base_sp` e `1 + INT/100`. Portanto, **`BaseHp × (1+VIT/100)` e `BaseSp × (1+INT/100)` são apenas a parte inicial**, não a fórmula final completa. Há fórmulas alternativas `calc_basehp` e `calc_basesp` com fatores de classe quando tabelas de HP/SP não são usadas. Fontes: [`job_basepoints.yml`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/db/pre-re/job_basepoints.yml), [`status.cpp`, HP/SP](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/src/map/status.cpp#L3511-L3599), [`pc.cpp`, geração alternativa](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/src/map/pc.cpp#L13708-L13775).

**ATQ:** para personagem corpo a corpo Pre-Renewal, o cálculo básico em `status_base_atk` soma STR, `floor(STR/10)^2`, `floor(DEX/5)` e `floor(LUK/5)` antes de outros componentes. Para arma à distância, a função troca o papel de STR e DEX. Renewal usa outra base, que inclui Base Level e atributos em proporções diferentes. Dano final depende também de arma, habilidade, defesa, modificadores e alvo; **ATQ básico não equivale ao dano do golpe**. Fonte: [`status.cpp`, `status_base_atk`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/src/map/status.cpp#L2424-L2504).

**Defesa:** a função de atributos `status_calc_misc` usa, no Pre-Renewal, `DEF2 += VIT` e `MDEF2 += INT + floor(VIT/2)`. Em Renewal, `DEF2` incorpora Base Level, VIT e AGI, e `MDEF2` incorpora INT, Base Level, DEX e VIT. A defesa de equipamento (`DEF`) é tratada à parte e sofre modificadores de estado; portanto não há uma única fórmula curta de “defesa final” que sirva aos dois modos. Fonte: [`status.cpp`, `status_calc_misc`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/src/map/status.cpp#L2617-L2745), [`status_calc_def`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/src/map/status.cpp#L7748-L7810).

**Velocidade:** separar **cadência de ataque** de **deslocamento**. `status_base_amotion_pc` usa AGI/DEX, arma e escudo para ASPD, com fórmulas distintas por modo. `status_calc_speed` processa velocidade de caminhada como atraso base sujeito a montaria, habilidades e estados. Logo, “AGI aumenta diretamente metros/segundo” não é conclusão sustentada por esses trechos. Fontes: [`status.cpp`, ASPD](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/src/map/status.cpp#L2352-L2418), [`status.cpp`, caminhada](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/src/map/status.cpp#L8018-L8120).

## 4. Classic / Pre-Renewal e Renewal

**Verificado:** o rAthena separa bancos em `db/pre-re/` e `db/re/` e condiciona partes do servidor a macros de `src/config/renewal.hpp` (`RENEWAL`, `RENEWAL_EXP`, `RENEWAL_ASPD`, `RENEWAL_STAT` etc.). As curvas de EXP têm valores e ritmo diferentes; HP/SP e bônus de classe podem ter dados diferentes. ATQ, precisão, esquiva, defesa secundária, ASPD e custo de pontos de atributos também têm ramificações de fórmula. `RENEWAL_EXP` inclui modificador de EXP por diferença de nível entre personagem e monstro, sem equivalente direto numa arena sem monstros. **Não existe “uma fórmula de Ragnarok” única que cubra todos os modos, classes e versões.** Fontes: [`renewal.hpp`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/src/config/renewal.hpp), bancos e `status.cpp` acima.

## 5. Comparação e proposta para o RagnArena

**Estado verificado no projeto:** [`docs/PRIMEIRA_IMPLEMENTACAO_PROGRESSAO.md`](../PRIMEIRA_IMPLEMENTACAO_PROGRESSAO.md) e [`resources/arena_progression.json`](../../resources/arena_progression.json) já definem teto inicial Base 40 e Job 40, personagem de classe fixa na criação, EXP independente por personagem, progressão permanente e marcos de **EXP total**: Base 40 = 30.000; Job 40 = 16.500. A meta declarada é aproximadamente 200 partidas para Base 40 e 150 para Job 40. Os valores da arena atual incluem EXP por tempo ativo, eliminação, assistência, uso efetivo de habilidade, conclusão e vitória; derrotados conservam 75% da recompensa gerada até a morte. A progressão permanente ainda não muda atributos ou skills do combate. O [backlog da nova fase](../BACKLOG_NOVA_FASE.md) registra Base 99 como horizonte futuro e evolução de classe no Job 40, **não implementada nesta primeira etapa**.

| Mecanismo | Adaptação proposta, ainda sujeita a decisão |
|---|---|
| Duas trilhas independentes | Manter Base EXP/Level e Job EXP/Level por personagem. A EXP de arena já separada cumpre esse papel. |
| Curvas por classe | Manter curvas Base e Job configuráveis; usar curva Job distinta por **etapa** apenas quando evoluções forem desenhadas. Não copiar os números do rAthena. |
| Pontos Base | Reservar um saldo de pontos de atributos com concessão única por marco Base; definir orçamento e custo de compra próprios após testes PvP. |
| Bônus Job | Separar pontos livres de skill de bônus automáticos de classe. Definir se haverá bônus automáticos antes de implementar. |
| Skills | Manter ranks e pré-requisitos em dados por etapa; registrar marcos já pagos para que eventual reset de Job não duplique pontos nem apague ranks. |
| HP/SP/combate | Usar o padrão “valor base da classe + efeito dos atributos + equipamento + habilidade” como arquitetura. Escalas numéricas e fórmulas PvP precisam de simulação própria; o protótipo atual permanece intacto. |
| Velocidade | Tratar velocidade de caminhada e cadência de ataque como parâmetros diferentes, com limites próprios para legibilidade e equilíbrio mobile. |
| EXP por partida | Preservar recompensa por contribuição válida, com controle de repetição por `character_id:match_id`. Ajustar curva e recompensas conjuntamente em playtests. |

**Cheque de ritmo, não previsão de resultado:** 30.000/200 = 150 Base EXP por partida em média e 16.500/150 = 110 Job EXP por partida em média. Essa média deve incluir vitórias, derrotas, mortes, abandonos e jogadores com zero eliminações. Com valores fixos e sem objetivo/monstro, copiar o rAthena literalmente produziria outro ritmo. O marco total de 40 do rAthena não é comparável diretamente ao custo da linha `Level: 40`; é preciso somar os níveis 1→2 até 39→40, como feito na tabela acima.

## 6. Questões que ainda precisam de decisão

1. O teto Base 40 é apenas do beta; em que momento e com qual política de migração será aberto até 99?
2. Quantos pontos Base cada nível concede, qual o saldo inicial, quais os custos e tetos por STR/AGI/VIT/INT/DEX/LUK? Haverá reset?
3. O Job Level concede exatamente 1 ponto de habilidade por subida, como no rAthena, ou uma cadência menor para partidas curtas? Pontos não gastos passam para outra etapa?
4. Haverá bônus automáticos por Job Level além dos pontos livres? Se houver, acumulam quando a etapa evolui?
5. Quais atributos afetam HP, SP, dano, precisão, esquiva, defesa, crítico, cadência e movimento, e quais limites evitam vantagem excessiva no PvP?
6. Qual duração real e distribuição de resultados das partidas? A média observada sustenta as metas 200/150 inclusive para jogadores derrotados cedo?
7. Quando houver multiplayer, o servidor validará eventos e pagamento único de EXP; como migrar os perfis locais já persistidos?
8. A futura evolução no Job 40 reinicia Job em 0 conforme o backlog; como representar curva, pontos e bônus da nova etapa preservando os ranks anteriores?

## 7. Recomendações para futura implementação em Godot

**Propostas técnicas, não implementação nesta tarefa:** manter dados de curva, orçamento de pontos, bônus por classe/Job e fórmulas em recursos versionados; separar o estado permanente do personagem (EXP, classe, pontos, ranks, equipamento) do estado da rodada (HP atual, efeitos, recargas). Ao receber recompensa, calcular Base e Job de forma independente, percorrer todos os marcos atingidos, conceder pontos **uma vez por marco e etapa** e persistir de modo atômico. Registrar versão da curva usada no perfil para migração futura. Antes de conectar atributos ao combate, simular builds extremas e cenários de vitória/derrota em faixas 1–10, 11–20, 21–30 e 31–40; verificar progressão para jogadores que não eliminam adversários. Projetar validação autoritativa no servidor antes de rankings ou economia online. Nenhuma dessas ações foi executada nesta pesquisa.
