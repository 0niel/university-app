import 'package:flutter/material.dart';
import 'package:news_page/domain/models/news.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_page/presentation/pages/news_detail_page.dart';
import 'package:news_page/presentation/widgets/tags_widgets.dart';

class NewsWidget extends StatelessWidget {
  final News_model news;

  NewsWidget(this.news);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsCard(news: news),
          ),
        );
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 24, left: 16, right: 16),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xff262A34),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: news.images[0].url,
                  height: 175,
                  width: MediaQuery.of(context).size.width,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      news.title,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: TagsWidget(news.tags, true, false)),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 8, right: 8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                            (DateFormat.yMMMd().format(news.date).toString()),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Color(0xFFC25FFF),
                                fontSize: 14,
                                fontWeight: FontWeight.w700)),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
