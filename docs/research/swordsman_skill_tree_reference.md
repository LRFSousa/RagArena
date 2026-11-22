# Espadachim — árvore clássica como referência

Consulta em 22/11/2026 ao rAthena Pre-Renewal, fixado no commit `dd073ca4720b90e4eaf90fd5788eb7676f1b9146`. Esta é uma **especificação de referência**, não uma implementação. Nomes provisórios; efeitos visuais, descrições e código do RagnArena serão próprios.

Fonte principal: [`db/pre-re/skill_tree.yml`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/db/pre-re/skill_tree.yml#L52-L84). Dados de tipo, custo, duração e alcance: [`db/pre-re/skill_db.yml`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/db/pre-re/skill_db.yml#L147-L359). O rAthena declara GPLv3 ou posterior; consultar a licença antes de qualquer reutilização literal.

## Árvore verificada

| Habilidade | ID rAthena | Máx. | Pré-requisito na árvore | Papel para o RagnArena |
|---|---|---:|---|---|
| Perícia com Espada | `SM_SWORD` | 10 | Nenhum | Passiva para espada de uma mão/adaga |
| Perícia com Espada de Duas Mãos | `SM_TWOHAND` | 10 | Perícia com Espada 1 | Passiva para espada de duas mãos |
| Aumentar Recuperação de HP | `SM_RECOVERY` | 10 | Nenhum | Passiva de recuperação |
| Golpe Fulminante | `SM_BASH` | 10 | Nenhum | Golpe físico em um alvo |
| Provocar | `SM_PROVOKE` | 10 | Nenhum | Efeito de enfraquecimento em um alvo; regra PvP ainda precisa de adaptação |
| Impacto Explosivo | `SM_MAGNUM` | 10 | Golpe Fulminante 5 | Ataque de área de fogo ao redor do usuário |
| Vigor | `SM_ENDURE` | 10 | Provocar 5 | Defesa contra reação ao receber golpe |
| Recuperar HP em Movimento | `SM_MOVINGRECOVERY` | 1 | Nenhum na árvore | Habilidade adicional; condição de aquisição a definir |
| Golpe Fatal | `SM_FATALBLOW` | 1 | Nenhum na árvore | Habilidade adicional ligada a Golpe Fulminante; condição a definir |
| Instinto de Sobrevivência | `SM_AUTOBERSERK` | 1 | Nenhum na árvore | Habilidade adicional de combate com HP baixo; condição a definir |

As três últimas aparecem na árvore como habilidades de nível único, mas não são parte dos sete caminhos principais de investimento. O arquivo da árvore não registra nelas pré-requisito; isto **não comprova** que sejam obtidas automaticamente. A forma de desbloqueio deve ser definida ao adaptar as missões de habilidade para um jogo sem mundo aberto.

## Regras já decididas no RagnArena

- Ataque básico e Golpe Fulminante atingem **um alvo até dois blocos**, inclusive caixa destrutível. Isto é uma adaptação visual e de jogabilidade do RagnArena, não o alcance original do rAthena.
- Os ranks comprados persistem quando a futura evolução de classe reiniciar o Job Level. Pontos de habilidade acumulados atualmente ainda não podem ser gastos.
- As três habilidades ativas provisórias Proteção Divina, Cura e Determinação não pertencem à árvore inicial clássica do Espadachim; a substituição no protótipo ocorrerá na etapa de implementação das skills.

## Antes da implementação

### Custos e tempos — decisão de 22/11/2026

**Decisão do projeto:** manter os custos, durações e recargas da referência rAthena Pre-Renewal para essas dez habilidades. Os valores abaixo vêm de [`skill_db.yml`](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/db/pre-re/skill_db.yml#L147-L359) e das [três habilidades adicionais](https://github.com/rathena/rathena/blob/dd073ca4720b90e4eaf90fd5788eb7676f1b9146/db/pre-re/skill_db.yml#L5089-L5116). Uma habilidade passiva não consome SP ao funcionar. Campo ausente no banco significa que **não há valor próprio declarado**; não inventar uma recarga ou duração.

| Habilidade | Custo ao usar | Duração e intervalo declarados |
|---|---|---|
| Perícia com Espada | Nenhum | Passiva contínua |
| Perícia com Espada de Duas Mãos | Nenhum | Passiva contínua |
| Aumentar Recuperação de HP | Nenhum | Passiva contínua; frequência da recuperação vem da lógica do servidor, não de `skill_db.yml` |
| Golpe Fulminante | 8 SP (ranks 1–5); 15 SP (6–10) | Golpe instantâneo; `Duration2: 5000` pertence ao estado secundário de atordoamento, não à duração do golpe; sem `Cooldown` próprio declarado |
| Provocar | 4–13 SP, somando 1 por rank | Efeito 30 s; recarga 1 s |
| Impacto Explosivo | 30 SP; HP 20/20/19/19/18/18/17/17/16/16 por rank | Golpe instantâneo; atraso de ação após uso 2 s; efeito secundário 10 s; sem `Cooldown` próprio declarado |
| Vigor | 10 SP | 10/13/16/19/22/25/28/31/34/37 s por rank; recarga 10 s |
| Recuperar HP em Movimento | Nenhum | Passiva contínua; habilidade adicional de missão |
| Golpe Fatal | Nenhum além do custo do Golpe Fulminante que modifica | Modificador passivo; habilidade adicional de missão |
| Instinto de Sobrevivência | 1 SP ao ativar | Estado ativável; sem duração ou recarga própria declarada; habilidade adicional de missão |

`Duration1`, `Duration2`, `AfterCastActDelay` e `Cooldown` têm papéis diferentes no banco do rAthena. Na implementação, representar esses campos separadamente para não transformar a duração de um estado secundário em recarga de botão. Também preservar os pré-requisitos da árvore: Perícia com Espada 1 para a perícia de duas mãos, Golpe Fulminante 5 para Impacto Explosivo e Provocar 5 para Vigor.

**Ainda requer definição específica da arena:** como obter as três habilidades de missão sem mundo aberto; como Provocar funciona contra outro jogador; como SP se recupera durante a partida; e como os tempos e estados são mostrados na interface. O ataque básico e o Golpe Fulminante continuam com alcance adaptado de dois blocos e um alvo. Não copiar código, arte ou descrições da fonte.
