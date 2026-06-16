# AppTurismo - Paraíba

Aplicativo híbrido (mobile/web) em Flutter para turismo no estado da Paraíba, Brasil. Utiliza algoritmos de Machine Learning para sugerir lugares turísticos baseados nas preferências e avaliações dos usuários.

## Funcionalidades

- **Mapa Interativo**: Visualização de pontos turísticos no Google Maps.
- **Sugestões Inteligentes**: Recomendações personalizadas usando Machine Learning.
- **Sistema de Avaliação**: Usuários podem avaliar e comentar sobre os lugares.
- **Marketplace**: Funcionalidade de marketplace para compra e venda de produtos locais.
- **Passaporte Digital**: Um sistema de gamificação para incentivar o turismo.
- **Interface Responsiva**: Funciona em Android, iOS e Web.

## Início Rápido

1. **Configure o Ambiente**: Siga as instruções no arquivo `SETUP.md` para configurar o Flutter e as chaves de API necessárias.

2. **Execute o App**: Após a configuração, siga as instruções no `RUN_GUIDE.md` para iniciar o aplicativo no seu dispositivo ou na web.

## Estrutura do Projeto

```
lib/
├── config/       # Configurações (chaves de API, etc.)
├── models/       # Modelos de dados (Place, User, Product, etc.)
├── services/     # Lógica de negócio (ML, API, Storage)
├── providers/    # Gerenciamento de estado (Provider)
├── screens/      # Telas do aplicativo
└── main.dart     # Ponto de entrada
```

## Algoritmo de Recomendação (ML)

O sistema de recomendações utiliza um algoritmo híbrido que considera:

1. **Preferências do Usuário** (30 pontos): Categorias de interesse.
2. **Avaliação Média** (30 pontos): Rating geral do lugar.
3. **Popularidade** (20 pontos): Número de avaliações.
4. **Distância** (20 pontos): Proximidade do usuário.
5. **Diversidade**: Penaliza lugares já visitados pelo usuário.

## Tecnologias Utilizadas

- **Flutter**: Framework multiplataforma.
- **Google Maps**: Integração de mapas.
- **Provider**: Gerenciamento de estado.
- **Firebase**: Autenticação, banco de dados e armazenamento de arquivos.
- **JSON Serialization**: Serialização de dados para persistência local.

## Documentação Adicional

- **`SETUP.md`**: Instruções detalhadas para a configuração inicial do projeto.
- **`RUN_GUIDE.md`**: Guia passo-a-passo para executar o aplicativo.

## Licença

Este projeto é de código aberto.