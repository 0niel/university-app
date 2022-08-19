import 'package:flutter/material.dart';
import 'package:rtu_app_core/rtu_app_core.dart';

class EventCard extends StatelessWidget {
  const EventCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 160,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/test_cover.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Opacity(
            opacity: 0.96,
            child: Container(
              width: 154,
              height: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: const _CardTextInfo(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardTextInfo extends StatelessWidget {
  const _CardTextInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 134,
          height: 110,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _EventLabel(),
              SizedBox(height: 8),
              NinjaText.bodyMedium(
                "Окончание приёма оригинала документа об образовании от qweqwe",
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                fontWeight: 600,
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        NinjaText.bodySmall(
          "15 августа 2022",
          color: Theme.of(context).colorScheme.secondary,
        )
      ],
    );
  }
}

class _EventLabel extends StatelessWidget {
  const _EventLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
        color: NinjaConstant.secondary,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 3,
      ),
      child: NinjaText.bodyMedium(
        'Мероприятие',
        color: Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }
}
