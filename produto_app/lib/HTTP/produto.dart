import 'dart:convert';
import 'package:http/http.dart' as http;

const api = "http://127.0.0.1:3000";

Future<List<dynamic>> listProdutos() async {
  final response = await http.get(Uri.parse('$api/produto'));

  if (response.statusCode == 200) {
    var lista = jsonDecode(response.body);
    print(lista);
    return lista;
  } else {
    throw Exception('Falha ao listar os produtos');
  }
}

Future<dynamic> inserirProduto(desc, preco, estoque, data) async {
  print(desc);
  print(preco);
  print(estoque);
  print(data);
  final response = await http.post(Uri.parse('$api/produto'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'descricao': '$desc',
        'preco': '$preco',
        'estoque': '$estoque',
        'data': '$data'
      }));
}

Future<dynamic> buscarProdutoPorId(id) async {
  print(id);
  final response = await http.get(Uri.parse('$api/produto/$id'));
  if (response.statusCode == 200) {
    var produto = jsonDecode(response.body);
    print("testezudo");
    print(produto);
    return produto;
  } else {
    throw Exception('Falha ao buscar s produto');
  }
}

Future<dynamic> atualizarProdutoPorId(id, desc, preco, estoque, data) async {
  print(id);
  final response = await http.put(Uri.parse('$api/produto/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'descricao': '$desc',
        'preco': '$preco',
        'estoque': '$estoque',
        'data': '$data'
      }));

  if (response.statusCode == 200) {
    var produto = jsonDecode(response.body);
    print("testezudo");
    print(produto);
    return produto;
  } else {
    throw Exception('Falha ao buscar s produto');
  }
}

Future<dynamic> deletarProdutoPorId(id) async {
  print(id);
  final response = await http.delete(Uri.parse('$api/produto/$id'));
  if (response.statusCode == 200) {
    var produto = jsonDecode(response.body);
    print("testezudo");
    print(produto);
    return produto;
  } else {
    throw Exception('Falha ao buscar s produto');
  }
}
