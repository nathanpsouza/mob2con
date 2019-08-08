# Mob2con teste

## Como instalar o projeto

Primeiramente, é necessário ter o [docker](https://www.docker.com/) e o [docker-compose](https://docs.docker.com/compose/install/) instalados em sua máquina.

Após isso, clone o reposiório e acesse o diretório raiz do projeto clonado, faça o build da imagem da aplicação:

```
  $docker-compose build app
```

Para executar as migrations e criar o usuário de testes, rode no terminal:

```
  $docker-compose run --rm app rails db:create db:migrate db:seed
```

Com isto, a aplicação está pronta para ser executata.

## Rodando a suíte de testes

Para executar os testes, rode no console:

```
  $docker-compose run --rm app rspec spec
```

## Rodando a aplicação

Para subir a aplicação na porta 3000, execute:

```
  $docker-compose up app
```

O acesso é feito através do endereço http://localhost:3000

## Testando a aplicação

### **Antes de inciar as requisições**
**É necessário se atentar ao fato de que o header Content-Type deve ser fornecido em todas as chamadas**
```
Content-Type: application/json
```

### Conseguindo um token para acessar a lista privada

Após subir a aplicação, é necessário efetuar login para conseguir um token válido para acessar a lista de conversões privada.

Faça um POST para /login com o seguinte json no corpo do post (a conta t@t.com já foi criada durante o passo "Como instalar o projeto"):

```
  {
    "auth": {
      "email": "t@t.com",
      "password": "123123"
    }
  }
```

O token será retornado no seguinte formato:

```
  {
    "jwt": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1NjUzODA1NjUsInN1YiI6MX0.Y_TaCK1GMtyb5_Z-7zQY0OBM7d0l_Xiljtl7vJ44p5w"
  }
```

### Acessando a lista pública de conversões

Para listar todos as conversões públicas, faça uma requisição GET para /convertions/public. Não há necessidade de parametros adicionais.

O retorno será no formato abaixo:

```
  [
    {
      "id": 1,
      "currency_from": "EUR",
      "currency_to": "BRL",
      "rate": "4.387",
      "convertion_type": "public_convertion",
      "created_at": "2019-08-08T19:45:14.713Z",
      "updated_at": "2019-08-08T19:45:14.713Z"
    },
    {
      "id": 2,
      "currency_from": "EUR",
      "currency_to": "USD",
      "rate": "1.119",
      "convertion_type": "public_convertion",
      "created_at": "2019-08-08T19:59:21.608Z",
      "updated_at": "2019-08-08T19:59:21.608Z"
    }
  ]
```

### Cadastrando uma convertion pública

Para cadastrar uma conversão, é preciso enviar um POST para /convertions/public, com o seguinte conteudo no corpo do post:

```
  {
    "currency": "USD"	
  }
```

No exemplo, foi solicitado a conversão de EUR para USD. É possível pedir a conversão de mais de uma moeda por vez, fornecendo elas separadas por vírgula: 

```
  {
    "currency": "USD,BRL,CAD"	
  }
```

IMPORTANTE: em caso de uma moeda inválida, o sistema ignorará ela, salvando as conversões válidas. Se nenhuma moeda for fornecida, um erro será retornado.

### Acessando a lista privada de conversões

Para listar todos as conversões privadas, faça uma requisição GET para /convertions/public. Não há necessidade de parametros adicionais. **O header Authorization deve ser passado na requisiçao**:

```
  Authorization: Bearer <TOKEN RESGATADO DURANTE O LOGIN>
```

O retorno será no formato abaixo:

```
  [
    {
      "id": 1,
      "currency_from": "EUR",
      "currency_to": "BRL",
      "rate": "4.387",
      "convertion_type": "public_convertion",
      "created_at": "2019-08-08T19:45:14.713Z",
      "updated_at": "2019-08-08T19:45:14.713Z"
    },
    {
      "id": 2,
      "currency_from": "EUR",
      "currency_to": "USD",
      "rate": "1.119",
      "convertion_type": "public_convertion",
      "created_at": "2019-08-08T19:59:21.608Z",
      "updated_at": "2019-08-08T19:59:21.608Z"
    }
  ]
```

### Cadastrando uma convertion privada

Para cadastrar uma conversão, é preciso enviar um POST para /convertions/public, com o seguinte conteudo no corpo do post:

```
  {
    "currency": "USD"	
  }
```

**O header Authorization deve ser passado na requisiçao**:

```
  Authorization: Bearer <TOKEN RESGATADO DURANTE O LOGIN>
```

No exemplo, foi solicitado a conversão de EUR para USD. É possível pedir a conversão de mais de uma moeda por vez, fornecendo elas separadas por vírgula: 

```
  {
    "currency": "USD,BRL,CAD"	
  }
```

IMPORTANTE: em caso de uma moeda inválida, o sistema ignorará ela, salvando as conversões válidas. Se nenhuma moeda for fornecida, um erro será retornado.

## Considerações Finais
Optei por utilizar o campo padrão do rails `created_at` ao invés de utilizar o `added_at `.

O arquivo `env` contém as configurações de banco de dados, chave para acesso ao fixer e a currency padrão, no caso EUR.

Como a aplicação está dockerizada, para enviá-la para produção em resumo, deve-se:

* buildar a imagem e publicá-la em um registry
* criar um pacote helm com a descrição do deploy
* instalar a aplicação no cluster através do helm

O helm é responsável por expor o serviço e configurar os pods no cluster.

Também é necessário um serviço de postgres (CloudSQL na gcloud ou RDS na aws). Pode-se utilizar um serviço rodando no próprio cluster com persistent volume, mas não é recomendado.
