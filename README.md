# Smart Stock

<p>
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"/>
</p>

Aplicativo móvel desenvolvido em Flutter para conexão com a pistola RFID 🏷️<br>
Projetado para se conectar a uma pistola RFID via Bluetooth Low Energy (BLE) para otimizar a contagem e inventário de produtos.

## 🚀 Começando

Siga estas instruções para obter uma cópia do projeto em funcionamento na sua máquina local para desenvolvimento e testes.

### Pré-requisitos

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (versão 3.x ou superior)
- Um editor de código, como [VS Code](https://code.visualstudio.com/) ou [Android Studio](https://developer.android.com/studio)
- Um dispositivo ou emulador Android

### Instalação

1.  **Clone o repositório:**

    ```bash
    git clone {repositório do ssrfid-app}
    cd ssrfid-app
    ```

2.  **Instale as dependências:**

    ```bash
    flutter pub get
    ```

3.  **Configure as variáveis de ambiente:**
    Crie um arquivo `.env` na raiz do projeto, baseado no arquivo `.env.example`. Preencha com as informações necessárias.

4.  **Gere os arquivos de rota:**
    O projeto utiliza `auto_route` para navegação. Execute o seguinte comando para gerar os arquivos necessários:

    ```bash
    dart run build_runner build
    ```

5.  **Execute o aplicativo:**

    ```bash
    flutter run
    ```

## 📂 Estrutura do Projeto

O projeto segue uma arquitetura limpa, separando as responsabilidades em diferentes camadas:

```
lib/
├── app/
│   ├── bluetooth/      # Lógica de conexão Bluetooth e máquina de estados
│   ├── config/         # Configurações de API, dependências e variáveis de ambiente
│   ├── data/           # Repositórios e Data Transfer Objects (DTOs)
│   ├── domain/         # Entidades e abstrações de repositórios
│   ├── routing/        # Configuração de rotas (AutoRoute)
│   ├── ui/             # Widgets, páginas, providers (Riverpod) e temas
│   └── utils/          # Classes utilitárias (ex: logger)
└── main.dart           # Ponto de entrada da aplicação
```

## 🛠️ Tecnologias Utilizadas

- **Framework:** [Flutter](https://flutter.dev/)
- **Gerenciamento de Estado:** [Riverpod](https://riverpod.dev/)
- **Navegação:** [AutoRoute](https://pub.dev/packages/auto_route)
- **Comunicação Bluetooth:** [flutter_blue_plus](https://pub.dev/packages/flutter_blue_plus)
- **Requisições HTTP:** [http](https://pub.dev/packages/http)
- **Componentes de UI:** [forui](https://pub.dev/packages/forui)
- **Injeção de Dependência:** [get_it](https://pub.dev/packages/get_it)
- **Variáveis de Ambiente:** [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)
- **Logging:** [logger](https://pub.dev/packages/logger)

## 👀 OBS

- Para manter uma transição mais suave entre telas com o mesmo estilo de `AppBar`, optei por usar `AutoTabs` em vez de `Navigator.push()`, evitando o efeito padrão que troca toda a tela. Porém, como o `AutoTabs` simula a navegação, o botão nativo de voltar acaba fechando o app quando estamos em rotas internas. Resolvi isso usando `PopScope` e `SystemNavigator.pop()` no Android. No iOS, esse comportamento será diferente, pois o método não é suportado.
- Créditos do plano de fundo da tela inicial `stock.png`: https://www.pexels.com/photo/red-and-white-plastic-containers-on-shelf-3992851/ + https://pinetools.com/blur-image no filtro `Stack Blur` e radius 100 + https://imgonline.tools/pt/darken com 15 de fator de escurecimento.
- A troca do ícone da aplicação no IOS precisa de ajustes para ficar funcional.
