import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:api_abel/utils/cor.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
    title: "Consulta de CEP",
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

final TextEditingController _cepCtrl = TextEditingController();
String resultado = "";

class _MyAppState extends State<MyApp> {
  _consultaCep() async {
    //Peguei o cep digitado
    String cep = _cepCtrl.text;

    //Criar variavel para a url da api
    String api = "https://viacep.com.br/ws/${cep}/json/";

    //Fazer Requisição com http
    http.Response response;

    //tive que converter minha String de api para uri
    final Uri url = Uri.parse(api);

    response = await http.get(url);

    Map<String, dynamic> retorno =
        json.decode(response.body); //vai decodificar o corpo do resultado

    //Criar Variável para tudo aquilo que quero mostrar
    String logradouro = retorno["logradouro"];
    String cidade = retorno["localidade"];
    String uf = retorno["uf"];
    String ddd = retorno["ddd"];

    setState(() {
      resultado = "${logradouro}, ${cidade}, ${uf}, ${ddd}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("82caaf"),
          hexStringToColor("75c0e0"),
          hexStringToColor("39a275")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        padding: EdgeInsets.all(40),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextField(
                style: TextStyle(
                    fontSize: 24, color: Colors.white.withOpacity(0.9)),
                cursorColor: Colors.white,
                controller: _cepCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Digite o CEP",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelStyle: TextStyle(
                      fontSize: 24, color: Colors.white.withOpacity(0.9)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none)),
                ),
              ),
              ElevatedButton(
                child: const Text("Consultar", style: TextStyle(fontSize: 24)),
                onPressed: _consultaCep,
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                  backgroundColor: MaterialStateProperty.all(Colors.green[500]),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              Text("Resultado: ${resultado}",
                  style: TextStyle(fontSize: 24, color: Colors.white))
            ]),
      ),
    );
  }
}
