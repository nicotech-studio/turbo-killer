# TurboKiller

[English](../../README.md) | [简体中文](zh-CN.md) | [繁體中文](zh-TW.md) | [日本語](ja.md) | [한국어](ko.md) | [Deutsch](de.md) | [Français](fr.md) | [Español](es.md) | [Português (Brasil)](pt-BR.md) | [Português (Portugal)](pt-PT.md) | [Italiano](it.md) | [Русский](ru.md) | [Türkçe](tr.md) | [Bahasa Indonesia](id.md) | [Tiếng Việt](vi.md) | [العربية](ar.md) | [עברית](he.md)

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

## Notas da versão · 1.3.0

- A barra de menus e o painel compacto mostram a frequência média da CPU no último intervalo de amostragem.
- Consulte os últimos 5 minutos, 15 minutos ou uma hora. Fundos vermelho/azul claros indicam Turbo Boost ativado/desativado; surge uma referência da frequência base quando é identificada com segurança.
- Escolha intervalos de 1, 2, 5 ou 10 segundos (predefinição: 2). As definições também controlam o número na barra de menus e o registo em segundo plano.
- É mantida até uma hora de histórico na memória durante a sessão. Suspensão, pausas e dados em falta deixam lacunas.

[Notas da versão](../../docs/releases/1.3.0/pt-PT.md)

## Comentários

Ainda experimental, testado em alguns Macs Intel. Não se garante compatibilidade com todas as configurações de hardware e macOS. Comunique problemas no GitHub com o modelo do Mac, as versões do macOS e da aplicação e o erro completo ou uma captura de ecrã. Também agradecemos relatos de compatibilidade bem-sucedida.

[Comunicar um problema](https://github.com/nicotech-studio/turbo-killer/issues/new?template=report.pt-PT.yml)

## Para programadores

A aplicação SwiftUI da barra de menus comunica por XPC com um serviço privilegiado que carrega ou descarrega a extensão antiga do kernel incluída. O estado reflete o carregamento da extensão, sem medir a frequência da CPU. Abra TurboKiller.xcodeproj no Xcode para compilar. Mantenha o pacote histórico da extensão inalterado.

[SHA-256](../../LegacyKextIntegrity.swift)

## Apoiar

O TurboKiller é gratuito e de código aberto. Se lhe for útil, pode oferecer-me um café.

[Ofereça-me um café](https://ko-fi.com/hello_nico_chan)

## Licença

[GPL-2.0](../../LICENSE) · [Avisos de terceiros](../../THIRD_PARTY_NOTICES.md)
