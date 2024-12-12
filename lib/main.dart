import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frases Aleatórias',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FraseScreen(),
    );
  }
}

class FraseScreen extends StatefulWidget {
  @override
  _FraseScreenState createState() => _FraseScreenState();
}

class _FraseScreenState extends State<FraseScreen> {
  String? fraseAtual;
  final apiUrl = 'http://localhost:3000'; //servidor local na porta 3000

  @override
  void initState() {
    super.initState();
    fetchFrase();
  }

  //escolhe uma frase na API
  Future<void> fetchFrase() async {
    final response = await http.get(Uri.parse('$apiUrl/frase'));
    if (response.statusCode == 200) {
      setState(() {
        fraseAtual = json.decode(response.body)['frase'];
      });
    }
  }

//favoritar frase
Future<void> favoritarFrase() async {
  if (fraseAtual != null) {
    try { //espera o post para atualizar a frase na tela
      final response = await http.post(
        Uri.parse('$apiUrl/favoritos'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'frase': fraseAtual}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // frase favoritada com sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Frase adicionada aos favoritos!'), duration: Duration(seconds: 1)),
        );
      } else if (response.statusCode == 400) {
        // frase já favoritada
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Frase já está nos favoritos!'), duration: Duration(seconds: 1)),
        );
      } else {
        // erros gerais
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao favoritar a frase: ${response.reasonPhrase}'), duration: Duration(seconds: 1)),
        );
      }
    } catch (e) {
      // erro de conexão(api fechou)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao se conectar com a API.'), duration: Duration(seconds: 1)),
      );
    }
  }
}


  Future<void> visualizarFavoritos(BuildContext context) async { //tela que mostra os favoritos
    final response = await http.get(Uri.parse('$apiUrl/favoritos'));
    if (response.statusCode == 200) {
      final favoritos = json.decode(response.body)['favoritos'];
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FavoritosScreen(favoritos: favoritos, apiUrl: apiUrl),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) { //estrutura do menu inicial
    return Scaffold(
      appBar: AppBar(title: Text('Exame TAC II - App Flutter para receber frases de API')),
      body: Center(
        child: fraseAtual == null
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    fraseAtual!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: favoritarFrase,
                        child: Text('Favoritar'),
                      ),
                      ElevatedButton(
                        onPressed: fetchFrase,
                        child: Text('Nova Frase'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => visualizarFavoritos(context),
                    child: Text('Ver Favoritos'),
                  ),
                ],
              ),
      ),
    );
  }
}

class FavoritosScreen extends StatelessWidget {
  final List favoritos;
  final String apiUrl;

  FavoritosScreen({required this.favoritos, required this.apiUrl});

  Future<void> desfavoritarFrase(String frase, BuildContext context) async {
    await http.delete(
      Uri.parse('$apiUrl/favoritos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'frase': frase}),
    );
    // atualiza a lista após desfavoritar
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritosScreen(
          favoritos: favoritos.where((f) => f != frase).toList(),
          apiUrl: apiUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) { //estrurura da tela de favoritos
    return Scaffold(
      appBar: AppBar(title: Text('Favoritos')),
      body: ListView.builder(
        itemCount: favoritos.length,
        itemBuilder: (context, index) {
          final frase = favoritos[index];
          return ListTile(
            title: Text(frase),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => desfavoritarFrase(frase, context),
            ),
          );
        },
      ),
    );
  }
}
