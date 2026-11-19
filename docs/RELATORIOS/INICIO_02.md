# Início da release 0.2 — preparação

**Estado:** planejamento inicial concluído; implementação e testes da release 0.2 registrados em `RELATORIO_02.md`.

## Base disponível

- Evento `destroyed` das caixas pode alimentar o ganho de XP e o sorteio de drops.
- `test_level` é apenas uma configuração de depuração; deverá ser substituído por nível derivado de XP na release 0.2.
- `combat_rules.gd` centraliza o dano às caixas e preserva a separação do futuro dano PvP.

## Primeira sequência de trabalho

1. Ler `docs/releases/02_MVP_0_2_PROGRESSAO_ITENS.md` e confirmar valores provisórios e casos de aceite.
2. Implementar XP e curva configurável sem persistência entre partidas.
3. Implementar drops, inventário de quatro espaços e efeitos de itens.
4. Criar testes automatizados para limites de inventário, duração de efeitos e reinício.

Pesos dos itens e curva exata de XP continuam pendentes de teste e não são considerados decisões definitivas.
