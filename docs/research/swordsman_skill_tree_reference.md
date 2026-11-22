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

Definir a aplicação de Provocar contra jogadores, as três condições de desbloqueio adicionais, consumo de SP, recargas, duração, dano e área em escala da Arena01. O rAthena registra, por exemplo, Golpe Fulminante com 8 SP nos ranks 1–5 e 15 SP nos ranks 6–10, Vigor com 10 SP e recarga de 10 s, e Impacto Explosivo como habilidade de área com custo de HP e SP. Esses números são **verificados na fonte, não balanceamento aprovado para a arena**. Não copiar a tabela de dano diretamente para o PvP antes de testar HP, duração de partida e faixas de nível.
