import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/common/utils/utils.dart';
import 'package:rtu_mirea_app/domain/entities/strapi_media.dart';

import 'fullscreen_image.dart';

class ImagesHorizontalSlider extends StatelessWidget {
  const ImagesHorizontalSlider({Key? key, required this.images})
      : super(key: key);

  final List<StrapiMedia> images;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      width: double.infinity,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
          images.length,
          (index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FullScreenImage(
                      imageUrl:
                          StrapiUtils.getLargestImageUrl(images[index].formats),
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    images[index].formats.thumbnail.url,
                    height: 112,
                    width: 158,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        )..add(const SizedBox(
            width: 18)), // Right padding for the outermost element
      ),
    );
  }
}
