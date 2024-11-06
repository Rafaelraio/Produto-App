import 'package:flutter/material.dart';
import 'package:produto_app/HTTP/produto.dart';

class ProdutoNovo extends StatelessWidget {
  ProdutoNovo({super.key});

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
          title: Text('Erro'),
          content: Text(mensagem),
          actions: [
            TextButton(
              child: Text('OK'),
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
              title: Text('Confirmação'),
              content: Text(mensagem),
              actions: [
                TextButton(
                  child: Text('Não '),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text('Sim'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Novo Produto"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  Text("Desc: "),
                  Expanded(
                      child: TextField(
                    controller: descController,
                  ))
                ],
              ),
              Row(
                children: [
                  Text("Preço: "),
                  Expanded(
                      child: TextField(
                    controller: precoController,
                    keyboardType: TextInputType.number,
                  ))
                ],
              ),
              Row(
                children: [
                  Text("Estoque: "),
                  Expanded(
                      child: TextField(
                    controller: estoqueController,
                    keyboardType: TextInputType.number,
                  ))
                ],
              ),
              Row(
                children: [
                  Text("Data:"),
                  Expanded(
                      child: TextField(
                    controller: dataController,
                    readOnly: true,
                    onTap: () async {
                      DateTime? data = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          initialDate: DateTime.now());
                      if (data != null) {
                        String formattedDate =
                            "${data.year}-${data.month}-${data.day}";
                        dataController.text = formattedDate;
                      }
                    },
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
                      onPressed: () {
                        nomeController.clear();
                        descController.clear();
                        estoqueController.clear();
                        dataController.clear();
                        Navigator.pop(context);
                      },
                      child: Text("Cancelar")),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        String desc = descController.text;
                        String preco = precoController.text;
                        String estoque = estoqueController.text;
                        String data = dataController.text;

                        num? precoNum = num.tryParse(preco);
                        num? estoqueNum = int.tryParse(estoque);

                        if (desc == "" ||
                            preco == "" ||
                            estoque == "" ||
                            data == "") {
                          _mostrarErro(
                              context, "Nenhum campo deve estar vazio");
                        } else if (precoNum == null || estoqueNum == null) {
                          _mostrarErro(context,
                              "Preço e estoque devem ser numeros, sendo que estoque deve ser um numero inteiro");
                        } else {
                          bool x = await _mostrarConfirmar(context, "Inserir?");
                          if (x == true) {
                            print(desc);
                            print(preco);
                            print(desc);
                            print(estoque);
                            print(data);
                            inserirProduto(desc, preco, estoque, data);
                            nomeController.clear();
                            descController.clear();
                            precoController.clear();
                            estoqueController.clear();
                            dataController.clear();
                          }
                          Navigator.pop(context, true);
                        }
                      },
                      child: Text("Inserir"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
