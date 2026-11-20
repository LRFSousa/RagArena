# Primeira implementação — Base EXP e Job EXP na Arena

Especificação da primeira entrega de progressão permanente. Substitui o rascunho anterior após o backlog detalhado enviado pelo responsável. O sistema foi separado da progressão temporária de combate e não depende dos visuais, permitindo migração futura do mapa para 3D.

## Personagens

- Uma conta local comporta até **9 personagens**. Cada um tem ID, nome, classe inicial fixa, Base Level/EXP e Job Level/EXP individuais; só um entra em uma arena por vez.
- Todos começam em Base 1 e Job 1. O teto inicial é **40** em cada trilha; a EXP acumulada para ao atingir 30.000 Base ou 16.500 Job. A EXP é total acumulada, não saldo reiniciado a cada level-up.
- Não há troca ou evolução de classe, maestria, pontos de habilidade ou novos atributos nesta entrega. O Job 40 prepara a futura evolução do Espadachim, mas não a executa.
- Cinco IDs permanentes são oferecidos na criação: `swordsman`, `mage`, `archer`, `acolyte`, `thief`. Os protótipos de combate ainda têm IDs antigos; `swordsman` usa `paladin` e `thief` usa `assassin` até a migração. **Noviço usa temporariamente o combate do Paladino**, pois seu kit ainda não existe. Isso é informado na seleção.
- A conta antiga v1 cria um personagem a partir do nome e da classe do preset selecionado (ou do primeiro preset; Espadachim na ausência de preset). Presets, histórico e identidade são mantidos; uma cópia `.v1.bak` é criada antes da migração. Presets legados não alteram a classe fixa do personagem.

## Curvas configuráveis

`resources/arena_progression.json` contém as 40 entradas de EXP **total** para Base e Job, os limites e as recompensas. As tabelas foram interpoladas suavemente entre os marcos fornecidos, sem copiar os números do rAthena. Base: L1=0, L10=900, L20=5.200, L30=13.000, L40=30.000. Job: L1=0, L10=500, L20=3.300, L30=8.500, L40=16.500. A classe `ArenaProgression` valida comprimento, crescimento e marcos antes de calcular níveis.

As metas de aproximadamente 200 partidas para Base 40 e 150 para Job 40 são **referências de balanceamento**. A EXP por partida varia com sobrevivência, eliminação e tempo; os marcos não são liberados por número de partidas.

## Recompensas

| Evento | Base EXP | Job EXP | Limite por participação |
|---|---:|---:|---:|
| Minuto completo ativo | 10 | 5 | Até a duração configurada da arena |
| Eliminação | 25 | 20 | 5 |
| Assistência | 15 | 15 | 5 |
| Uso efetivo de habilidade | 0 | 5 | 5 |
| Conclusão com vencedor | 30 | 20 | 1 |
| Vitória | 50 | 30 | 1 |

Não há EXP por objetivos nesta entrega. Apenas o último sobrevivente vence; com zero ou mais de um vivo ao fim do tempo, ninguém recebe bônus de conclusão ou vitória. O derrotado recebe 75% da Base e Job EXP geradas até a morte, arredondadas para baixo, sem perder EXP permanente anterior. Abandono preserva 100% da EXP válida até a saída, sem bônus finais. O cálculo conta apenas minutos completos e limita cada categoria; eventos além do limite permanecem aptos a estatísticas futuras, sem EXP extra.

Uma utilização de habilidade ganha no máximo um crédito, identificado por `use_id`. Dano efetivo, cura de HP perdido, absorção de dano, bloqueio de empurrão e benefícios usados em combate podem creditar; simplesmente ativar uma habilidade sem efeito não credita. Assistências têm suporte no calculador e contador, mas **a arena local atual não possui combate entre bots nem outros jogadores** para produzir assistências reais. A regra de contribuição nos 10 segundos anteriores à eliminação depende da implementação multiplayer.

## Fluxo e persistência

`MatchController` gera `match_id`, conta eventos e tempo ativo e encerra a participação na morte. `ArenaProgression` calcula uma recompensa sem modificar HP, atributos, habilidades ou a EXP temporária da rodada. `LocalProfileStore` soma EXP ao personagem selecionado, calcula Base/Job Level, salva histórico e grava a chave `character_id:match_id`. Uma segunda tentativa com a mesma chave não paga novamente. O arquivo local é versionado como perfil v2, conserva uma cópia `.bak` anterior e tenta recuperá-la se o arquivo principal estiver corrompido.

Na morte, o fluxo retorna à seleção de personagens para reentrada imediata. Sobreviventes veem a recompensa no resultado. A progressão temporária 1–30 ainda aparece na arena como **nível da partida** e continua controlando o combate anterior; a progressão Base/Job permanente aparece na seleção e não afeta balanceamento nesta etapa.

**Limite de arquitetura:** a release 0.6 de servidor/multiplayer foi adiada. Portanto, a autoridade sobre tempo, eventos e pagamento é **local** nesta entrega. O calculador e o contrato de participação foram isolados para mover a validação ao servidor futuramente. Não há garantia contra alteração manual do arquivo local ou manipulação do cliente; não usar estes dados como economia online sem migração e validação no servidor.

## Critérios e testes

- Criar até 9 personagens, manter classe imutável e EXP isolada; Base e Job sobem separadamente e podem subir vários níveis após uma recompensa.
- Validar os 40 marcos, teto, minutos completos, limites por evento, morte 25%, abandono sem penalidade, empate sem vencedor, vitória, duplicidade e persistência após reload.
- Migrar perfil v1 com identidade, presets e histórico preservados; verificar cópia e recuperação de backup.
- Executar `tests/arena_progression_smoke.gd`, `tests/arena_participation_smoke.gd`, `tests/release05_smoke.gd` e regressões de combate. Registrar resultados no relatório da entrega.

## Fora do escopo e pendências

- Autoridade real do servidor, reconexão, assistências de múltiplos jogadores e prevenção de conluio aguardam multiplayer.
- Noviço precisa de combate próprio; Espadachim/Gatuno precisam migrar os IDs de protótipo sem alterar o balanceamento nesta entrega.
- A regra futura de ataque básico do Espadachim com **um alvo** difere do protótipo atual, cujo teste ainda comprova múltiplos alvos alinhados. Essa correção fica para a etapa de habilidades, pois esta entrega proíbe mudanças no combate.
- A curva e recompensas precisam de playtest em celular para verificar se as metas de 150/200 partidas são adequadas. Após publicação para jogadores, qualquer alteração da tabela exigirá política de migração da EXP persistida.
