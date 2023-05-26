import 'package:flutter/material.dart';
import 'package:rss_news/pages/detail_news.dart';
import 'package:rss_news/services/news_repository.dart';
import 'package:webfeed/webfeed.dart';
import 'package:intl/intl.dart';

class HomeScreenRSS extends StatefulWidget {
  const HomeScreenRSS({Key? key}) : super(key: key);

  @override
  State<HomeScreenRSS> createState() => _HomeScreenRSSState();
}

class _HomeScreenRSSState extends State<HomeScreenRSS> {
  final newsRepo = NewsRepository();
  bool _darkTheme = false;
  final List _newsList = [];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: !_darkTheme ? ThemeData.light() : ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('RSS News'),
          actions: [
            Icon(_getAppBarIcon()),
            Switch(
                value: _darkTheme,
                onChanged: (bool value) {
                  setState(() {
                    _darkTheme = !_darkTheme;
                  });
                })
          ],
        ),
        body: FutureBuilder(
          future: _getHttpNews(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: _newsList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(children: [
                          Text(
                            '${_newsList[index].title}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            newsRepo.parseDescription(
                                '${_newsList[index].description}'),
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(DateFormat('dd.mm.yyyy : kk:mm').format(
                                  DateTime.parse(
                                      '${_newsList[index].pubDate}'))),
                              FloatingActionButton.extended(
                                heroTag: null,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ReadScreen(
                                                urlHab: _newsList[index].guid,
                                              )));
                                },
                                label: const Text('Подробнее...'),
                                icon: const Icon(Icons.arrow_forward),
                              )
                            ],
                          ),
                        ]),
                      ),
                    );
                  });
            }
          },
        ),
      ),
    );
  }

  _getAppBarIcon() {
    if (_darkTheme) {
      return Icons.highlight;
    } else {
      return Icons.lightbulb_outline;
    }
  }

  _getHttpNews() async {
    var url = Uri.parse('https://habr.com/ru/rss/hubs/all/');
    var responce = await newsRepo.fetchHttp(url);
    var chanel = RssFeed.parse(responce.body);
    chanel.items?.forEach((element) {
      _newsList.add(element);
    });
    return _newsList;
  }
}
