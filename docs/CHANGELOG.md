# Changelog

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
