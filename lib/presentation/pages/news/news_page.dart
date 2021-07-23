//Cтраница отоброжения новостей

import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/data/news_helper/data_tags.dart';
import 'package:rtu_mirea_app/presentation/pages/news/widget_NewsTile.dart';
import 'package:rtu_mirea_app/data/models/news_categorie_model.dart';
import 'package:rtu_mirea_app/data/news_helper/news_parse.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rtu_mirea_app/presentation/pages/news/widget_CategoryCard.dart';

class SettingsNews extends StatelessWidget {
  static const String routeName = '/news';
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        child: SafeArea(
          child: Container(
            child: Column(
              children: [],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  static const String routeName = '/news';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool _loading;
  var newslist;

  List<CategorieModel> categories = [];

  void getNews() async {
    News news = News();
    await news.parse();

    newslist = news.list_news;
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loading = true;
    categories = getCategories();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
            child: Container(
              color: LightThemeColors.grey100,
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(1.0)),
        title: Text(
          'Новости',
          style: Theme.of(context).textTheme.headline6,
        ),
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: SvgPicture.asset('assets/icons/menu.svg'),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      /// Categories
                      /// Tags
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 32),
                        height: 40,
                        width: 500,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return CategoryCard(
                                imageAssetUrl: categories[index].imageAssetUrl,
                                categoryName: categories[index].categorieName,
                              );
                            }),
                      ),

                      /// News Article
                      Container(
                        margin: EdgeInsets.all(8.0),
                        child: ListView.builder(
                            itemCount: newslist.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return NewsTile(
                                imgUrl: newslist[index].urlToImage ?? "",
                                title: newslist[index].title ?? "",
                                desc: newslist[index].description ?? "",
                                content: newslist[index].content ?? "",
                                posturl: newslist[index].articleUrl ?? "",
                                date: newslist[index].publshedAt ?? "",
                                tags: "tags",
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
