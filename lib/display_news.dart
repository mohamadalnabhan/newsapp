import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'news_articles.dart';

class DisplayNews extends StatefulWidget {
  const DisplayNews({super.key});

  @override
  State<DisplayNews> createState() => _DisplayNewsState();
}

class _DisplayNewsState extends State<DisplayNews> {

  String category = "general";
  bool isDarkmodde = false; 

  TextEditingController _searchController = TextEditingController(); 

  List<NewsArticles> _allArticles = []; 
  List<NewsArticles> _filteredArticles = []; 

  @override
  void initState() {
    super.initState();
    _fetchNews(category); 
  }

 
  void _fetchNews(String category) async {
    final fetchedNews = await NewsService().fetchNews(category); 
    setState(() {
      _allArticles = fetchedNews; 
      _filteredArticles = fetchedNews; 
    });
  }

 
  void _updateCategory(String newCategory) {
    setState(() {
      category = newCategory;
      _fetchNews(category); // 
    });
  }
  void _filterNews(String query) {
    setState(() {
      _filteredArticles = _allArticles
          .where((article) =>
              article.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkmodde ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: SizedBox(
            height: 40,
            width: 250,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController, 
                    decoration: InputDecoration(
                      fillColor: Colors.white12,
                      filled: true,
                      hintText: "Search here",
                      hintStyle: TextStyle(color: Colors.white54),
                      contentPadding: EdgeInsets.all(8), 
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none, 
                      ),
                    ),
                    onChanged: _filterNews, 
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Color(0xFF363737),
          actions: [
            Switch(
              value: isDarkmodde,
              onChanged: (value) {
                setState(() {
                  isDarkmodde = value;
                });
              },
              activeColor: Colors.cyan,
            )
          ],
        ),
        body: Center(
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ["general", "business", "technology", "sports"]
                      .map((c) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ElevatedButton(
                              onPressed: () {
                                _updateCategory(c);
                              },
                              child: Text(
                                c.toUpperCase(),
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
              Expanded(
                child: _filteredArticles.isEmpty 
                    ? Center(child: Text("No articles found")) 
                    : ListView.builder(
                        itemCount: _filteredArticles.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_filteredArticles[index].title),
                            subtitle: Text(_filteredArticles[index].description),
                            leading: Image.network(
                              _filteredArticles[index].urlImg,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover, 
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class NewsService {
  final Dio dio = Dio();
  final String apiKey = "4570aad8d7fc4d26b3996cab25c586e6";

  Future<List<NewsArticles>> fetchNews(String category) async {
    try {
      Response response = await dio.get(
        "https://newsapi.org/v2/top-headlines",
        queryParameters: {"country": "us", "category": category, "apiKey": apiKey},
      );

      List articles = response.data['articles'];
      return articles.map((json) => NewsArticles.fromJson(json)).toList();
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
}


