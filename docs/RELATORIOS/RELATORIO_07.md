# Relatório da release 0.7 — em desenvolvimento

## Implementado

- Guia de estilo provisório, fonte reproduzível e doze PNGs: quatro atlas de classes (64×64 por quadro, quatro colunas, cinco linhas), dois tiles 32×32 e seis ícones 16×16.
- Personagem usa quadros de parado, caminhada, ataque, dano e morte; classe selecionada troca o atlas. Caixas, paredes e itens usam texturas pixeladas.
- HUD reorganizado para HP, nível, XP, cronômetro, inventário, efeitos e recargas. Ataque e habilidades têm alvos de toque separados.
- Áudio sintético para impacto, coleta, habilidade e eliminação.
- A 0.6 foi colocada em espera a pedido do responsável; a 0.7 parte da versão estável 0.5.2.

## Testes

Godot 4.7.2 em modo headless: `release01_smoke`, `release02_smoke`, `release03_smoke`, `release04_smoke`, `release05_smoke` e `health_damage_regression` passaram com código de saída zero após integração visual. `release07_smoke` passou para atlas, troca de classe, quadros de ataque/dano/morte, HUD e separação dos botões de toque. A importação dos PNGs pelo editor Godot também foi executada.

## Limites e problemas

- Os sprites são provisórios e de baixa complexidade. Ainda faltam efeitos visuais específicos de habilidades, variantes direcionais mais ricas e revisão artística.
- Testes headless não validam aparência final, desempenho, ergonomia nem áudio audível em Android. Uma tentativa de captura de viewport headless falhou porque esse modo usa renderizador sem textura de tela; isso não indica erro de execução do jogo.
- A release não está marcada como concluída até teste em aparelhos reais e resolução dos itens pendentes.
