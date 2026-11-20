# Primeira implementação — personagens e progressão de Arena

Este documento prepara a primeira entrega de progressão permanente. **Ainda não autoriza alterar o combate, habilidades ou balanceamento.** As decisões pendentes ao final precisam ser fechadas antes da implementação.

## Decisões recebidas

- Cada personagem tem ID, nome, classe inicial fixa, Base Level/EXP e Job Level/EXP próprios. Uma conta pode criar vários personagens, sem compartilhar EXP entre eles.
- A classe é escolhida na criação do personagem e não pode ser trocada nesta entrega. A evolução em três etapas e seus ramos permanecem no backlog futuro; o Espadachim chegará ao requisito de evolução no Job Level 40, mas não evoluirá nesta entrega.
- Duas tabelas configuráveis definem a EXP exigida para o próximo Base Level e Job Level. A curva clássica Pre-Renewal do rAthena é referência para o formato e a progressão, sujeita a adaptação ao tempo de partida da Arena.
- Ao finalizar uma partida válida, o personagem recebe Base EXP e Job EXP por participação, vitória, eliminações, assistências, objetivos e uso efetivo de habilidade. Jogadores derrotados também podem receber participação.
- Os níveis são atualizados e salvos por personagem; estruturas de desbloqueios futuros podem existir sem conceder benefícios nesta entrega.
- Não implementar maestria por classe, troca de classe, evolução, alteração de atributos, nova regra de habilidade ou mudança no balanceamento do combate.

## Recompensas iniciais propostas

| Evento | Base EXP | Job EXP | Contagem |
|---|---:|---:|---|
| Concluir partida válida | 30 | 20 | Uma vez por personagem/partida, mesmo derrotado |
| Vencer partida | 50 | 30 | Bônus único além da conclusão |
| Eliminar adversário | 15 | 10 | Por eliminação creditada |
| Assistência | 10 | 10 | Por eliminação em que contribuiu, sem crédito de eliminação simultâneo |
| Cumprir objetivo | 20 | 15 | Por objetivo concluído e identificado |
| Uso efetivo de habilidade | 0 | 5 | Por efeito válido, com limite por partida a definir |

**Exemplo:** participação válida + vitória + uma eliminação = **95 Base EXP e 60 Job EXP**. Participação válida sem vitória nem outros eventos = **30 Base EXP e 20 Job EXP**. Todos os valores da tabela são **propostas para teste**, não a economia definitiva.

Recompensas devem ser calculadas a partir de um resumo de eventos da partida, por `match_id` e `character_id`, e aplicadas uma única vez no resultado. O mesmo evento não pode ser contabilizado duas vezes por reconexão, abertura repetida da tela de resultado ou reinício. O resultado deve informar os eventos creditados, EXP bruta, eventuais ajustes, EXP líquida e níveis ganhos. Conceder zero por ação inválida ou partida anulada.

## Referência de curvas e escala

O arquivo recebido, `Texto colado.txt`, contém uma base `JOB_STATS` do rAthena, com tabelas `BaseExp` e `JobExp` por grupo de profissões e outros parâmetros de combate que **ficam fora do escopo**. Ele lista `MaxBaseLevel: 99` no grupo inicial e `MaxJobLevel: 50` para Espadachim/Mago/Arqueiro/Noviço/Gatuno equivalentes. Para a linha de primeira classe, os requisitos de Job EXP dos níveis 1–39 somam **755.215** para alcançar o nível 40. Mesmo 50 Job EXP por vitória sem outros eventos exigiriam mais de **15 mil vitórias**. Portanto, copiar os números literalmente com as recompensas propostas tornaria a evolução impraticável.

- Manter tabelas **configuráveis e versionadas**, com requisito positivo por nível, crescimento verificável e nível máximo explícito. Base Level permanece planejado de 1 a 99. Para a primeira classe do Espadachim, o marco de evolução futuro é Job Level 40; o limite jogável no beta e o comportamento da EXP excedente ainda precisam ser definidos.
- Testar uma curva adaptada ou um multiplicador de EXP, fixando antes a meta de partidas/horas para alcançar marcos como Base 10, Base 20 e Job 40. Não alterar tabelas após o lançamento sem política de migração de EXP persistida.
- O rAthena é GPLv3 ou posterior conforme cabeçalho do arquivo recebido. Antes de copiar tabelas ou código literalmente para o repositório, decidir atribuição, licença e distribuição; usar a curva como referência estrutural evita incorporar esse arquivo integralmente.

## Contrato mínimo de dados

`account_id` identifica a conta local; `character_id` identifica cada personagem. Cada registro de personagem guarda `class_id` imutável nesta entrega, `base_level`, `base_exp`, `job_level`, `job_exp` e versão do formato de salvamento. A conta guarda `selected_character_id` e a lista de personagens. Um registro de partidas processadas por ID impede duplicação de EXP; a retenção desse registro precisa ser compatível com o modo local e com o servidor futuro.

Migrar `profile_v1.json` sem apagar identidade, presets ou histórico. Hoje o perfil comporta uma identidade e presets cuja classe pode ser editada; a migração precisa definir qual personagem existente será criado e como os presets serão vinculados. Salvar de forma atômica ou recuperável para evitar perda de EXP se o aplicativo for fechado durante o resultado. A fonte de verdade local será substituível por backend quando o multiplayer for implementado.

## Diferenças em relação ao protótipo

- `scripts/progression.gd` mantém nível 1–30 e EXP temporários, reiniciados em cada partida. Também concede EXP imediatamente por dano PvP, eliminação e caixas. A nova progressão **persistente** será separada desse estado para preservar as regras atuais do combate nesta etapa; a política de EXP legada precisa ser definida antes da ligação ao resultado.
- `scripts/local_profile_store.gd` salva um personagem nominal, presets editáveis e histórico, sem progressão permanente. A classe do preset não pode continuar sendo interpretada como classe fixa do personagem.
- `scripts/arena.gd` permite trocar o protótipo de classe durante uma partida por Tab quando a opção de teste está ativa. Isso precisa ser desabilitado no fluxo normal sem afetar ferramentas de teste.
- `scripts/match_controller.gd` emite o resultado uma vez em memória, mas não possui `match_id`, assistências, objetivos ou contagem de uso efetivo. A implementação precisará de telemetria desses eventos e critério de participação válida.
- Atualmente só há protótipos de Paladino, Mago, Assassino e Arqueiro. Noviço e o ID definitivo Espadachim ainda não existem. A progressão deve usar IDs estáveis sem depender do visual ou do balanceamento provisório.

## Backlog da primeira entrega

1. Definir os pontos pendentes abaixo e criar exemplos de progressão por partida para validar tempo até cada marco.
2. Versionar as duas tabelas de EXP adaptadas e validar cobertura, monotonicidade e limite de nível.
3. Criar modelo de conta/personagens e migração segura do perfil v1; permitir criar, listar e selecionar vários personagens de classe fixa.
4. Criar cálculo separado de Base/Job EXP ao fim de partida válida, com eventos comprovados, `match_id`, limites contra repetição e crédito para derrotados.
5. Aplicar EXP, subir múltiplos níveis quando necessário, persistir e exibir nível/EXP de cada personagem após a partida.
6. Preparar campos/eventos de desbloqueio futuros sem conceder pontos, habilidades, atributos ou benefícios agora.
7. Testar migração, isolamento entre personagens, vitória/derrota/empate, saída antecipada, duplicação de resultado, save/load, múltiplos level-ups e limite de nível. Testar no Godot e em celular quando houver build.

## Decisões pendentes antes de codificar

1. **Escala da curva:** quantas partidas ou horas devem levar até Base 10, Base 20 e Job 40? Os números brutos do rAthena e as recompensas propostas não são compatíveis sem adaptação.
2. **Participação válida:** tempo mínimo e/ou ação útil? Como tratar abandono, desconexão e quem morre cedo sem conseguir eliminar ninguém?
3. **Eventos:** o que conta como assistência, objetivo e uso efetivo? Caixas/barris serão objetivos? Qual limite por partida impede farm de habilidade e conluio?
4. **Derrota e XP:** a regra discutida de perda de 25% da EXP ganha na rodada continua valendo para esta entrega? Se sim, sobre Base, Job ou ambas, e antes ou depois dos bônus?
5. **Personagens e migração:** número máximo de personagens por conta local, classes disponíveis na criação inicial e tratamento dos presets/histórico antigos.
6. **Limites:** Job Level inicial visível (0 ou 1), teto jogável da primeira classe nesta entrega e destino de EXP quando o personagem chega ao teto sem evolução implementada.

Após essas respostas, a primeira implementação pode ser detalhada em critérios de aceite finais. O kit e os ranks do Espadachim ficam documentados para a etapa posterior de habilidades, sem mudanças nesta entrega.
