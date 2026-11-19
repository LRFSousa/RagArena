# Relatório da release 0.6 — em desenvolvimento

## Escopo implementado até este marco

- Arquitetura local, sem custo recorrente, em `docs/NETWORK_ARCHITECTURE.md`. O servidor será Godot headless; a versão no GitHub Pages segue offline até haver WSS com certificado confiável.
- `ServerAccountStore`: cadastro com email normalizado, senha com sal e derivação HMAC-SHA256 iterada, nome de personagem global único sem distinção de caixa, login com token temporário e presets salvos pelo servidor.
- `ServerRoom`: uma sala com 2–5 vagas, prontidão, início, desconexão, reconexão com mesmo preset por até 60 segundos e eliminação ao expirar durante a partida.

## Testes executados

Com Godot 4.7.2 estável em modo headless:

```text
godot --headless --path . --script res://tests/release06_accounts.gd
godot --headless --path . --script res://tests/release06_room.gd
```

Ambas as suítes passaram. A primeira cobriu cadastro, validações, nome duplicado, login, token, presets e persistência. A segunda cobriu capacidade e início de salas com 2, 3, 4 e 5 membros, sexta vaga, reconexão e expiração. São testes de lógica local, não de clientes em rede.

As suítes `release01_smoke`, `release02_smoke`, `release03_smoke`, `release04_smoke`, `release05_smoke` e `health_damage_regression` também passaram no mesmo modo headless, todas com código de saída 0.

## Problemas e limites

- Não existe conexão de rede, partida autoritativa, cliente multiplayer, resultados persistentes ou teste com 2–5 clientes reais. Os critérios de aceite da release ainda não foram atendidos.
- O armazenamento JSON da conta precisa de escrita recuperável e limite de tentativas de login antes de uso fora do ambiente local.
- O Pages é HTTPS e precisa de endpoint WSS confiável para multiplayer no navegador. O servidor local de teste não fornece isso automaticamente.

## Próximo trabalho

Implementar transporte WSS e autenticação/sala por conexão, depois migrar a simulação de combate para o servidor e validar partidas reais com 2–5 clientes.
