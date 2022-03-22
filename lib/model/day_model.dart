class Day {
  String title;
  String dayUrl;
  String body;

  Day({required this.title, required this.dayUrl, required this.body});

  Map<String, dynamic> toJson() => {
        'title': title,
        'dayUrl': dayUrl,
        'body': body,
      };

  Day.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        dayUrl = json['dayUrl'],
        body = json['body'];
}
