import 'dart:math';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teste',
      home: RandomWords(),
      theme: ThemeData(
        primaryColor: Colors.white,
        textTheme: TextTheme(title: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold))
      ),
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _saved = Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestion(),
    );
  }

  void _pushSaved(){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context){
          final Iterable<ListTile> tiles = _saved.map(
              (pair){
                return ListTile(
                  title: Text(pair.asPascalCase, style: _biggerFont),
                );
              }
          );
          final List<Widget> divided = ListTile.divideTiles(tiles: tiles, context: context).toList();

          return Scaffold(
            appBar: AppBar(
                title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided,)
          );
        }
      )
    );
  }

  _buildSuggestion() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_suggestions[index]);
      },
    );
  }

  _buildRow(WordPair par) {
    final alreadySaved = _saved.contains(par);
    return ListTile(
      title: Text(
          par.asPascalCase,
          style: _biggerFont
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if(alreadySaved){
            _saved.remove(par); 
          }else{
            _saved.add(par);
          }            
        });
      },
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RandomWordsState();
}
