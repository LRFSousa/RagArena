# Changelog

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
