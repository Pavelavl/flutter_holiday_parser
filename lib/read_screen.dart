import 'package:flutter/material.dart';
import 'package:parser/common/fetch_http.dart';
import 'package:parser/model/day_model.dart';
import 'package:html/parser.dart';

class ReadScreen extends StatefulWidget {
  final urlPost;

  const ReadScreen({@required this.urlPost});

  @override
  _ReadScreenState createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  var _dayModel = Day(body: '', dayUrl: '', title: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Parser'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _getDay());
  }

  _getDay() {
    return FutureBuilder(
        future: _getHttpDay(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              children: [
                Text(
                  '${_dayModel.title}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_dayModel.body}',
                  style: const TextStyle(fontSize: 18),
                )
              ],
            );
          }
        });
  }

  _getHttpDay() async {
    var response = await fetchHttp(widget.urlPost);
    var _day = parse(response.body);
    _dayModel.title = _day.getElementsByTagName('h1')[0].text;
    _dayModel.body =
        _day.getElementsByClassName('maintext')[0].children[0].text +
            ' ' * 99 +
            _day.getElementsByClassName('maintext')[0].children[1].text +
            ' ' * 99 +
            _day.getElementsByClassName('maintext')[0].children[2].text +
            ' ' * 99 +
            _day.getElementsByClassName('maintext')[0].children[5].text;
    _dayModel.dayUrl = widget.urlPost;

    return _dayModel;
  }
}
