import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ImagesHorizontalSlider extends StatelessWidget {
  const ImagesHorizontalSlider({Key? key, required this.images}) : super(key: key);

  final List<String> images;

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
                context.push('/image', extra: images);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    images[index],
                    height: 112,
                    width: 158,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        )..add(
            const SizedBox(width: 18),
          ), // Right padding for the outermost element
      ),
    );
  }
}
