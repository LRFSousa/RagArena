# RagnArena — backlog de definição da nova fase

Este documento organiza o redesenho do jogo **antes de alterar a jogabilidade**. O backlog de releases em `docs/BACKLOG.md` registra o protótipo que já funciona; itens concluídos nele são evidência histórica, não aprovação automática das novas regras.

## Ordem de definição

1. **Classes** — detalhada abaixo; algumas decisões ainda precisam de aprovação.
2. **Habilidades** — definir cada ação, alcance, recarga, evolução e persistência.
3. **Atributos** — definir Base/Job XP, curva 1–99, pontos, dano, defesa e limites por faixa.
4. **Itens e Inventário** — definir arma, armadura, acessório, estoque, atalhos, saque, upgrade e monetização.
5. **Navegação e Mapa** — definir arenas por faixa, salas de 5/10/20, coberturas, eventos e fechamento.

**Regra de execução:** fechar os cinco tópicos e seus testes de aceitação antes de substituir sistemas do protótipo. Números ainda não aprovados permanecem provisórios. O mapa 3D segue como evolução futura.

## Panorama dos tópicos seguintes

| Tópico | Já existe no protótipo | Direção aprovada ou discutida | Falta definir antes de desenvolver |
|---|---|---|---|
| 2. Habilidades | Ataque básico e três habilidades para cada um dos quatro protótipos; botão de ataque, Q/E/F e efeitos provisórios | Uma classe no beta, habilidades aprendidas persistentes e recargas temporárias por rodada foram propostos | Kit definitivo do Espadachim, alcance, custo, recarga, nível de desbloqueio, melhoria e compatibilidade com equipamento |
| 3. Atributos | HP, dano, defesa, velocidade, alcance e XP temporários de nível 1–30 | Base Level permanente 1–99; morte desconta 25% da XP obtida na rodada; XP por ações além de eliminações | Curva completa, Job Level, pontos, limites por faixa, fórmulas e proteção contra ganho passivo/abuso |
| 4. Itens e Inventário | Quatro slots de consumíveis temporários, drops e buffs provisórios | Propriedade de equipamentos e itens persiste após vitória ou morte; começar com arma, armadura e acessório; quatro botões rápidos são atalhos do inventário | Capacidade, obtenção, raridade, equipar, uso, upgrade, moedas, preços, regras de compra e armazenamento no servidor |
| 5. Navegação e Mapa | Arena 2D maior que a tela, câmera, minimapa, pedras e caixas; layout lógico preparado para 3D futuro | Salas de 5, 10 ou 20 pessoas; barris, pedras, saque e eventos na arena; sem mundo aberto | Mapa por capacidade/faixa, spawns, espera da sala, fechamento, objetivos, distribuição de recursos e desempenho mobile |

Essas linhas são um **inventário de decisões e lacunas**, não tarefas marcadas como concluídas. Cada tópico terá seu próprio contrato e critérios de aceite quando for discutido.

## 1. Classes

### Referência e direção

- [Aprovado] O personagem terá **nível Base permanente de 1 a 99**. O nível determinará a faixa de arena; as faixas exatas e suas bordas serão fechadas no tópico Atributos/Mapa.
- [Aprovado] O primeiro beta terá **uma classe selecionável**. Evoluções de segunda e terceira classe ficam no backlog para depois dos testes e correções do beta.
- [Referência] Ragnarok Mobile usa níveis Base e Job separados e progressão por etapas de profissão. Requisitos e ramificações servem como referência de estrutura, sem copiar arte, texto, habilidades ou números. Fontes oficiais: [progressão de profissão](https://ragnarokm.gungho.jp/member/help/vbnfjd00000009qz.html), [Base/Job](https://ragnarokm.gungho.jp/member/help/vbnfjd00000009f3.html), [ramo Cavaleiro/Paladino](https://ragnarokm.gungho.jp/member/event/3rd_classes_upd/).
- [Proposta para validar] A classe inicial será **Espadachim**. O nome e o tema das evoluções futuras permanecem abertos. O visual do Espadachim já existe no protótipo; o código de combate ainda o identifica como `paladin` e precisará de migração planejada.

### Estado existente

- [x] Há protótipos de quatro classes com atributos e três habilidades cada: Paladino, Mago, Assassino e Arqueiro (`scripts/class_balance.gd`, `scripts/combat_system.gd`). Isso valida possibilidades técnicas, mas não define as classes disponíveis no beta.
- [x] O personagem visual do Espadachim possui caminhada em quatro direções e ícones/efeitos provisórios. O jogo associa esse visual ao combate `paladin`.
- [x] Há presets locais que armazenam a classe selecionada (`user://profile_v1.json`). Não guardam nível Base, Job, habilidades ou equipamento.
- [x] Há progressão de combate 1–30 **somente dentro da rodada**. Ela será substituída pela progressão permanente aprovada; os testes antigos deverão ser atualizados junto com a migração.

### Contrato de classe para o beta

- [ ] Confirmar nome público da única classe inicial e separar **ID interno estável** de nome exibido e arte. A migração do ID `paladin` e dos perfis locais existentes precisa preservar os dados do jogador.
- [ ] Definir o papel da classe inicial em combate: corpo a corpo, mobilidade, resistência e fraquezas. Não estabelecer vantagem permanente sem limites por faixa de arena.
- [ ] Definir quais regras do Paladino protótipo permanecem no Espadachim e quais serão reservadas a uma evolução futura; habilidades e números serão fechados no tópico 2.
- [ ] Desenhar modelo de dados permanente: nível/XP Base, classe atual, nível/XP Job da classe, classes desbloqueadas, habilidades aprendidas e presets. Separar esses dados dos estados temporários de uma rodada (HP atual, recargas e efeitos).
- [ ] Definir se Job Level começa no beta ou apenas sua estrutura de armazenamento; em qualquer caso, não acoplar Job XP ao nível Base.
- [ ] Definir regras de entrada e troca de classe fora da arena. Uma rodada iniciada mantém a classe escolhida até o resultado.
- [ ] Limitar a seleção do beta à classe inicial. Manter os outros três protótipos como recursos de desenvolvimento, sem apresentá-los como classes finais ou apagá-los antes de migrar seus testes.
- [ ] Adicionar testes de persistência, migração de perfil, seleção de classe e reinício de rodada sem perda de progresso Base/Job.

### Evoluções futuras, fora do primeiro beta

- [ ] Definir a árvore de segunda e terceira classe, inclusive se haverá ramificação ou uma linha única. A referência do Ragnarok Mobile tem ramificações; a árvore do RagnArena ainda não foi aprovada.
- [ ] Definir requisitos de Base/Job Level e eventuais provas de avanço depois de conhecer a curva de XP e o tempo esperado para cada faixa.
- [ ] Definir o que acontece com pontos, habilidades, equipamento compatível e presets ao evoluir ou trocar de classe.
- [ ] Criar arte, efeitos, balanceamento, testes e migração de dados para cada classe efetivamente adicionada.

### Critérios de aceite deste tópico de planejamento

- A classe única do beta, seu papel, ID, relação com o Paladino atual e dados permanentes estão definidos sem ambiguidade.
- A árvore futura está no backlog sem bloquear o beta. Habilidades, atributos e equipamentos têm pontos de integração explícitos para os próximos tópicos.
- Nenhuma regra provisória do protótipo 1–30 é apresentada como regra definitiva do personagem 1–99.

### Decisões abertas para o responsável

1. **Nome inicial:** Espadachim será o nome da classe jogável do beta?
2. **Árvore futura:** prefere uma linha única de evolução ou duas ramificações a partir do Espadachim? Nomes e poderes serão definidos depois.
3. **Job Level no beta:** deve já aparecer e evoluir junto ao Base Level, ou ficar apenas preparado nos dados até a segunda classe?
