import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:math';
import 'package:http/http.dart';

void main() {
  runApp(MaterialApp(
    home: Pokemon(),
    theme: ThemeData.dark(),
  ));
}

class Pokemon extends StatefulWidget {
  const Pokemon({Key? key}) : super(key: key);

  @override
  State<Pokemon> createState() => _PokemonState();
}

class _PokemonState extends State<Pokemon> {
  String nombre = "";
  String img = "";

  var data;

  fetchData(String url) async {
    Response res = await http.get(Uri.parse(url));
    data = convert.jsonDecode(res.body) as Map<String, dynamic>;
    nombre = data["name"];
    img = data["sprites"]["other"]["official-artwork"]["front_default"];
    print(data["sprites"]["other"]["official-artwork"]["front_default"]);
    setState(() {});
  }

  cargarImgs() {
    data = null;
    setState(() {});
    int randNum = Random().nextInt(700);
    String url = "https://pokeapi.co/api/v2/pokemon/${randNum}/";
    print(url);

    fetchData(url);
  }

  @override
  void initState() {
    super.initState();
    cargarImgs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Pokemon"))),
      body: data == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    nombre,
                    style: TextStyle(fontSize: 38),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 200,
                  child: Image.network(
                    img,
                    fit: BoxFit.fill,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.fromLTRB(30, 1, 30, 1),
                    ),
                  ),
                  onPressed: () {
                    cargarImgs();
                  },
                  child: Text(
                    "Random",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),
    );
  }
}
