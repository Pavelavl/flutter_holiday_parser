import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:parser/common/fetch_http.dart';
import 'package:parser/read_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State {
  bool _darkTheme = false;
  List _daysList = [];

  @override
  void initState() {
    super.initState();
    _setTheme();
  }

  _setTheme() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_prefs.getBool('darkTheme') != null) {
        _darkTheme = _prefs.getBool('darkTheme')!;
      } else {
        _darkTheme = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: !_darkTheme ? ThemeData.light() : ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Parser"),
          actions: [
            Icon(_getAppBarIcon()),
            Switch(
              value: _darkTheme,
              onChanged: (bool value) {
                setState(() {
                  _darkTheme = !_darkTheme;
                  _saveTheme();
                });
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: _getHttp(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
                  scrollDirection: Axis.vertical,
                  itemCount: _daysList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: FlatButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReadScreen(
                                      urlPost: '${_daysList[index].guid}',
                                    ))),
                        child: Container(
                          padding:
                              const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                          child: Column(children: [
                            Text(
                              '${_daysList[index].title}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Text(
                                "${parseDescription(_daysList[index].description)}"),
                          ]),
                        ),
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
      return Icons.wb_sunny_outlined;
    } else {
      return Icons.wb_sunny_rounded;
    }
  }

  _getHttp() async {
    _daysList = [];
    var response =
        await fetchHttp('https://www.calend.ru/img/export/today-holidays.rss');
    var channel = RssFeed.parse(response.body);
    channel.items?.forEach((element) {
      _daysList.add(element);
    });

    return _daysList;
  }

  _saveTheme() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setBool('darkTheme', _darkTheme);
  }
}
