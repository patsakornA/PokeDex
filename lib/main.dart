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
      title: 'PokeDex',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: PokedexPage(),
    );
  }
}

class PokedexPage extends StatefulWidget {
  @override
  _PokedexPageState createState() => _PokedexPageState();
}

class _PokedexPageState extends State<PokedexPage> {
  List<dynamic> _pokemonList = [];

  Future<void> _fetchPokemonData() async {
    final response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151'));
    final decodedData = json.decode(response.body);
    setState(() {
      _pokemonList = decodedData['results'];
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchPokemonData();
  }

  Future<void> _showPokemonDetailDialog(
      dynamic pokemonData, Color color) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // Allow user to dismiss the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: color,
          title: Text(
            pokemonData['name'],
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Image.network(
                  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemonData['id']}.png',
                  height: 200,
                ),
                SizedBox(height: 20),
                Text(
                  'Name: ${pokemonData['name']}',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  'Height: ${pokemonData['height']}',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                Text(
                  'Weight: ${pokemonData['weight']}',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  'Stats:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                // Display stats
                ..._buildStats(pokemonData['stats']),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'PokeDex',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8),
            Icon(Icons.pets), // Adding a Pokémon icon
          ],
        ),
        backgroundColor: const Color.fromARGB(
            255, 26, 221, 39), // Set background color of AppBar
      ),
      body: ListView.builder(
        itemCount: _pokemonList.length,
        itemBuilder: (context, index) {
          final pokemon = _pokemonList[index];
          return ListTile(
            leading: Image.network(
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${index + 1}.png',
              width: 50,
              height: 50,
            ),
            title: Text(pokemon['name']),
            onTap: () async {
              final pokemonResponse = await http.get(Uri.parse(pokemon['url']));
              final pokemonData = json.decode(pokemonResponse.body);
              Color backgroundColor =
                  _getColorFromType(pokemonData['types'][0]['type']['name']);
              _showPokemonDetailDialog(pokemonData, backgroundColor);
            },
          );
        },
      ),
    );
  }

  List<Widget> _buildStats(List<dynamic> stats) {
    List<Widget> statWidgets = [];
    for (var stat in stats) {
      statWidgets.add(
        Text(
          '${stat['stat']['name']}: ${stat['base_stat']}',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      );
    }
    return statWidgets;
  }

  Color _getColorFromType(String type) {
    switch (type) {
      case 'normal':
        return Colors.brown;
      case 'fire':
        return Colors.red;
      case 'water':
        return Colors.blue;
      case 'grass':
        return Colors.green;
      case 'electric':
        return Colors.amber;
      case 'ice':
        return Colors.lightBlue;
      case 'fighting':
        return Colors.orange;
      case 'poison':
        return Colors.purple;
      case 'ground':
        return Colors.orangeAccent;
      case 'flying':
        return Colors.indigo;
      case 'psychic':
        return Colors.pink;
      case 'bug':
        return Colors.lime;
      case 'rock':
        return Colors.grey;
      case 'ghost':
        return Colors.indigoAccent;
      case 'dark':
        return Colors.brown;
      case 'dragon':
        return Colors.deepPurple;
      case 'steel':
        return Colors.blueGrey;
      case 'fairy':
        return Colors.pinkAccent;
      default:
        return Colors.grey;
    }
  }
}
