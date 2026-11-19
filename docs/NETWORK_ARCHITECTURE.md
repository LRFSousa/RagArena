# Release 0.6 — arquitetura de teste local

## Decisões desta etapa

- **Hospedagem:** servidor Godot 4 headless no computador local, custo recorrente zero. Testes com computadores ou Android na mesma rede. Não há serviço público hospedado nesta etapa.
- **Conta:** email e senha, verificados pelo servidor. O perfil local da 0.5 não comprova identidade online e não é aceito como autorização.
- **Desconexão:** reservar a vaga e o estado do personagem por até 60 segundos; retorno com token de sessão válido. Após esse prazo, a vaga é abandonada e o personagem é eliminado [política operacional inicial a validar em playtest].

## Topologia e transporte

Um processo Godot dedicado mantém contas de teste, sala e simulação. Clientes enviam apenas intenção de movimento, ataque, habilidade e item. O servidor decide colisões, dano, XP, drops, inventário, fechamento e vencedor. Usa WebSocket para servir o mesmo protocolo a clientes nativos e web. Credenciais exigem `wss://` com certificado válido para o cliente; o servidor se recusa a iniciar autenticação sem TLS.

Para Android nativo em rede local, o cliente precisa confiar no certificado do servidor de teste. A versão publicada em GitHub Pages por HTTPS **não consegue usar um `ws://` local** e navegadores não aceitam automaticamente certificados locais autoassinados. Até existir um endpoint `wss://` com certificado confiável, o Pages permanece no modo offline da 0.5. Isso não é falha de sincronização do jogo.

O servidor aceita no máximo cinco participantes por sala. A primeira versão local usa uma sala, início quando 2–5 participantes estiverem prontos, e deixa os demais aguardando. Sem matchmaking público. A taxa inicial proposta é simulação a 30 Hz e snapshots a 15 Hz [Provisório], com sequência de entrada para rejeitar comandos atrasados ou repetidos.

## Protocolo e autoridade

| Mensagem do cliente | Validação no servidor |
| --- | --- |
| `register/login` | email normalizado, senha, limite de tentativas e sessão; nunca confiar em ID enviado como prova de conta. |
| `create/select_preset` | só ID da própria conta, nome/classe permitidos. |
| `join/ready` | sessão válida, vaga e sala no estado correto. |
| `input` | sequência crescente, direção limitada, frequência, personagem vivo e pertencente ao remetente. |
| `use_item/ability` | slot, inventário, cooldown e estado calculados no servidor. |

O cliente nunca envia dano, XP, HP, drop, eliminação ou vencedor como fato. Snapshots trazem versão do protocolo, tick, participantes, obstáculos, itens, estados temporários, cronômetro e resultado. Eventos confiáveis informam entrada/saída e conclusão; movimento pode usar o estado mais recente. O cliente interpola entre snapshots sem alterar o estado autoritativo.

## Persistência e segurança

Dados de conta, nome globalmente único por comparação sem distinção entre maiúsculas/minúsculas, presets e histórico ficam apenas no servidor de teste. Senhas recebem sal aleatório e derivação de chave; tokens de sessão são aleatórios e temporários. Arquivos de contas, certificados e chave privada ficam fora do repositório. O servidor deve limitar tamanho e frequência das mensagens e nunca registrar senhas ou tokens em log.

## Portas e implantação

- Porta interna inicial: `9080/TCP` [Provisório]. Não abrir para a internet nesta etapa.
- Custo mensal autorizado: R$ 0 para testes locais. Hardware e energia do computador não entram nesta estimativa.
- Para uso público futuro: hospedar servidor com DNS, TLS confiável, backups e monitoramento; obter aprovação de custo antes de contratar serviço.

## Referências técnicas

- [WebSocketMultiplayerPeer no Godot](https://docs.godotengine.org/en/stable/classes/class_websocketmultiplayerpeer.html)
- [Servidor dedicado headless](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_dedicated_servers.html)
- [WebSockets, `ws://` e `wss://`](https://docs.godotengine.org/en/stable/tutorials/networking/websocket.html)
- [Opções de TLS e validação no navegador](https://docs.godotengine.org/en/4.7/classes/class_tlsoptions.html)
