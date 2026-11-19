# Changelog

## 0.7.0 em desenvolvimento — arte pixelada e controles mobile

- Espadachim/Paladino ganhou arco luminoso no golpe básico, escudo dourado na Proteção Divina (Q), aura verde na Cura (E) e energia dourada na Determinação (F). Q agora absorve dano, E cura e F mantém a resistência a empurrão; as três habilidades seguem suas recargas existentes.
- Personagem foi colocado acima das caixas na ordem de desenho para manter os efeitos visíveis durante o combate.
- HUD da Arena reorganizado: quatro itens de uso rápido com ícones acima das três habilidades no canto inferior direito; ataque permanece separado à direita.
- Caminhada do Espadachim alinhada quadro a quadro nas quatro direções; corrigido o salto lateral causado pela posição do desenho dentro das células do sprite.
- Sprites de caminhada do Espadachim fornecidos pelo responsável integrados às quatro direções no Paladino, com seis quadros por direção e escala visual de 25%.
- Minimapa deslocado para o canto superior direito; botões de depuração removidos da interface jogável.
- Ataque básico em linha percorre dois quadros e pode acertar dois alvos alinhados no mesmo golpe; paredes interrompem o ataque.
- Arena de teste ampliada para 2560×1440, com câmera seguindo o personagem em zoom 0,85 e HUD fixo. Spawns foram distribuídos pelo mapa; o total de caixas passou de 12 para 24.
- Minimap provisório mostra posição do jogador e área segura sem revelar oponentes. Fechamento máximo foi ajustado provisoriamente para a escala nova.
- HUD movido para um `CanvasLayer` independente do mundo; os efeitos de ataque permanecem no espaço da arena. Preparação para câmera móvel, sem mudar o tamanho do mapa nesta etapa.
- Atlas provisórios originais para Paladino, Mago, Assassino e Arqueiro, com quadros de parado, caminhada, ataque, dano e morte.
- Tiles de madeira e pedra e ícones para os seis itens substituem formas simples no jogo.
- HUD mais compacto, recargas mostradas nas habilidades e alvo de ataque separado dos botões próximos.
- Sinais sonoros sintéticos para impacto, coleta, uso de habilidade e eliminação.
- Release 0.6 colocada em espera; este trabalho parte da versão estável 0.5.2 e não altera a infraestrutura multiplayer.

## 0.5.2 — dano dos bots visível

- Bots agora disparam projéteis vermelhos. HP só diminui quando um projétil atinge o personagem; movimento e paredes podem evitar o dano.
- O personagem pisca em vermelho ao ser atingido; velocidade do projétil configurável em `resources/classes.tres`.
- Teste de regressão cobre HP parado, disparo, impacto, desvio e cobertura.

## 0.5.1 — digitação no navegador móvel

- Ativado o teclado virtual experimental da exportação Web do Godot.
- Adicionado botão **Teclado na tela** aos campos de personagem e configuração, com letras, números, `_`, espaço, apagar e concluir. O nome continua sujeito à validação existente.
- Teste automatizado passou para digitar e apagar pelo teclado alternativo e criar o personagem.

## 0.5.0 — identidade e configurações locais

- Perfil local com ID interno, nome público imutável, validação provisória e histórico de partidas no dispositivo.
- Entrada local, menu Arena/Perfil/Configurações e escolha de configuração antes da partida.
- Criação, edição, seleção e exclusão de múltiplas configurações; cada uma salva somente nome e classe.
- Classe escolhida aplicada à arena; nova partida reinicia nível, HP, XP e itens, preservando perfil e configurações.
- Suíte headless de persistência e fluxo completo. Sem login real ou garantia de nome único global.

## 0.4.0 — ciclo da partida local

- Estado da partida, simulação configurável de 2 a 5 participantes, eliminação definitiva e modo espectador.
- Encerramento imediato com sobrevivente único ou após oito minutos; empate provisório por tempo ou eliminação simultânea, sem desempate definitivo.
- Aviso e fechamento progressivo da arena com paredes físicas, condução dos participantes para a área segura e remoção de itens cobertos.
- Cronômetro, contagem de vivos, painel de resultado e botão de nova partida; regras provisórias em `resources/match.tres`.
- Suíte headless para 2–5 participantes, fechamento, resultado e reinício; avanço de 60 segundos para teste manual.

## 0.3.0 — classes e combate local

- Paladino, Mago, Assassino e Arqueiro com atributos configuráveis, ataque básico e três habilidades cada.
- Bots locais, dano PvP efetivo e XP por eliminação; projéteis bloqueados por paredes e caixas.
- Recargas, congelamento, imobilização, empurrão, barreira, invisibilidade, velocidade e proteção do Paladino.
- Crescimento de HP/dano por nível e marcos provisórios de habilidade nos níveis 10, 20 e 30.
- Controles de teclado e toque para classes e habilidades; testes headless da release 0.3.

## 0.2.0 — progressão, drops e inventário

- Níveis 1–30 por partida, XP por caixa e curva configurável; fontes futuras de XP PvP preparadas sem inimigos.
- Drop ponderado de seis itens com chance configurável; coleta automática e expiração de itens no chão.
- Quatro slots, empilhamento de poções, uso manual, cooldown global e efeitos temporários com renovação sem soma.
- HP, XP, nível, quantidades e efeitos mostrados na HUD provisória; teclas 1–4 e toque nos slots.
- Parâmetros iniciais reunidos em `resources/balance.tres` e suíte headless da release 0.2.

## 0.1.4 — publicação Web

- Repositório `LRFSousa/RagArena` tornado público e Pages ativado na branch `gh-pages`.
- Jogo acessível em https://lrfsousa.github.io/RagArena/; arena renderizada no navegador sem erros de console.

## 0.1.3 — preparação da versão Web

- Preset Web sem threads e guia para hospedagem estática/GitHub Pages.
- Exportação HTML5 concluída; WebAssembly validado; teste visual em navegador pendente.

## 0.1.2 — APK de teste Android

- Preset de exportação Android e importação ETC2/ASTC configurados.
- Ícone geométrico provisório e guia de instalação no celular.
- APK de depuração gerado e assinatura verificada; teste em aparelho real pendente.

## 0.1.1 — conclusão da release 0.1

- Cenas separadas para arena, jogador, caixa e parede; quatro áreas de spawn de teste protegidas por cobertura de pedra.
- Nível de teste configurável de 1 a 30 e regra de dano contra caixas isolada do futuro combate PvP.
- HUD com nível de teste, caixas destruídas e restantes.
- Orientação Android corrigida para paisagem; escala proporcional de 1280×720.
- Testes automatizados de dano, direção, cadência, bloqueio de ataques, toque simulado, colisão e reinício.

## 0.1.0 — protótipo inicial

- Projeto Godot 4 com arena top-down e obstáculos de madeira e pedra.
- Personagem geométrico, movimento contínuo e colisão.
- Ataque direcional repetido ao segurar, dano em blocos por faixa de nível e destruição aos 0 HP.
- Controles desktop e toque, HUD provisória e reinício rápido.

### Verificação

- Inspeção estática dos arquivos e das conexões de cena/scripts.
- Godot 4.7.2: importação headless do editor concluída sem erros.
- Godot 4.7.2: cena principal executada por 60 quadros em modo headless, saída 0 e sem erros.
- Teste manual de controles e jogabilidade visual ainda pendente em dispositivo/desktop interativo.
