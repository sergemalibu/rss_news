import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:rss_news/models/model_hab.dart';

import 'package:rss_news/services/news_repository.dart';
import 'package:http/http.dart' as http;

class ReadScreen extends StatefulWidget {
  const ReadScreen({
    Key? key,
    required this.urlHab,
  }) : super(key: key);
  final String urlHab;

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  final _habModel = News();
  @override
  void initState() {
    setState(() {
      _getHttpNews();
    });
    super.initState();
  }

  final newsRepo = NewsRepository();
  // final _habModel = Hab();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _getHab(),
    );
  }

  _getHab() {
    return FutureBuilder(
      future: _getHttpNews(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 10.0, bottom: 40.0),
            children: [
              Text(
                '${_habModel.title}',
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                '${_habModel.body}',
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  _getHttpNews() async {
    var url = Uri.parse(widget.urlHab);
    var client = http.Client();
    var responce = await client.get(url);
    var newsParse = parse(responce.body);

    _habModel.title =
        newsParse.getElementsByClassName('tm-title tm-title_h1')[0].text;
    _habModel.body = newsParse
        .getElementsByClassName(
          'tm-article-body',
        )[0]
        .text;
    _habModel.url = widget.urlHab;

    return _habModel;
  }
}
