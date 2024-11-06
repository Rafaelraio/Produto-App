import 'package:flutter/material.dart';
import 'package:produto_app/HTTP/produto.dart';
import 'package:intl/intl.dart';
import 'package:produto_app/produto-detalhes.dart';
import 'package:produto_app/produto.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/produto-novo': (context) => ProdutoNovo(),
        '/produto-datalhes': (context) {
          final produtoId =
              ModalRoute.of(context)!.settings.arguments as String;
          return ProdutoDetalhes(produtoId: produtoId);
        },
      },
      title: 'Produto App',
      theme: ThemeData(),
      home: const MyHomePage(title: 'Lista de Produtos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<dynamic>> _produtosFuture;

  @override
  void initState() {
    super.initState();
    _produtosFuture = listProdutos(); // Carregar os produtos ao iniciar
  }

  void _recarregarProdutos() async {
    setState(() {
      _produtosFuture = listProdutos(); // Recarregar os produtos
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _recarregarProdutos();
              },
            ),
          ]),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: FutureBuilder<List<dynamic>>(
            future: _produtosFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Erro ao listar os produtos: ${snapshot.error}');
              } else if (snapshot.hasData) {
                var produtos = snapshot.data!;
                return ListView.builder(
                  itemCount: produtos.length,
                  itemBuilder: (context, index) {
                    var produto = produtos[index];
                    return ListTile(
                      onTap: () async {
                        await Navigator.pushNamed(
                          context,
                          '/produto-datalhes',
                          arguments: produto['id'].toString(),
                        );
                        _recarregarProdutos();
                      },
                      title: Text('Id: ${produto['id'].toString()}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Descrição :${produto['descricao'].toString()}'),
                          Text('Preço: ${produto['preco'].toString()}'),
                          Text('Estoque: ${produto['estoque'].toString()}'),
                          Text(
                              'Data: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(produto['data'].toString()))}')
                        ],
                      ),
                    );
                  },
                );
              } else {
                return const Text('Nenhum produto encontrado');
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/produto-novo').then((_) {
            _recarregarProdutos();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
