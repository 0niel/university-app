import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/top_discussions/view/view.dart';
import 'package:rtu_mirea_app/neon/bloc/neon_bloc.dart';
import 'package:app_ui/app_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../widgets/widgets.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Сервисы",
        ),
      ),
      body: const ServicesView(),
    );
  }
}

class ServicesView extends StatefulWidget {
  const ServicesView({super.key});

  @override
  State<ServicesView> createState() => _ServicesViewState();
}

class _ServicesViewState extends State<ServicesView> {
  late final NeonBloc neonBloc;

  @override
  void initState() {
    neonBloc = NeonBloc();
    super.initState();
  }

  @override
  void dispose() {
    neonBloc.close();
    super.dispose();
  }

  void _showNeonAccountOffer() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        neonBloc.add(const VieweRegisterOffer());
        BottomModalSheet.show(
          context,
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.cloud,
                  size: 64,
                  color: Theme.of(context).extension<AppColors>()!.active,
                ),
                const SizedBox(height: 16),
                Text(
                  'На cloud.mirea.ninja вы можете хранить до 10 ГБ бесплатно (квоту можно расширить в телеграм боте), а также делиться файлами и онлайн редактировать документы вместе с одногруппниками.',
                  style: AppTextStyle.bodyL.copyWith(
                    color: Theme.of(context).extension<AppColors>()!.active,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  onClick: () {
                    launchUrlString('https://t.me/cloud_mirea_ninja_bot', mode: LaunchMode.externalApplication);
                  },
                  text: 'Создать аккаунт',
                ),
              ],
            ),
          ),
          title: 'Создайте аккаунт',
          description:
              'Мы предлагаем вам бесплатно создать аккаунт в нашем облачном хранилище, чтобы вы могли хранить свои файлы и документы!',
          backgroundColor: Theme.of(context).extension<AppColors>()!.background03,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: CustomScrollView(
        slivers: [
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Популярные",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 152,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ServiceCard(
                      title: 'Карта МИРЭА',
                      icon: ServiceIcon(
                        color: Theme.of(context).extension<AppColors>()!.colorful07,
                        iconColor: Theme.of(context).extension<AppColors>()!.active,
                        icon: Icons.map,
                      ),
                      description: 'Найди нужный кабинет',
                      onTap: () {
                        context.go('/services/map');
                      },
                    ),
                    if (Platform.isAndroid)
                      ServiceCard(
                        title: 'NFC Пропуск',
                        icon: ServiceIcon(
                          color: Theme.of(context).extension<AppColors>()!.colorful03,
                          iconColor: Theme.of(context).extension<AppColors>()!.active,
                          icon: Icons.nfc,
                        ),
                        onTap: () {
                          context.go('/services/nfc');
                        },
                        description: 'Смартфон как пропуск',
                      ),
                    BlocBuilder<NeonBloc, NeonState>(
                      bloc: neonBloc,
                      builder: (context, state) {
                        return ServiceCard(
                          title: 'Cloud Mirea Ninja',
                          onTap: () {
                            if (state.isRegisterOfferViewed == false) {
                              _showNeonAccountOffer();
                            } else {
                              context.go('/services/neon');
                            }
                          },
                          onLongPress: () {
                            _showNeonAccountOffer();
                          },
                          icon: ServiceIcon(
                            color: Theme.of(context).extension<AppColors>()!.colorful04,
                            iconColor: Theme.of(context).extension<AppColors>()!.background01,
                            icon: Icons.cloud,
                          ),
                        );
                      },
                    ),
                    // ServiceCard(
                    //   title: 'Бюро находок',
                    //   url: 'https://finds.mirea.ninja/',
                    //   icon: ServiceIcon(
                    //     color: Theme.of(context).extension<AppColors>()!.colorful06,
                    //     iconColor: Theme.of(context).extension<AppColors>()!.background01,
                    //     icon: Icons.search,
                    //   ),
                    //   launchMode: LaunchMode.externalApplication,
                    //   description: 'Найди свои вещи',
                    // ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Обсуждаемое",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PlatformTextButton(
                    onPressed: () {
                      launchUrlString('https://mirea.ninja/top', mode: LaunchMode.externalApplication);
                    },
                    child: const Text('Все'),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: TopTopicsView(),
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Сообщества",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const CommunityCard(
                    title: 'Mirea Ninja',
                    url: 'https://t.me/mirea_ninja_chat',
                    logo: CircleAvatar(
                      foregroundImage: NetworkImage(
                        'https://sun9-65.userapi.com/impg/bvdpBQYk7glRfRkmsR-GRMMWwK2Rw3lDIuGjzQ/l4qMdaR-HBA.jpg?size=1200x1200&quality=95&sign=427e8060dea18a64efc92e8ae7ab57da&type=album',
                      ),
                    ),
                    launchMode: LaunchMode.externalApplication,
                    description: 'Самый популярный неофициальный чат',
                  ),
                  const CommunityCard(
                    title: 'Кафедра КИС',
                    url: 'https://vk.com/kis_it_mirea',
                    logo: CircleAvatar(
                      foregroundImage: NetworkImage(
                        'https://sun9-1.userapi.com/impg/JSVkx8BMQSKU2IR27bnX_yajk4Bvb_HMf530gg/QkoTZdc_2mM.jpg?size=500x500&quality=95&sign=6bfc16cfff772b175c927aae3e480aa8&type=album',
                      ),
                    ),
                    launchMode: LaunchMode.externalApplication,
                    description: 'Кафедра Корпоративных информационных систем',
                  ),
                  const CommunityCard(
                    title: 'Кафедра ИППО',
                    url: 'https://vk.com/ippo_it',
                    logo: CircleAvatar(
                      foregroundImage: NetworkImage(
                        'https://sun9-21.userapi.com/impg/Sk3d5lpXhoaiHj3QZz1tt8HQKPcEaoE27WgZAw/nig2y-fcRkU.jpg?size=500x600&quality=95&sign=fa26df3e73f398f91d10029134156e5d&type=album',
                      ),
                    ),
                    launchMode: LaunchMode.externalApplication,
                    description: 'Кафедра Инструментального и прикладного программного обеспечения',
                  ),
                  const CommunityCard(
                    title: 'Спортивное программирование МИРЭА',
                    url: 'https://t.me/cp_mirea',
                    logo: CircleAvatar(
                      foregroundImage: NetworkImage(
                        'https://sun9-55.userapi.com/impg/J-OyvW6fp0ZtQ3mJKhI-OxDwPgQbCLhz_PA7bQ/CicJTono2Wk.jpg?size=1920x1920&quality=96&sign=3d4ffbf9a95a4550f203c6909a1af7cf&type=album',
                      ),
                    ),
                    launchMode: LaunchMode.externalApplication,
                    description:
                        'Здесь публикуются различные новости и апдейты по олимпиадному программированию в МИРЭА',
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          ),
        ],
      ),
    );
  }
}
