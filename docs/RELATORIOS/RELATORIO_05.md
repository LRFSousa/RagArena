# Relatório da release 0.5 — Identidade e configurações locais

- **Data:** 19/11/2026
- **Escopo:** conta e nome locais simulados, menu e configurações de classe. Sem autenticação online.
- **Código:** `scripts/local_profile_store.gd`, `scripts/main_flow.gd`, `scenes/main.tscn`, integração de sinais em `scripts/arena.gd`, `tests/release05_smoke.gd`.

## Implementado

| Requisito | Resultado |
| --- | --- |
| Perfil | ID aleatório interno separado do nome público; nome local imutável com validação de 3–16 caracteres ASCII. |
| Fluxo | Entrada local → menu → Arena → escolha da configuração → partida. Perfil e Configurações acessíveis pelo menu. |
| Configurações | Criar, editar nome/classe, selecionar e excluir. Várias configurações da mesma classe. Só ID, nome e classe são salvos. |
| Partida | Classe escolhida é aplicada antes do início; mudança de classe durante a partida normal é bloqueada. Nível, XP, HP, itens e efeitos começam limpos. |
| Persistência | Perfil, configurações, seleção e até 50 resultados locais em `user://profile_v1.json`; histórico mostra resultados de teste. |

## Testes

Executados no Godot 4.7.2:

```text
godot --headless --path . --editor --quit
godot --headless --path . --script res://tests/release01_smoke.gd
godot --headless --path . --script res://tests/release02_smoke.gd
godot --headless --path . --script res://tests/release03_smoke.gd
godot --headless --path . --script res://tests/release04_smoke.gd
godot --headless --path . --script res://tests/release05_smoke.gd
godot --headless --path . --quit-after 60
```

As cinco suítes passaram sem erros. A 0.5 cobre nome válido/inválido, permanência do nome, ID, dois presets da mesma classe, edição, seleção, exclusão, persistência após nova instância, histórico, menu, classe selecionada, bloqueio de mudança durante a partida, reinício sem itens/XP e retorno ao menu. As suítes antigas foram adaptadas para abrir `arena.tscn` diretamente, pois `main.tscn` agora contém o fluxo de entrada. A tela de criação do personagem também foi inspecionada visualmente no navegador integrado após publicação.

## Validação manual

1. Abra o jogo, crie um nome e entre no menu local.
2. Em Configurações, crie duas opções da mesma classe; edite, selecione e exclua uma delas.
3. Entre em Arena, escolha uma configuração e confira a classe, nível 1 e inventário vazio.
4. Termine a partida, veja o histórico em Perfil, feche/reabra o app e confirme a persistência.
5. Use **Menu** ou tecla `M` para voltar. Reinicie a partida e confirme que XP, HP, itens e efeitos não persistem.

## Limitações

- Após relato de que não era possível digitar o nome no navegador, a versão 0.5.1 ativou o teclado virtual experimental Web e adicionou um teclado na tela aos campos de nome e configuração. A suíte 0.5 verifica digitação, apagar e criação do personagem pelo novo controle; a confirmação em aparelho real ainda depende de teste manual.
- Unicidade global de nome, autenticação e sincronização entre dispositivos dependem do backend futuro.
- Histórico local não é confiável para ranking. Dados do app/navegador podem ser apagados pelo usuário; ainda não há migração entre formatos.
- Navegação, teclado virtual e legibilidade no celular real precisam de playtest.
