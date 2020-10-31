import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Consulta de CEP',
        home: Scaffold(
            appBar: AppBar(
              title: Text('Consulta de CEP'),
            ),
            body: CepWidget()));
  }
}

class CepWidget extends StatefulWidget {
  @override
  _CepWidgetState createState() => _CepWidgetState();
}

class _CepWidgetState extends State<CepWidget> {
  var _controller = TextEditingController(text: '');
  String _text = 'Insira um Cep';
  String _logradouro = '';
  String _bairro = '';
  String _localidade = '';
  String _uf = '';
  String _ddd = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        RaisedButton(
          onPressed: onButtonPressCep,
          child: const Text('Consultar', style: TextStyle(fontSize: 20)),
        ),
        Text('$_text'),
        TextField(
          controller: _controller,
        ),
        Text('$_logradouro'),
        Text('$_bairro'),
        Text('$_localidade'),
        Text('$_uf'),
        Text('$_ddd'),
      ]),
    );
  }

  onButtonPressCep() async {
    // Realizando Request
    String url = 'https://viacep.com.br/ws/${_controller.text}/json/';
    Response response = await get(url);
    // Capturando Response
    String content = response.body;
    if (response.statusCode == 200) {
      print('Response body : ${content}');
      try {
        final parsed = jsonDecode(content).cast<String, dynamic>();
        setState(() {
          _logradouro = parsed["logradouro"];
          _bairro = parsed["bairro"];
          _localidade = parsed["localidade"];
          _uf = parsed["uf"];
          _ddd = parsed["ddd"];
        });
      } catch (Ex) {
        print("Erro ao decodificar JSON : $Ex");
      }
    }
  }
}
