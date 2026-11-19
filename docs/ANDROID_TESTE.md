# Teste do RagnArena no Android

## Instalar o APK de depuração

1. Copie `RagnArena-0.5.1-debug.apk` para o celular Android (por USB, nuvem ou outro meio de transferência de arquivos).
2. No celular, abra o APK pelo gerenciador de arquivos. Se o Android pedir, permita a instalação de apps desta origem para o aplicativo usado para abrir o arquivo.
3. Instale e abra **RagnArena** com o aparelho em paisagem.

Este APK é apenas para teste da release 0.5. Ele usa uma assinatura de depuração e não é uma versão para loja. Requer Android 7.0 (API 24) ou superior. O pacote é `com.lrfsousa.ragnarena`.

## O que testar

- Se o teclado do sistema não abrir, toque em **Teclado na tela** para inserir nome de personagem e configuração.
- Na primeira abertura, crie um nome e uma configuração. Feche e abra o app e confirme que ambos persistem.
- Crie duas configurações da mesma classe, edite uma delas e selecione a desejada antes da Arena.
- Após uma partida, abra Perfil e confira o histórico local; nova partida deve começar no nível 1 com inventário vazio.

- Arraste o joystick virtual à esquerda e confirme movimento em qualquer direção.
- Encoste em pedras, caixas e bordas; o personagem deve parar sem atravessar.
- Aponte para uma caixa movendo-se, pare e segure o botão de ataque à direita. No nível de teste 1, a caixa deve desaparecer após 3 golpes.
- Observe se a arena, os controles e os textos cabem na tela e se o jogo permanece em paisagem.
- Feche e abra o app novamente para reiniciar a arena.
- Toque em **+60s teste** para avançar o relógio e observar o fechamento; no resultado, toque em **Nova partida**.
- Escolha a classe na configuração antes de entrar na Arena; use os botões Q/E/F para as três habilidades e ataque os bots.
- Destrua caixas para ganhar XP e subir de nível. Colete os itens coloridos e toque nos quatro slots no alto da tela para usá-los.
- Use os botões **Dano** e **Item** no alto à direita para testar cura, escudo e todos os itens. São controles provisórios.

O nível de teste 4 ou 8 pode ser configurado no editor Godot, na cena `scenes/arena.tscn`, antes de gerar outro APK. A tecla `R` reinicia a cena somente no desktop; no celular, feche e reabra o aplicativo.

## Gerar outro APK

Instale Godot 4.7.2 e configure Java SDK e Android SDK conforme a [documentação oficial de exportação Android](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_for_android.html). Instale os templates de exportação da mesma versão do Godot. O preset `Android` está em `export_presets.cfg`.

```text
godot --headless --path . --editor --quit
godot --headless --path . --export-debug Android RagnArena-0.5.1-debug.apk
```

Para instalar por USB com depuração ativada, execute `adb install -r RagnArena-0.5.1-debug.apk`. Se já houver um app com o mesmo pacote assinado por outra chave, desinstale-o antes de instalar este APK.
