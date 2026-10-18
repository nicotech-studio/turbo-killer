# TurboKiller

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | [Español](README.es.md) | [Português (Brasil)](README.pt-BR.md) | [Português (Portugal)](README.pt-PT.md) | [Italiano](README.it.md) | [Русский](README.ru.md) | [Türkçe](README.tr.md) | [Bahasa Indonesia](README.id.md) | [Tiếng Việt](README.vi.md) | [العربية](README.ar.md) | [עברית](README.he.md)

Desative o Turbo Boost para ter um Mac mais silencioso e restaure quando precisar de todo o desempenho.

## Baixar

[Baixar](https://github.com/nicotech-studio/turbo-killer/releases/latest) · [TurboKiller](https://turbokiller.nicotech.cc/?lang=pt-BR)

Não. O TurboKiller exige um Mac Intel compatível com macOS 13 ou posterior.

Não. Mantenha a Proteção de Integridade do Sistema ativada e relate problemas sem alterar os ajustes de segurança.

## Instalar

1. Abra o DMG e arraste o TurboKiller para Aplicativos.
2. Abra o app. Se for bloqueado: Ajustes do Sistema → Privacidade e Segurança → Abrir Mesmo Assim.
3. Permita a execução em segundo plano se solicitado e siga as instruções para aprovar a extensão ou reiniciar.

Encerre o TurboKiller e substitua o app em Aplicativos pela versão de TurboKiller-1.2.0.dmg. Siga as solicitações de autorização ou reinício, se aparecerem.

O app e o serviço são assinados com Developer ID. Esta versão não é autenticada pela Apple e o macOS pode bloquear a primeira abertura. Baixe apenas do repositório oficial. Encerre o app antigo antes de substituí-lo.

## Como usar

Escolha “Desativar Turbo Boost” para reduzir o calor e o ruído das ventoinhas e “Restaurar Turbo Boost” para recuperar o desempenho. A desativação pode tornar tarefas exigentes mais lentas. Confira o estado após alternar; se houver erro, não clique repetidamente.

Estado visível no ícone de vento da barra de menus

## Notas da versão · 1.2.0

- Ícone de vento fixo com indicador monocromático de Turbo Boost ativado, desativado ou desconhecido.
- Janela compacta com estado e controle; Macs incompatíveis mostram um aviso no lugar. Ajustes e Encerrar continuam disponíveis.
- 17 versões de idioma no app, site, README e nestas notas, incluindo árabe e hebraico com layout da direita para a esquerda.
- Atualização do estado ao abrir, ao despertar, após operações e periodicamente em segundo plano.

[Notas da versão](docs/releases/1.2.0/pt-BR.md)

## Feedback

Ainda experimental, testado em alguns Macs Intel. A compatibilidade com todas as configurações de hardware e macOS não é garantida. Relate problemas no GitHub com o modelo do Mac, as versões do macOS e do app e o erro completo ou uma captura de tela. Relatos de compatibilidade bem-sucedida também são bem-vindos.

[Relatar um problema](https://github.com/nicotech-studio/turbo-killer/issues/new?template=report.pt-BR.yml)

## Para desenvolvedores

O app SwiftUI da barra de menus se comunica por XPC com um serviço privilegiado que carrega ou descarrega a extensão de kernel legada incluída. O estado reflete o carregamento da extensão, sem medir a frequência da CPU. Abra TurboKiller.xcodeproj no Xcode para compilar. Mantenha o pacote histórico da extensão sem alterações.

[SHA-256](LegacyKextIntegrity.swift)

## Apoiar

O TurboKiller é gratuito e de código aberto. Se ele ajudar você, pode pagar um café para mim.

[Pague um café para mim](https://ko-fi.com/hello_nico_chan)

## Licença

[GPL-2.0](LICENSE) · [Avisos de terceiros](THIRD_PARTY_NOTICES.md)
