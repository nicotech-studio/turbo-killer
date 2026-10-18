# TurboKiller

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | [Español](README.es.md) | [Português (Brasil)](README.pt-BR.md) | [Português (Portugal)](README.pt-PT.md) | [Italiano](README.it.md) | [Русский](README.ru.md) | [Türkçe](README.tr.md) | [Bahasa Indonesia](README.id.md) | [Tiếng Việt](README.vi.md) | [العربية](README.ar.md) | [עברית](README.he.md)

Desative o Turbo Boost para ter um Mac mais silencioso e restaure-o quando precisar de todo o desempenho.

## Descarregar

[Descarregar](https://github.com/nicotech-studio/turbo-killer/releases/latest) · [TurboKiller](https://turbokiller.nicotech.cc/?lang=pt-PT)

Não. O TurboKiller requer um Mac Intel compatível com macOS 13 ou posterior.

Não. Mantenha a Proteção da Integridade do Sistema ativa e comunique problemas sem alterar as definições de segurança.

## Instalar

1. Abra o DMG e arraste o TurboKiller para Aplicações.
2. Abra a aplicação. Se for bloqueada: Definições do Sistema → Privacidade e segurança → Abrir mesmo assim.
3. Permita a execução em segundo plano, se solicitado, e siga as instruções para aprovar a extensão ou reiniciar.

Saia do TurboKiller e substitua a aplicação em Aplicações pela versão de TurboKiller-1.2.0.dmg. Siga os pedidos de autorização ou de reinício, se surgirem.

A aplicação e o serviço estão assinados com Developer ID. Esta versão não foi autenticada pela Apple e o macOS pode bloquear a primeira abertura. Descarregue apenas do repositório oficial. Saia da aplicação antiga antes de a substituir.

## Como utilizar

Escolha «Desativar Turbo Boost» para reduzir o calor e o ruído das ventoinhas e «Restaurar Turbo Boost» para recuperar o desempenho. A desativação pode tornar tarefas exigentes mais lentas. Verifique o estado após a alteração; se ocorrer um erro, não clique repetidamente.

Estado visível no ícone de vento da barra de menus

## Notas da versão · 1.2.0

- Ícone de vento fixo com indicador monocromático de Turbo Boost ativo, desativado ou desconhecido.
- Janela compacta com estado e controlo; Macs incompatíveis apresentam um aviso em alternativa. Definições e Sair continuam disponíveis.
- 17 versões linguísticas na aplicação, no site, no README e nestas notas, incluindo árabe e hebraico com disposição da direita para a esquerda.
- Atualização do estado ao abrir, ao sair do modo de pausa, após operações e periodicamente em segundo plano.

[Notas da versão](docs/releases/1.2.0/pt-PT.md)

## Comentários

Ainda experimental, testado em alguns Macs Intel. Não se garante compatibilidade com todas as configurações de hardware e macOS. Comunique problemas no GitHub com o modelo do Mac, as versões do macOS e da aplicação e o erro completo ou uma captura de ecrã. Também agradecemos relatos de compatibilidade bem-sucedida.

[Comunicar um problema](https://github.com/nicotech-studio/turbo-killer/issues/new?template=report.pt-PT.yml)

## Para programadores

A aplicação SwiftUI da barra de menus comunica por XPC com um serviço privilegiado que carrega ou descarrega a extensão antiga do kernel incluída. O estado reflete o carregamento da extensão, sem medir a frequência da CPU. Abra TurboKiller.xcodeproj no Xcode para compilar. Mantenha o pacote histórico da extensão inalterado.

[SHA-256](LegacyKextIntegrity.swift)

## Apoiar

O TurboKiller é gratuito e de código aberto. Se lhe for útil, pode oferecer-me um café.

[Ofereça-me um café](https://ko-fi.com/hello_nico_chan)

## Licença

[GPL-2.0](LICENSE) · [Avisos de terceiros](THIRD_PARTY_NOTICES.md)
