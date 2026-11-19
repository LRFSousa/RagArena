# RagnArena — Decisões consolidadas e pendências

## Decisões aprovadas
- Nome **RagnArena** é provisório, sujeito a verificação comercial.
- Godot 4 + GDScript; jogo 2D, Android horizontal, pixel art top-down 3/4; arte definitiva após MVP técnico.
- Arena com caixas de madeira destrutíveis, paredes de pedra permanentes e espaços de spawn protegidos; 2–5 jogadores online na versão final.
- Partida com até 8 minutos, sem duração mínima: termina imediatamente com um sobrevivente; sem respawn.
- Arena começa a fechar perto dos 5 minutos, com avisos; eliminação permite espectador.
- Níveis 1–30 dentro de cada partida; XP por caixas, dano efetivo em jogadores e eliminação; tudo temporário é reiniciado.
- Caixas: 45 HP; dano igual entre classes, 15 nos níveis 1–3, 23 nos 4–7, 45 nos 8–30; ritmo de ataque contra caixas igual entre classes.
- Controle 360° com joystick; personagem ataca na última direção de movimento; segurar ataque repete; sem travamento automático de alvo no MVP.
- Classes: Paladino (proteção contra dano à distância, autocura, Endure); Mago (gelo, barreira, fogo); Assassino (invisibilidade, lâmina, velocidade; invisibilidade e velocidade combináveis); Arqueiro (rajada, impacto, armadilha).
- Inventário de quatro slots; cinco consumíveis manuais e Amuleto XP de ativação automática; itens e buffs não persistem entre partidas.
- Conta e nome permanente; configurações de classe salvas como decks do Magic, sem vantagem permanente; classe selecionada antes de entrar na Arena.

## Valores iniciais provisórios
- Drop por caixa 30%; item no chão 20 s; uso manual com intervalo global de 2 s.
- Poção +30% HP; Elixir +60% HP; Força +20% dano PvP/15 s; Velocidade +15%/12 s; Escudo absorve 30 dano/15 s; Amuleto XP +25%/15 s.
- Poções até 3 por slot; demais consumíveis 1 por slot; buffs iguais renovam duração sem somar potência.
- Habilidades, dano PvP, HP, velocidade e cooldowns precisam de testes.
- Nome do personagem: sugestão 3–16 caracteres, letras/números/underscore, unicidade por conta de backend.

## Pendências para decisão posterior
- Curva exata de XP e XP por caixa/dano/eliminação; distribuição ponderada dos drops.
- Duração, alcance, custos e cooldowns finais de habilidades; atributos por classe.
- Regras para eliminação simultânea e limite de tempo sem sobrevivente único.
- Posição de spawn para o quinto jogador, tamanho do mapa e cronograma exato de fechamento.
- Política de desconexão, reconexão, abandono e matchmaking; autenticação e hospedagem.
- Persistência de estatísticas, ranking e monetização (fora do MVP técnico).
- Personalização visual e builds de habilidades (futuro; não incluir no MVP).
- Disponibilidade de nome/marca RagnArena.

## Regra de governança
Uma proposta não se torna decisão aprovada sem validação do responsável. Alterações aprovadas devem ser refletidas neste arquivo e no backlog.
