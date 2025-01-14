import 'package:flutter/material.dart';
import 'package:produto_app/HTTP/produto.dart';

class ProdutoDetalhes extends StatefulWidget {
  final String produtoId;

  const ProdutoDetalhes({Key? key, required this.produtoId}) : super(key: key);

  @override
  State<ProdutoDetalhes> createState() => _ProdutoDetalhesState();
}

class _ProdutoDetalhesState extends State<ProdutoDetalhes> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController estoqueController = TextEditingController();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController precoController = TextEditingController();

  void _mostrarErro(BuildContext context, String mensagem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text(mensagem),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _mostrarConfirmar(BuildContext context, String mensagem) async {
    bool option = (await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmação'),
              content: Text(mensagem),
              actions: [
                TextButton(
                  child: const Text('Não '),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Sim'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        )) ??
        false;
    return option;
  }

  @override
  void initState() {
    super.initState();
    _carregarDetalhesProduto(
        widget.produtoId); // Carrega os detalhes usando o ID passado
  }

  Future<void> _carregarDetalhesProduto(String id) async {
    final produto = await buscarProdutoPorId(widget.produtoId);
    setState(() {
      descController.text = produto['descricao'];
      estoqueController.text = produto['estoque'].toString();
      precoController.text = produto['preco'].toString();
      DateTime data = DateTime.parse(produto['data']);
      dataController.text = "${data.year}-${data.month}-${data.day}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Detalhes Produto ${widget.produtoId}"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  const Text("Desc: "),
                  Expanded(
                      child: TextField(
                    readOnly: true,
                    controller: descController,
                  ))
                ],
              ),
              Row(
                children: [
                  const Text("Preço: "),
                  Expanded(
                      child: TextField(
                    readOnly: true,
                    controller: precoController,
                    keyboardType: TextInputType.number,
                  ))
                ],
              ),
              Row(
                children: [
                  const Text("Estoque: "),
                  Expanded(
                      child: TextField(
                    readOnly: true,
                    controller: estoqueController,
                    keyboardType: TextInputType.number,
                  ))
                ],
              ),
              Row(
                children: [
                  const Text("Data:"),
                  Expanded(
                      child: TextField(
                    controller: dataController,
                    readOnly: true,
                  ))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        bool x = await _mostrarConfirmar(context, "Deletar?");
                        if (x == true) {
                          nomeController.clear();
                          descController.clear();
                          estoqueController.clear();
                          dataController.clear();
                          deletarProdutoPorId(widget.produtoId);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("deletar")),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await Navigator.pushNamed(
                          context,
                          '/produto-editar',
                          arguments: widget.produtoId,
                        ).then((_) {
                          _carregarDetalhesProduto(widget.produtoId);
                        });
                      },
                      child: const Text("Editar"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
