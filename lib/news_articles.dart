class NewsArticles {
  final String title;
  final String description;
  final String urlImg;

  NewsArticles({required this.title, required this.description, required this.urlImg});

  factory NewsArticles.fromJson(Map<String, dynamic> json) {
    return NewsArticles(
      title: json['title'] ?? "No title",
      description: json['description'] ?? "No description",
      urlImg: json['urlToImage'] != null && json['urlToImage'] != ""
          ? json['urlToImage']
          : "https://via.placeholder.com/150", // Fallback image if null
    );
  }
}






