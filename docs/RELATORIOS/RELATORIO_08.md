# Relatório da release 1.0 — preparação inicial

## Implementado

- Preset Android atualizado para versão `0.7.0`, código 8.
- Script `tools/build_android_debug.ps1` para gerar APK de depuração e informar tamanho e SHA-256; saída padrão em `build/android/`, ignorada pelo Git.
- Procedimento de build e instalação documentado em `docs/ANDROID_BUILD.md`.

## Testes realizados

- Exportação direta `--export-debug Android` pelo Godot 4.7.2: saída zero e APK de 60.369.989 bytes.
- Execução do script de build: saída zero e novo APK do mesmo tamanho.
- `aapt dump badging`: pacote `com.lrfsousa.ragnarena`, versão `0.7.0`/8, SDK mínimo 24 e alvo 36.
- Na etapa imediatamente anterior, 11 suítes headless passaram após a extração do layout do mapa. `release05_smoke` exigiu `APPDATA` gravável para persistência de teste.

## Problemas e limites

- Não havia aparelho conectado para instalar e executar o APK; a tentativa local de iniciar o servidor ADB também falhou neste ambiente. Instalação e ergonomia Android continuam sem validação.
- O APK é de depuração. A assinatura de publicação, AAB, CI, política de privacidade, testes de rede e balanceamento ainda não foram feitos.
- A 0.6 foi adiada pelo responsável. Login real e multiplayer continuam dependências para os critérios de aceite da 1.0; esta preparação não conclui a release nem autoriza lançamento.
