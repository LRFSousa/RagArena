# Build Android de teste

O preset `Android` exporta um APK de depuração do protótipo offline. A versão atual do pacote é `0.7.0` (código 8), com identificador `com.lrfsousa.ragnarena`. Este APK serve para testes locais; ainda não é uma build assinada de publicação.

## Pré-requisitos

- Godot 4.7.2 com templates de exportação da mesma versão.
- Android SDK, Java 21 e keystore de depuração configurados em **Editor > Editor Settings > Export > Android** do Godot.

## Gerar

No PowerShell, na raiz do projeto:

```powershell
.\tools\build_android_debug.ps1 -Godot 'C:\caminho\para\Godot_v4.7.2-stable_win64_console.exe'
```

O script cria `build/android/RagnArena-0.7.0-debug.apk` e informa tamanho e SHA-256. Pode-se passar `-Output` para outro destino. A pasta `build/` fica fora do Git.

## Instalar e conferir

Em aparelho Android com depuração USB autorizada, use `adb install -r build/android/RagnArena-0.7.0-debug.apk`. Conferir entrada, seleção de personagem, partida, ataque e controles em paisagem; fechar e reabrir para validar persistência local. A instalação e execução em aparelho real ainda não foram realizadas nesta etapa.

Para a 1.0 faltam assinatura de release, AAB, testes de múltiplos aparelhos, multiplayer, política de privacidade e revisão de publicação. Não usar a keystore de depuração para distribuição final.
