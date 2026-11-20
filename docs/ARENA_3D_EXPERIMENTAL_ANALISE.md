# Análise técnica — arena experimental de montanha em 3D

## Decisão de viabilidade

**Viável como cena isolada em Godot 4.** Um bloco de teste com três patamares, rampas, trilhas estreitas e penhascos pode ser criado com geometria e materiais provisórios próprios. A referência é a sensação de elevação e caminhos entre montanhas de Monte Mjolnir, sem reproduzir sua malha, texturas ou outros assets. A cena não substituirá a arena 2D atual.

## Estado do RagnArena

- `scripts/arena_map_layout.gd` já separa posições de chão e inclui `ground_to_3d(Vector2, altura)` e `footprint_to_3d`. `docs/MAPA_3D.md` descreve X/Y lógico → X/Z 3D. Isso ajuda a manter uma convenção, mas a arena atual tem escala lógica grande (2.560 × 1.440); o experimento deve usar escala própria explícita, por exemplo 0,05 m por unidade lógica, antes de tentar reutilizar o mapa existente.
- `scenes/arena.tscn`, `scripts/arena.gd`, `scenes/player.tscn` e `scripts/player.gd` usam `Node2D`, `CharacterBody2D`, câmera 2D e física 2D. `scripts/combat_system.gd` e `scripts/combat_projectile.gd` fazem raycasts 2D. Esses nós não podem ser colocados diretamente numa física 3D com alturas distintas. A progressão Base/Job recém-implementada está separada e não precisa mudar.
- O projeto usa renderer `gl_compatibility`, adequado como ponto de partida para o experimento mobile. É preciso medir a cena em aparelho real antes de pensar em uma arena 3D de produção.

## Cena e arquivos previstos

| Arquivo futuro | Responsabilidade |
|---|---|
| `scenes/experimental/mountain_arena_3d.tscn` | Raiz `Node3D`, iluminação, câmera, terreno, objetos e dois ou mais alvos de teste; não será a cena principal |
| `scripts/experimental/mountain_arena_3d.gd` | Montagem da cena, spawns, indicadores de altura e telemetria de teste |
| `scenes/experimental/test_actor_3d.tscn` | `CharacterBody3D`, `CollisionShape3D` em cápsula e `Sprite3D`/`AnimatedSprite3D` com sprite próprio já existente |
| `scripts/experimental/test_actor_3d.gd` | Movimento em X/Z, gravidade, rampas e orientação visual; sem importar `player.gd` 2D |
| `scripts/experimental/test_camera_3d.gd` | Câmera inclinada que segue o personagem; comparar projeção ortográfica e perspectiva suave |
| `scripts/experimental/height_attack_probe.gd` | Provas isoladas de alcance e linha de visão 3D entre patamares, sem chamar `CombatSystem` 2D |
| `tests/mountain_arena_3d_smoke.gd` | Testes automatizados de geometria, colisão, rampas, bordas e casos de altura; teste visual/mobile separado |
| `assets/experimental/` | Somente materiais e malhas provisórios originais, se forem necessários; nenhuma saída de conversão do cliente de Ragnarok |

Para o primeiro bloco, usar três alturas de exemplo (0 m, 2,5 m e 5 m), rampas longas o suficiente para inclinação confortável e trilhas mais largas que a cápsula do personagem com margem para virar. Rochas e penhascos precisam de `StaticBody3D`/`CollisionShape3D`; bordas sem passagem devem impedir queda. O `CharacterBody3D` oferece `move_and_slide()`, reconhecimento de chão, limite de inclinação e `floor_snap_length`, apropriados para validar subida e descida em rampas. [Documentação Godot 4.7: CharacterBody3D](https://docs.godotengine.org/en/4.7/classes/class_characterbody3d.html).

Os sprites 2D podem ser exibidos no mundo 3D com `Sprite3D` ou `AnimatedSprite3D`, ancorados nos pés e orientados para a câmera. Preservar o teste de profundidade para que rochas e elevações ocultem o personagem corretamente; ajustar `pixel_size` e transparência para manter a nitidez. [Documentação Godot 4.7: SpriteBase3D](https://docs.godotengine.org/en/4.7/classes/class_spritebase3d.html).

Uma `Camera3D` inclinada e acompanhando o personagem pode reproduzir a leitura espacial de um RPG clássico. Projeção ortográfica facilita tamanho constante dos sprites; perspectiva com FOV moderado pode dar mais profundidade. A comparação deve ser feita no celular. Para toque em alvo, usar raio da câmera até a física 3D, não as coordenadas 2D atuais. [Documentação Godot 4.7: Camera3D](https://docs.godotengine.org/en/4.7/classes/class_camera3d.html).

## Ataques e habilidades entre alturas

O experimento deve medir distância horizontal, diferença vertical e linha de visão **separadamente**. Dois personagens próximos na projeção da tela podem estar em patamares diferentes e não ser alcançáveis. Proposta de casos: mesmo patamar; diferença de altura conectada por rampa; um alvo acima de um penhasco sem passagem; rochedo entre atacante e alvo; golpe ao longo de caminho estreito; efeito visual atravessando ou sendo ocultado pelo terreno. Um `PhysicsDirectSpaceState3D`/raycast ou teste de volume 3D deve decidir acerto; o probe apenas registra o resultado esperado. Adaptar as regras reais de alcance e dano será uma etapa posterior, sujeita à aprovação do responsável.

## Avaliação do `ragx`

O projeto [ragx](https://github.com/joaopedrosgs/ragx) declara exportar mapas de um cliente Ragnarok para glTF/GLB (`ragx maps ... --format glb`). O `map_builder.py` monta RSW + terreno GND + modelos RSM; o README também cita GAT para alturas/caminhabilidade, mas a descrição do GLB não garante colisões nem navegação prontas para Godot. A conversão depende de uma instalação do cliente com `data.grf`. Godot 4 aceita `.glb` e `.gltf`, portanto o fluxo é tecnicamente compatível para **inspeção privada de referência**. Fontes: [README do ragx](https://github.com/joaopedrosgs/ragx/blob/main/README.md), [map builder](https://github.com/joaopedrosgs/ragx/blob/main/ragx/map_builder.py), [importação glTF/GLB no Godot](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/available_formats.html).

**Não importar o GLB convertido ao RagnArena.** Além das texturas, malhas e disposição do mapa resultariam de assets da Gravity. O próprio ragx distingue sua licença MIT para código dos direitos dos assets e recomenda não redistribuir saídas convertidas. Usar apenas medidas e observações gerais para desenhar terreno e caminhos originais. [Aviso do ragx](https://github.com/joaopedrosgs/ragx/blob/main/README.md#disclaimer--legal), [licença do código](https://github.com/joaopedrosgs/ragx/blob/main/LICENSE).

## Testes e impacto

1. **Movimento:** subir e descer cada rampa sem saltos, escorregar ou atravessar degraus; manter velocidade aparente estável.
2. **Colisão:** rochas e penhascos bloqueiam; trilhas estreitas continuam transitáveis; o personagem não cai por frestas.
3. **Visibilidade:** sprite troca de direção, não atravessa terreno visualmente e é ocultado por rochas quando apropriado.
4. **Ataques:** comparar alvo no mesmo plano, acima, abaixo e atrás de cobertura, com resultados explícitos de distância e linha de visão.
5. **Habilidades:** efeitos visuais de teste seguem a altura do chão e respeitam cobertura; nenhuma regra de dano/cura atual é reutilizada ou alterada nesta fase.
6. **Desempenho:** medir FPS, memória e tempo de entrada em celular Android, com renderer GL Compatibility e diferentes quantidades de rochas/sprites.

**Impacto no projeto atual:** apenas novos arquivos em `scenes/experimental`, `scripts/experimental`, testes e, se necessário, assets provisórios originais. `project.godot` mantém `scenes/main.tscn` como entrada; `arena.gd`, `player.gd`, combate, HUD e progressão atuais permanecem como estão. Um atalho de desenvolvimento ou comando de teste poderá abrir a cena experimental sem expô-la no fluxo normal. O resultado dos probes informará o custo de adaptar combate e navegação 2D para 3D no futuro.

**Próximo passo após esta análise:** construir um graybox original da cena isolada e executar os testes físicos. A integração de ataques e habilidades reais exige uma proposta separada e aprovação antes de tocar no combate ou na movimentação atuais.
