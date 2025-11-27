# Marketplace - Funcionalidades Implementadas

## 📦 Novo Sistema de Marketplace Local

O aplicativo agora inclui um marketplace completo para que moradores de João Pessoa possam vender seus produtos localmente.

## 🎯 Funcionalidades

### ✅ Autenticação e Registro
- **Login**: Autenticação de usuários existentes
- **Cadastro**: Registro de novos usuários
- **Tipo de Conta**: Durante o cadastro, usuários podem se registrar como vendedores
- **Sessão Persistente**: Usuário permanece logado após fechar o app

### ✅ Marketplace de Produtos
- **Listagem de Produtos**: Visualização de todos os produtos disponíveis
- **Busca**: Busca por nome, descrição ou categoria
- **Filtros por Categoria**: 
  - Artesanato
  - Comida
  - Souvenirs
  - Roupas
  - Acessórios
  - Outros
- **Detalhes do Produto**: Informações completas incluindo preço, descrição, estoque e localização

### ✅ Painel do Vendedor
- **Dashboard**: Área exclusiva para vendedores
- **Gerenciamento de Produtos**: 
  - Adicionar novos produtos
  - Visualizar todos os produtos do vendedor
  - Excluir produtos
  - Visualizar estatísticas (estoque, disponibilidade)

### ✅ Banco de Dados Local (SQLite)
- **Armazenamento Local**: Todos os dados são salvos localmente no dispositivo
- **Tabelas**:
  - `users`: Usuários e vendedores
  - `products`: Produtos do marketplace
- **Relacionamentos**: Produtos vinculados aos vendedores

## 📱 Telas Implementadas

1. **Login Screen** (`lib/screens/login_screen.dart`)
   - Login com email e senha
   - Link para cadastro

2. **Register Screen** (`lib/screens/register_screen.dart`)
   - Formulário completo de cadastro
   - Opção para se registrar como vendedor
   - Validação de campos

3. **Marketplace Screen** (`lib/screens/marketplace_screen.dart`)
   - Grid de produtos
   - Barra de busca
   - Filtros por categoria
   - Acesso rápido para vendedores

4. **Product Detail Screen** (`lib/screens/product_detail_screen.dart`)
   - Detalhes completos do produto
   - Informações do vendedor
   - Opções de edição (para o dono do produto)

5. **Add Product Screen** (`lib/screens/add_product_screen.dart`)
   - Formulário para adicionar produtos
   - Seleção de categoria
   - Campos para preço, estoque, localização

6. **Seller Dashboard Screen** (`lib/screens/seller_dashboard_screen.dart`)
   - Lista de produtos do vendedor
   - Ações rápidas (editar, excluir)
   - Acesso para adicionar novos produtos

## 🔧 Serviços Criados

1. **DatabaseService** (`lib/services/database_service.dart`)
   - Gerenciamento do banco SQLite
   - CRUD para usuários e produtos
   - Migrações e índices

2. **AuthService** (`lib/services/auth_service.dart`)
   - Registro de usuários
   - Autenticação (login)
   - Gerenciamento de perfil

3. **MarketplaceService** (`lib/services/marketplace_service.dart`)
   - CRUD de produtos
   - Busca de produtos
   - Filtros e categorias

## 📊 Modelos de Dados

1. **User** (`lib/models/user.dart`)
   - Informações do usuário
   - Flag para identificar vendedores
   - Métodos de serialização JSON

2. **Product** (`lib/models/product.dart`)
   - Informações do produto
   - Vinculação com vendedor
   - Localização em João Pessoa

## 🚀 Como Usar

### Para Usuários Normais:
1. Faça login ou cadastre-se
2. Navegue até a aba "Marketplace"
3. Explore produtos, busque e filtre
4. Visualize detalhes dos produtos

### Para Vendedores:
1. Cadastre-se selecionando "Sou vendedor"
2. Faça login
3. Acesse o ícone de dashboard no Marketplace
4. Adicione produtos usando o botão "+"
5. Gerencie seus produtos no dashboard

## 🔐 Segurança

⚠️ **Nota Importante**: 
- As senhas estão sendo armazenadas em texto plano (apenas para desenvolvimento)
- **Em produção, implemente**:
  - Hash de senhas (bcrypt)
  - Autenticação JWT ou similar
  - Validação de email
  - Recuperação de senha

## 📝 Próximas Melhorias Sugeridas

- [ ] Upload de imagens de produtos
- [ ] Sistema de avaliações de produtos
- [ ] Chat entre comprador e vendedor
- [ ] Sistema de pedidos
- [ ] Notificações push
- [ ] Integração com pagamentos
- [ ] Geolocalização para mostrar produtos próximos
- [ ] Favoritos
- [ ] Histórico de compras

## 🗄️ Estrutura do Banco de Dados

### Tabela: users
- id (TEXT PRIMARY KEY)
- name (TEXT)
- email (TEXT UNIQUE)
- password (TEXT)
- phone (TEXT)
- address (TEXT)
- isSeller (INTEGER)
- createdAt (TEXT)
- updatedAt (TEXT)

### Tabela: products
- id (TEXT PRIMARY KEY)
- sellerId (TEXT FOREIGN KEY)
- name (TEXT)
- description (TEXT)
- price (REAL)
- category (TEXT)
- images (TEXT) - JSON array serializado
- stock (INTEGER)
- isAvailable (INTEGER)
- location (TEXT)
- latitude (REAL)
- longitude (REAL)
- createdAt (TEXT)
- updatedAt (TEXT)



