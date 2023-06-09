import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CatImagesScreen extends StatefulWidget {
  @override
  _CatImagesScreenState createState() => _CatImagesScreenState();
}

class _CatImagesScreenState extends State<CatImagesScreen> {
  TextEditingController _statusCodeController = TextEditingController();
  String? _catImageUrl;

  Future<String> fetchCatImageUrl(int statusCode) async {
    final response = await http.get(Uri.parse('https://http.cat/$statusCode'));
    if (response.statusCode == 200) {
      return 'https://http.cat/$statusCode';
    } else {
      throw Exception(
          'Falha ao buscar a imagem do gato para o código de status $statusCode');
    }
  }

  void _buscarImagemGato() {
    final codigoStatus = int.tryParse(_statusCodeController.text);
    if (codigoStatus != null) {
      fetchCatImageUrl(codigoStatus).then((url) {
        setState(() {
          _catImageUrl = url;
        });
      }).catchError((error) {
        setState(() {
          _catImageUrl = null;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API HTTP Cat'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _statusCodeController,
              decoration: InputDecoration(
                labelText: 'Código de Status',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _buscarImagemGato();
                  },
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          Expanded(
            child: Center(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  if (_catImageUrl != null) {
                    return Image.network(_catImageUrl!);
                  } else {
                    return Text('Nenhum dado disponível');
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
