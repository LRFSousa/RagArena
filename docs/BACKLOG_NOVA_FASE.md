# RagnArena — backlog de definição da nova fase

Este documento organiza o redesenho do jogo **antes de alterar a jogabilidade**. O backlog de releases em `docs/BACKLOG.md` registra o protótipo que já funciona; itens concluídos nele são evidência histórica, não aprovação automática das novas regras.

## Ordem de definição

1. **Classes** — cinco classes iniciais planejadas; cada personagem tem classe fixa e progressão própria nesta primeira implementação. Ramos e evolução ficam para depois.
2. **Habilidades** — fechar primeiro o Espadachim como referência; depois aplicar o mesmo contrato às outras quatro classes.
3. **Atributos** — definir Base/Job XP, curva 1–99, pontos, dano, defesa e limites por faixa.
4. **Itens e Inventário** — definir arma, armadura, acessório, estoque, atalhos, saque, upgrade e monetização.
5. **Navegação e Mapa** — definir arenas fechadas por faixa, salas de 5/10/20, coberturas, eventos e fechamento. Portais de acesso ficam antes da partida e serão definidos depois; não haverá portais internos nem entrada em casas na arena.

**Regra de execução:** a primeira implementação de personagens e progressão persistente está descrita em `docs/PRIMEIRA_IMPLEMENTACAO_PROGRESSAO.md` e no relatório correspondente; os demais tópicos serão tratados antes das respectivas mudanças. O mapa 3D segue como evolução futura.

## Panorama dos tópicos seguintes

| Tópico | Já existe no protótipo | Direção aprovada ou discutida | Falta definir antes de desenvolver |
|---|---|---|---|
| 2. Habilidades | Ataque básico e três habilidades para cada um dos quatro protótipos; botão de ataque, Q/E/F e efeitos provisórios | Definir primeiro o Espadachim como modelo para as outras classes | Confirmar kit, alcance, custo, recarga, desbloqueio, melhoria e persistência do Espadachim; replicar a estrutura às demais classes depois |
| 3. Atributos | Atributos V1 persistentes; dois painéis de atributos e secundários; FOR afeta o ATK e VIT afeta HP na Arena01 | Base/Job Level e EXP persistentes por personagem com teto inicial 40 | Validar ritmo e fórmulas em PvP; integrar os demais secundários ao combate, definir bônus, faixas de arena e curva além do nível 40 |

| 4. Itens e Inventário | Quatro slots de consumíveis temporários, drops e buffs provisórios | Propriedade de equipamentos e itens persiste após vitória ou morte; começar com arma, armadura e acessório; quatro botões rápidos são atalhos do inventário | Capacidade, obtenção, raridade, equipar, uso, upgrade, moedas, preços, regras de compra e armazenamento no servidor |
| 5. Navegação e Mapa | Arena 2D maior que a tela, câmera, minimapa, pedras e caixas; layout lógico preparado para 3D futuro | Salas de 5, 10 ou 20 pessoas; barris, pedras, saque e eventos na arena; sem mundo aberto | Mapa por capacidade/faixa, spawns, espera da sala, fechamento, objetivos, distribuição de recursos e desempenho mobile |

Referência pesquisada para bônus automáticos Job e HP/SP das cinco classes: `docs/research/first_class_job_bonuses_reference.md`. Esses bônus são distintos dos pontos livres Base e dos pontos de habilidade Job; a transposição das curvas numéricas para a arena ainda depende de balanceamento.

Essas linhas são um **inventário de decisões e lacunas**, não tarefas marcadas como concluídas. Cada tópico terá seu próprio contrato e critérios de aceite quando for discutido.

## 1. Classes

### Referência e direção

- [Aprovado] Cada personagem terá **nível Base permanente de 1 a 99**, Base EXP, Job Level e Job EXP próprios. Nenhuma EXP é compartilhada entre personagens. O nível determinará a faixa de arena; as bordas serão fechadas no tópico Atributos/Mapa.
- [Aprovado] O primeiro beta terá **cinco classes selecionáveis: Espadachim, Mago, Arqueiro, Noviço e Gatuno**. Evoluções de segunda e terceira classe ficam para depois dos testes e correções do beta.
- [Aprovado] **Job Level separado do Base Level** já fará parte do beta. A primeira classe da linha Espadachim evoluirá ao chegar ao **Job Level 40**; a curva de Job XP será definida no tópico Atributos. Limites das etapas posteriores continuam abertos.
- [Aprovado para a primeira implementação] A classe inicial é **fixa na criação do personagem**; para jogar com outra classe, cria-se outro personagem com Base/Job Level e EXP independentes. **Não haverá troca de classe nesta entrega.** A regra anterior de reset de Job na troca fica substituída neste escopo; evolução de etapa permanece futura.
- [Aprovado] A linha do Espadachim terá **três etapas de classe** (Espadachim → segunda classe → terceira classe), com duas ou mais opções de ramo preparadas para o futuro. A primeira evolução ocorrerá no Job Level 40, reiniciará o Job Level em **0** na nova etapa e liberará novas habilidades. Nenhuma evolução será jogável no primeiro beta.
- [Referência] Ragnarok Mobile usa níveis Base e Job separados e progressão por etapas de profissão. Requisitos e ramificações servem como referência de estrutura, sem copiar arte, texto, habilidades ou números. Fontes oficiais: [progressão de profissão](https://ragnarokm.gungho.jp/member/help/vbnfjd00000009qz.html), [Base/Job](https://ragnarokm.gungho.jp/member/help/vbnfjd00000009f3.html), [ramo Cavaleiro/Paladino](https://ragnarokm.gungho.jp/member/event/3rd_classes_upd/).
- [Referência] As cinco linhas iniciais correspondem às profissões básicas de espada, magia, arco, acólito e gatuno na referência. As ramificações abaixo são **propostas de direção**, não nomes ou poderes finais a copiar. Fontes oficiais: [linhas básicas](https://ragnarokm.gungho.jp/member/update/tearsglastheim_upd_info.html), [exemplo de Mago e Arqueiro](https://ragnarokm.gungho.jp/member/event/2020_1st_upd/), [árvore e Job Level](https://ragnarokm.gungho.jp/member/help/vbnfjd00000009qz.html).

### Estado existente

- [x] Há protótipos de quatro classes com atributos e três habilidades cada: Paladino, Mago, Assassino e Arqueiro (`scripts/class_balance.gd`, `scripts/combat_system.gd`). Isso valida possibilidades técnicas, mas não define as classes disponíveis no beta.
- [x] O personagem visual do Espadachim possui caminhada em quatro direções e ícones/efeitos provisórios. O jogo associa esse visual ao combate `paladin`; isso não representa ainda uma classe Espadachim implementada.
- [x] Há presets locais que armazenam uma classe editável (`user://profile_v1.json`). Eles não são personagens distintos nem guardam nível Base, Job, habilidades ou equipamento.
- [x] Há progressão de combate 1–30 **somente dentro da rodada**. Ela será substituída pela progressão permanente aprovada; os testes antigos deverão ser atualizados junto com a migração.

### Cinco classes do beta e propostas de ramificações

| Classe inicial aprovada | Papel proposto para discutir em Habilidades | Duas direções futuras para a segunda classe | Terceira classe |
|---|---|---|---|
| Espadachim | Combate corpo a corpo e proteção | Cavaleiro ofensivo / Guardião defensivo | Uma evolução para cada ramo, a definir depois do beta |
| Mago | Dano mágico e controle de espaço | Feiticeiro ofensivo / Sábio de suporte e controle | Uma evolução para cada ramo, a definir depois do beta |
| Arqueiro | Dano à distância e posicionamento | Caçador de precisão / Bardo de apoio e ritmo | Uma evolução para cada ramo, a definir depois do beta |
| Noviço | Cura, proteção e combate de curta distância | Sacerdote de suporte / Monge de combate | Uma evolução para cada ramo, a definir depois do beta |
| Gatuno | Mobilidade e ataques de oportunidade | Assassino de explosão / Trapaceiro de controle | Uma evolução para cada ramo, a definir depois do beta |

Os papéis e nomes das ramificações são propostas para discussão; cada linha poderá ter mais de duas opções. Nenhuma restrição de gênero é proposta para as classes. Requisitos de evolução, habilidades e nomes finais serão decididos depois dos testes do beta.

### Contrato de classe para o beta

- [ ] Criar IDs internos estáveis para as cinco classes, separados de nome exibido e arte. Migrar o ID `paladin` e os perfis locais existentes sem perder a identidade ou presets.
- [ ] Definir os papéis e fraquezas das cinco classes no tópico Habilidades. Não estabelecer vantagem permanente sem limites por faixa de arena.
- [ ] Definir quais regras do Paladino protótipo ficam no Espadachim e quais serão reservadas ao ramo defensivo; adaptar os protótipos de Mago e Arqueiro; decidir o reaproveitamento do Assassino no Gatuno; criar Noviço.
- [ ] Desenhar modelo permanente de conta com vários personagens: ID e classe inicial fixa por personagem, nível/EXP Base e Job individuais. Reservar campos versionados para etapa, ranks de habilidades e marcos de Job futuros. Separar os dados persistentes dos estados temporários da rodada (HP atual, recargas e efeitos).
- [ ] Exibir e evoluir Job Level separadamente de Base Level no beta. Definir limite, recompensas e curva no tópico Atributos.
- [ ] Definir criação e seleção de personagem fora da arena. O personagem e sua classe ficam fixos durante a rodada; desabilitar troca de protótipo no fluxo normal.
- [ ] Limitar a criação de personagens do beta às cinco classes iniciais; manter a classe de cada personagem imutável nesta entrega. Manter protótipos antigos como recursos de desenvolvimento até migrar seus dados e testes.
- [ ] Adicionar testes de persistência, migração de perfil, seleção de personagem e reinício de rodada sem perda de progresso Base/Job; testar isolamento de EXP entre personagens.

### Evoluções futuras, fora do primeiro beta

- [ ] Definir os nomes e papéis finais de **duas ou mais ramificações por classe inicial**; reservar IDs e relações de pré-requisito na estrutura de dados sem implementar classes futuras no beta.
- [ ] Implementar a primeira evolução da linha Espadachim no Job Level 40 depois do beta; definir requisitos e limites da terceira etapa quando a curva de XP e o tempo esperado estiverem fechados.
- [ ] Preservar integralmente os ranks aprendidos nas etapas anteriores ao evoluir; definir acesso às habilidades anteriores, compatibilidade de equipamento e presets na evolução.
- [ ] Criar arte, efeitos, balanceamento, testes e migração de dados para cada classe efetivamente adicionada.

### Critérios de aceite deste tópico de planejamento

- As cinco classes do beta, seus papéis, IDs, relação com protótipos atuais e dados permanentes estão definidos sem ambiguidade.
- A árvore futura está no backlog sem bloquear o beta. Habilidades, atributos e equipamentos têm pontos de integração explícitos para os próximos tópicos.
- Nenhuma regra provisória do protótipo 1–30 é apresentada como regra definitiva do personagem 1–99.

### Decisões abertas para o responsável

1. **Papéis iniciais:** os cinco papéis da tabela representam o estilo de combate desejado? Alcances e habilidades concretas serão discutidos no tópico 2.
2. **Noviço no PvP:** deve priorizar suporte e cura mesmo em arena individual, ou ter potencial ofensivo comparável às demais classes? A resposta afeta seu kit no tópico 2.

**Escopo imediato de progressão:** ver `docs/PRIMEIRA_IMPLEMENTACAO_PROGRESSAO.md`. A regra anterior de troca de classe foi substituída por personagens independentes de classe fixa; a evolução em três etapas continua planejada para depois.

## 2. Habilidades — Espadachim primeiro

### Estado do protótipo

- [x] O visual e os efeitos provisórios de ataque, Proteção Divina, Cura e Determinação estão vinculados ao ID técnico `paladin`.
- [x] O protótipo tem ataque básico de linha e três habilidades ativas: escudo de 35 pontos por 5 s (recarga 8 s), cura de 25% do HP máximo (12 s) e resistência a empurrão por 5 s (10 s). Os valores são do protótipo, **não balanceamento aprovado para o beta**.
- [ ] Corrigir a divergência entre o alcance visual/seleção de alvo da arena (`attack_range` de 152 px) e o alcance de dano do combate (`range` de 86 px). O contrato novo deverá usar a mesma regra de alcance para clique, aproximação automática e acerto.

### Kit do Espadachim aprovado em conceito

**Decisão posterior:** usar a árvore completa do Espadachim clássico Pre-Renewal como referência de habilidades, em vez de limitar a classe às quatro habilidades da tabela abaixo. Os nomes são provisórios; não importar código, texto descritivo ou arte de terceiros. A tabela abaixo continua válida para as quatro habilidades já discutidas, e as demais estão inventariadas em `docs/research/swordsman_skill_tree_reference.md`.

**Custos e tempos definidos:** manter os valores Pre-Renewal das dez habilidades como registrados no documento de referência. Diferenciar duração do efeito, atraso após uso e recarga; passivas não têm custo de ativação. Isto substitui as lacunas de custo, duração e recarga da tabela abaixo; dano e funcionamento PvP ainda dependem da integração do combate.

| Ação | Tipo e função | Alvo e alcance | Progressão a definir |
|---|---|---|---|
| Ataque básico — Golpe físico | Ataque comum com corte e arco luminoso | **Um alvo** inimigo ou objeto destrutível até **2 blocos**, incluindo o bloco adjacente; toque fora do alcance aproxima antes de atacar | Disponível desde o início; dano acompanha atributos e arma |
| Aumentar Recuperação de HP | Passiva de recuperação periódica enquanto imóvel; melhora cura recebida de habilidades e itens | O próprio Espadachim | Até 10 ranks como referência; intervalo, valores e condição de imobilidade serão adaptados ao ritmo da arena |
| Perícia com Espada | Passiva de ATQ com espada de uma mão ou adaga equipada | O próprio Espadachim | Até 10 ranks como referência; bônus por rank será balanceado com equipamentos |
| Golpe Fulminante | Ativa ofensiva: golpe físico forte em um oponente | **Um alvo até 2 blocos**, mesmo alcance do ataque básico, incluindo caixas destrutíveis | Até 10 ranks como referência; dano, precisão, custo e recarga a definir |
| Vigor | Ativa defensiva: impede reação/empurrão ao receber ataque e pode conceder defesa | O próprio Espadachim | Até 10 ranks como referência; duração, defesa, custo, recarga e pré-requisitos a definir |

As quatro habilidades seguem as referências fornecidas pelo responsável: [Aumentar Recuperação de HP](https://browiki.org/wiki/Aumentar_Recupera%C3%A7%C3%A3o_de_HP), [Perícia com Espada](https://browiki.org/wiki/Per%C3%ADcia_com_Espada), [Golpe Fulminante](https://browiki.org/wiki/Golpe_Fulminante) e [Vigor](https://browiki.org/wiki/Vigor). Os números, a duração de Vigor, o custo de SP e o pré-requisito de Provocar **não estão aprovados automaticamente**. Efeitos, texto e ícones do jogo serão próprios.

[Aprovado para evolução futura] Ao evoluir de etapa, Job Level e Job XP reiniciam, mas os **ranks das habilidades já aprendidas nunca são perdidos**. A nova etapa libera uma árvore adicional. Base Level/EXP permanecem no mesmo personagem. Troca livre de classe foi retirada da primeira implementação. Recargas, HP e efeitos ativos recomeçam em cada rodada.

**Regra futura de pontos da linha Espadachim:** cada marco de Job Level concede pontos **uma vez por personagem e etapa de classe**. O personagem guarda quais marcos já concederam pontos e os ranks comprados. Ao evoluir, a nova etapa começa no Job Level 0 com seus próprios marcos e pontos. A quantidade de pontos por marco e a possibilidade de gastar pontos de uma etapa em outra ainda serão definidas. **Nenhum ponto ou benefício de habilidade será concedido nesta primeira implementação de progressão.**

Proteção Divina, Cura e Determinação continuam apenas no protótipo `paladin`; não compõem este kit inicial do Espadachim. Podem ser avaliadas para evoluções futuras.

### Contrato e critérios de aceite para implementação posterior

- [ ] Fixar o tamanho lógico de um bloco e medir o alcance do ataque pelo mesmo sistema usado em mira, aproximação automática e colisão; alvos no primeiro e no segundo bloco devem receber dano, inclusive caixas encostadas no personagem.
- [ ] Aplicar o mesmo alcance de dois blocos ao ataque básico e ao Golpe Fulminante; a distinção entre ambos virá do dano e demais propriedades da habilidade, não do alcance. Ambos acertam um único alvo por acionamento.
- [ ] O ataque básico deve acertar **um único alvo por acionamento**, mesmo com vários alinhados; obstáculos sólidos bloqueiam o golpe. Definir seleção de alvo quando dois alvos ocupam o mesmo bloco.
- [ ] Definir Job Level mínimo de cada habilidade, pontos por rank, custo de recurso, recarga, duração e valores por rank no tópico Atributos/Habilidades, após validar tempo de partida e HP por faixa.
- [ ] Impedir que a recuperação passiva conceda XP por ficar parado; limitar cura ao HP máximo e definir se dano interrompe a condição de imobilidade.
- [ ] Na etapa futura de habilidades, garantir que a evolução não duplique pontos nem apague ranks persistidos; definir como equipamento incompatível afeta Perícia com Espada.
- [ ] Na etapa futura de habilidades, testar toque direto em alvo, botão ATK, aproximação fora do alcance, bloqueio por obstáculo, primeiro/segundo bloco, um único alvo atingido, passivas, recargas e evolução com ranks preservados.
- [ ] Fechar este kit e usá-lo como **formato de especificação** para Mago, Arqueiro, Noviço e Gatuno, sem presumir que terão a mesma quantidade de habilidades ou os mesmos números.

### Decisões abertas deste kit

1. Os pontos de uma etapa poderão ser gastos apenas nas habilidades daquela etapa ou também nas etapas anteriores?
2. Recuperação passiva ficará ativa apenas fora de combate ou também durante combate quando o jogador permanecer imóvel?
