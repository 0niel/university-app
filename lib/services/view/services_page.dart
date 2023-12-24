import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../widgets/widgets.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.background01,
      appBar: AppBar(
        backgroundColor: AppTheme.colors.background01,
        elevation: 0,
        title: const Text(
          "Сервисы",
        ),
      ),
      body: const SafeArea(
        child: ServicesView(),
      ),
    );
  }
}

class ServicesView extends StatefulWidget {
  const ServicesView({super.key});

  @override
  State<ServicesView> createState() => _ServicesViewState();
}

class _ServicesViewState extends State<ServicesView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Популярные",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 152,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ServiceCard(
                  title: 'Карта МИРЭА',
                  url: 'https://map.mirea.ru/',
                  icon: ServiceIcon(
                    color: AppTheme.colors.colorful07,
                    iconColor: AppTheme.colors.active,
                    icon: Icons.map,
                  ),
                  launchMode: LaunchMode.inAppBrowserView,
                  description: 'Найди нужный кабинет',
                ),
                ServiceCard(
                  title: 'Бюро находок',
                  url: 'https://finds.mirea.ru/',
                  icon: ServiceIcon(
                    color: AppTheme.colors.colorful06,
                    iconColor: AppTheme.colors.background01,
                    icon: Icons.search,
                  ),
                  launchMode: LaunchMode.externalApplication,
                  description: 'Найди свои вещи',
                ),
                ServiceCard(
                  title: 'Форум',
                  url: 'https://mirea.ninja/',
                  icon: ServiceIcon(
                    color: AppTheme.colors.colorful01,
                    iconColor: AppTheme.colors.background01,
                    icon: Icons.forum,
                  ),
                  launchMode: LaunchMode.externalApplication,
                  description: 'Форум студентов МИРЭА',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Сообщества",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                CommunityCard(
                  title: 'Mirea Ninja',
                  url: 'https://forum.mirea.ru/',
                  logo: CircleAvatar(
                    // backgroundColor: AppTheme.colors.colorful01,
                    foregroundImage: Image.network(
                      'https://sun9-65.userapi.com/impg/bvdpBQYk7glRfRkmsR-GRMMWwK2Rw3lDIuGjzQ/l4qMdaR-HBA.jpg?size=1200x1200&quality=95&sign=427e8060dea18a64efc92e8ae7ab57da&type=album',
                    ).image,
                  ),
                  launchMode: LaunchMode.externalApplication,
                  description: 'Самый популярный неофициальный чат',
                ),
                CommunityCard(
                  title: 'Кафедра КИС',
                  url: 'https://vk.com/kis_it_mirea',
                  logo: CircleAvatar(
                    // backgroundColor: AppTheme.colors.colorful01,
                    foregroundImage: Image.network(
                      'https://sun9-1.userapi.com/impg/JSVkx8BMQSKU2IR27bnX_yajk4Bvb_HMf530gg/QkoTZdc_2mM.jpg?size=500x500&quality=95&sign=6bfc16cfff772b175c927aae3e480aa8&type=album',
                    ).image,
                  ),
                  launchMode: LaunchMode.externalApplication,
                  description: 'Кафедра Корпоративных информационных систем',
                ),
                CommunityCard(
                  title: 'Кафедра ИППО',
                  url: 'https://vk.com/ippo_it',
                  logo: CircleAvatar(
                    // backgroundColor: AppTheme.colors.colorful01,
                    foregroundImage: Image.network(
                      'https://sun9-21.userapi.com/impg/Sk3d5lpXhoaiHj3QZz1tt8HQKPcEaoE27WgZAw/nig2y-fcRkU.jpg?size=500x600&quality=95&sign=fa26df3e73f398f91d10029134156e5d&type=album',
                    ).image,
                  ),
                  launchMode: LaunchMode.externalApplication,
                  description:
                      'Кафедра Инструментального и прикладного программного обеспечения',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
