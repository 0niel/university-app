class News_modal {
  String? title;
  String? author;
  String? description;
  String? urlToImage;
  String? publshedAt;
  String? content;
  String? articleUrl;

  News_modal(
      {required this.title,
      required this.description,
      required this.author,
      required this.content,
      required this.publshedAt,
      required this.urlToImage,
      required this.articleUrl});

  factory News_modal.from_json(Map<String, dynamic> json) {
    return News_modal(
      title: json['title'],
      author: json['author'],
      description: json['description'],
      urlToImage: json['urlToImage'],
      publshedAt: json['publishedAt'],
      content: json["content"],
      articleUrl: json["url"],
    );
  }
}
