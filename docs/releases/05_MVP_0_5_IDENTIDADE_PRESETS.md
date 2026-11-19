# RagnArena — MVP 0.5 — Conta, personagem e configurações

**Status:** Planejada

## Objetivo
Definir identidade persistente e seleção de classe, inicialmente com armazenamento local simulado.
## Tarefas
- [ ] Criar modelo de conta (ID interno), personagem/nome público único e histórico; separar dados persistentes dos dados de partida.
- [ ] Criar fluxo provisório: entrar → criar nome → menu → Arena → escolher configuração/classe → iniciar.
- [ ] Validar nome (proposta: 3–16 caracteres, letras/números/underscore); unicidade global só poderá ser garantida pelo backend futuro.
- [ ] Permitir múltiplas configurações salvas como decks do Magic, inclusive da mesma classe; criar, renomear, selecionar e excluir.
- [ ] Para o MVP, cada configuração salva apenas nome da configuração e classe; habilidades fixas por classe.
- [ ] Nenhuma configuração concede HP, XP, nível, itens ou atributos permanentes; tudo reinicia na partida.
- [ ] Registrar estatísticas locais de teste e preparar interface para persistência remota futura.
## Critérios de aceite
- Jogador pode salvar duas configurações da mesma classe, selecionar uma e iniciar partida nível 1.
- Reiniciar o aplicativo preserva configurações locais; reiniciar a partida não preserva progressão temporária.
## Atenção
Login real, nomes globalmente únicos e histórico confiável dependem da release de backend. Não anunciar autenticação online nesta etapa.

## Contrato de execução do Codex
- Ler `docs/GAME_DESIGN.md`, `docs/BACKLOG.md` e os documentos da release antes de alterar código.
- Implementar somente o escopo desta release; registrar dependências ou dúvidas em `docs/PENDENCIAS.md`, sem inventar regras definitivas.
- Manter Godot 4 + GDScript; cenas e scripts desacoplados, dados de balanceamento configuráveis e recursos visuais provisórios.
- Ao terminar, executar testes disponíveis, registrar comandos, resultados, limitações e passos manuais de validação.
- Criar/atualizar obrigatoriamente `docs/CHANGELOG.md`, `docs/BACKLOG.md`, `docs/RELATORIOS/RELATORIO_05.md` e documentação técnica pertinente. Não marcar como concluído sem teste/evidência.
- Não iniciar a próxima release automaticamente se houver erros bloqueantes. Preparar commit/PR quando houver repositório remoto configurado; não alegar publicação sem realizá-la.
