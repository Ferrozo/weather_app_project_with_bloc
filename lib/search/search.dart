import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage._();

  static Route<String> route() {
    return MaterialPageRoute(builder: (_) => const SearchPage._());
  }

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _textController = TextEditingController();
  String get _text => _textController.text;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[800],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10, right: 15, left: 15),
        height: 58,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500],
                      ),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500],
                      ),
                      // labelText: 'City name',
                      hintText: 'City name',
                      border: InputBorder.none),
                ),
              ),
            ),
            IconButton(
              key: const Key('searchPage_search_iconButton'),
              onPressed: () => Navigator.of(context).pop(_text),
              icon: Icon(Icons.search, color: Colors.grey[500]),
            )
          ],
        ),
      ),
    );
  }
}
