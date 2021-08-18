import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_page/domain/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:news_page/domain/usecases/news_usecase.dart';
import 'package:news_page/presentation/bloc/news_bloc.dart';
import 'package:news_page/presentation/bloc/news_bloc_event.dart';

class TagsWidget extends StatelessWidget {
  final List<Tag> tags;
  final bool isClick;
  final bool isPhoto;
  TagsWidget(this.tags, this.isClick, this.isPhoto);

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      isPhoto
          ? SvgPicture.asset("assets/tag.svg", height: 50)
          : SizedBox(width: 0, height: 0),
      isPhoto
          ? Padding(padding: EdgeInsets.only(left: 12))
          : SizedBox(width: 0, height: 0),
      Expanded(
          child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: tags
            .map((element) => (GestureDetector(
                  onTap: () {
                    if (isClick) {
                      NewsUsecase.tag = element.name;
                      BlocProvider.of<NewsBloc>(context).add(NewsInitital());
                    } else {}
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffA5F59C), width: 2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 8, right: 8, top: 4, bottom: 4),
                          child: Text(
                            element.name.toString(),
                            style: TextStyle(
                                color: Color(0xffA5F59C),
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ))),
                )))
            .toList(),
      ))
    ]);
  }
}
