## flutter-phrases
Projeto flutter para TAC II de uma aplicação que recebe frases de uma API
Autor: Bruno Machado Ferreira

### Dependências e afins
- `Node`
- `Flutter SDK`
- `http`

### Uso
Para que a aplicação funcione de modo adequado, siga o seguintes passos:

1) Abra um terminal no diretório "API" e execute `node ./index.js` para iniciar o servidor backend
![Backend iniciado](https://imgur.com/2638P0b.png)

2) Abra outro terminal no diretório "lib", execute `flutter run` e escolha um navegador web para testar. Você também pode usar `flutter run -d chrome` para executar diretamente no Chrome.
![flutter run](https://imgur.com/MxlaNKF.png)
![flutter run chrome](https://imgur.com/iu6ixxo.png)

Caso a aplicação seja aberta enquanto a API não está rodando, ela entra em um estado de espera. É necessário atualizar a página para tentar reconectar com o servidor.

### Apresentação
Seguindo os passos anteriores, a aplicação deve abir normalmente e mostrará uma janela com uma frase aleatória, recebida da API, e botões para favoritar ou escolher outra frase aleatoriamente.
![tela inicial](https://i.imgur.com/tnSullH.png)

Abrindo a lista de favoritos, a aplicação mostra todas as frases favoritadas e dá a opção de remover qualquer uma da lista. Basta clicar no ícone de lixeira.
![Favoritos](https://i.imgur.com/BbJWKqW.png)