# Relatório — graybox da arena 3D experimental

## Implementado

- Cena independente `scenes/experimental/mountain_arena_3d.tscn`, com três patamares em 0 m, 2,5 m e 5 m, duas rampas, passagem estreita, rochas e penhascos com barreiras físicas. Toda a geometria e as cores foram geradas no projeto como material provisório original.
- `CharacterBody3D` de teste com cápsula, gravidade, ajuste ao chão e Sprite3D do Espadachim já existente no RagnArena; câmera ortográfica inclinada que segue o personagem e alterna para visão geral com `C`.
- Sonda independente de ataque (`Espaço`) e habilidade (`F`) que mede distância horizontal, diferença de altura e cobertura 3D. O efeito de teste pisca no alvo alcançável; não causa dano nem chama o combate 2D.
- Três marcadores de alvo, selecionáveis com `1`, `2` e `3`; movimento por WASD. A cena principal em `project.godot` continua `scenes/main.tscn`.

## Como abrir

No editor Godot 4, abra `scenes/experimental/mountain_arena_3d.tscn` e execute **Cena atual** (F6). Por linha de comando, use `godot --path . --scene res://scenes/experimental/mountain_arena_3d.tscn`. A cena não aparece no menu do jogo e não altera as arenas existentes.

## Testes

- `godot --headless --path . --script res://tests/mountain_arena_3d_smoke.gd`: passou. Cobriu contagem e alturas da geometria, sprite/câmera, aterrissagem, subida e descida das rampas, passagem estreita, rocha e borda com colisão, alcance, diferença de altura, cobertura e efeito de habilidade de teste.
- Cena executada no Godot 4.7.2 com renderer GL Compatibility; captura 1280×720 inspecionada. O teste visual mostrou os três níveis na visão geral e um enquadramento próximo na entrada.
- Testes automatizados anteriores da arena 2D devem continuar inalterados; a cena experimental usa apenas novos scripts e cenas.

## Limitações

- Não é o mapa de Ragnarok convertido; o projeto `ragx` foi usado apenas como referência técnica. Nenhum asset original ou GLB convertido entrou no repositório.
- As sondas medem possibilidade de acerto e linha de visão, mas **não testam dano, cura, cooldown ou habilidades reais**. Integrá-los ao 3D exigiria uma proposta separada e aprovação antes de modificar o combate atual.
- Ainda faltam navegação automática, seleção por toque, minimapa 3D, quedas controladas, iluminação/arte final e testes de desempenho em celular. A geometria atual é um graybox para descobrir problemas de escala, rampas e legibilidade.
