import 'package:flutter/material.dart';

import 'package:news_page/domain/models/news.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:news_page/presentation/widgets/tags_widgets.dart';

class NewsCard extends StatelessWidget {
  final News_model news;
  const NewsCard({required this.news, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff181A20),
        body: Stack(children: [
          CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.6,
              viewportFraction: 1.0,
            ),
            items: news.images
                .map((item) => Container(
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl: item.url,
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
                      ),
                    ))
                .toList(),
          ),
          DraggableScrollableSheet(
              initialChildSize: 0.45,
              minChildSize: 0.45,
              maxChildSize: 1,
              expand: true,
              builder: (context, ScrollController controller) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(
                                24) //                 <--- border radius here
                            ),
                        color: Color(0xff181A20)),
                    child: ListView(
                        controller: controller,
                        padding: EdgeInsets.zero,
                        children: [
                          Align(
                            child: Padding(
                                padding: EdgeInsets.only(
                                    right: 24, left: 24, top: 16),
                                child: Column(children: [
                                  Text(news.title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(top: 24),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                child: TagsWidget(
                                                    news.tags, false, true)),
                                            Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  SvgPicture.asset(
                                                      "assets/calendar.svg",
                                                      height: 50),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8, top: 4),
                                                      child: Column(
                                                        children: [
                                                          Text("Дата",
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF5E6272),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              )),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(top: 4),
                                                              child: Text(
                                                                  DateFormat
                                                                          .MMMd()
                                                                      .format(news
                                                                          .date)
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFFC25FFF),
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ))),
                                                        ],
                                                      ))
                                                ])
                                          ])),
                                  Padding(
                                      padding:
                                          EdgeInsets.only(top: 16, bottom: 16),
                                      child: Text(news.text,
                                          style: TextStyle(
                                            color: Color(0xFF5E6272),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          )))
                                ])),
                          ),
                        ]));
              })
        ]));
  }
}
