import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rtu_mirea_app/services/services.dart';
import 'package:rtu_mirea_app/top_discussions/view/view.dart';
import 'package:rtu_mirea_app/neon/bloc/neon_bloc.dart';
import 'package:app_ui/app_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:async';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Сервисы"),
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

class _ServicesViewState extends State<ServicesView> with SingleTickerProviderStateMixin {
  late final NeonBloc neonBloc;
  late final PageController _pageController;
  late final PageController _bannersPageController;
  Timer? _autoScrollTimer;
  Timer? _resumeScrollTimer;
  bool _isUserInteracting = false;

  final List<String> _categories = ["Главная", "Цифровой университет"];
  int _selectedIndex = 0;
  int _currentBannerIndex = 0;

  late final List<ImportantServiceModel> _importantServices;
  late final List<CommunityModel> _communities;
  late final List<BannerModel> _banners;
  late final List<ServiceTileModel> _mainServices;
  late final List<HorizontalServiceModel> _studentLifeServices;
  late final List<WideServiceModel> _usefulServices;

  @override
  void initState() {
    super.initState();
    neonBloc = NeonBloc();
    _pageController = PageController();
    _bannersPageController = PageController();
    _startAutoScroll();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _importantServices = ServicesConfig.getImportantServices(context);
    _communities = ServicesConfig.getCommunities();
    _banners = ServicesConfig.getBanners(context);
    _mainServices = ServicesConfig.getMainServices(context);
    _studentLifeServices = ServicesConfig.getStudentLifeServices(context);
    _usefulServices = ServicesConfig.getUsefulServices(context);
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted || _isUserInteracting) return;

      if (_banners.isEmpty) return;

      _currentBannerIndex = (_currentBannerIndex + 1) % _banners.length;

      _bannersPageController.animateToPage(
        _currentBannerIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _pauseAutoScroll() {
    _isUserInteracting = true;
    _resumeScrollTimer?.cancel();
    _resumeScrollTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isUserInteracting = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bannersPageController.dispose();
    _autoScrollTimer?.cancel();
    _resumeScrollTimer?.cancel();
    neonBloc.close();
    super.dispose();
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutQuint,
    );
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
                const SizedBox(height: AppSpacing.md),
                Text(
                  'На cloud.mirea.ninja вы можете хранить до 10 ГБ бесплатно (квоту можно расширить в телеграм боте), а также делиться файлами и онлайн редактировать документы вместе с одногруппниками.',
                  style: AppTextStyle.bodyL.copyWith(
                    color: Theme.of(context).extension<AppColors>()!.active,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  onPressed: () {
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
          child: _buildCategorySelector(),
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: [
              _buildMainTab(),
              _buildDigitalUniversityTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedIndex;
          return GestureDetector(
            onTap: () => _onCategorySelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: AppSpacing.sm),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).extension<AppColors>()!.primary
                    : Theme.of(context).extension<AppColors>()!.background02,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  _categories[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Theme.of(context).extension<AppColors>()!.deactive,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainTab() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
          child: const SectionHeader(title: "Важные"),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 170,
          child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: _importantServices.length,
              itemBuilder: (context, index) {
                final service = _importantServices[index];

                if (service.title == 'Cloud Mirea Ninja') {
                  return BlocBuilder<NeonBloc, NeonState>(
                    bloc: neonBloc,
                    builder: (context, state) {
                      return ServiceCard(
                        title: service.title,
                        description: service.description,
                        onTap: () {
                          if (state.isRegisterOfferViewed == false) {
                            _showNeonAccountOffer();
                          } else {
                            ServiceUtils.navigateToService(context, service);
                          }
                        },
                        onLongPress: () {
                          _showNeonAccountOffer();
                        },
                        icon: ServiceIcon(
                          color: service.color,
                          iconColor: Theme.of(context).extension<AppColors>()!.background01,
                          icon: service.iconData,
                        ),
                      );
                    },
                  );
                }

                return ServiceCard(
                  title: service.title,
                  description: service.description,
                  onTap: () => ServiceUtils.navigateToService(context, service),
                  icon: ServiceIcon(
                    color: service.color,
                    iconColor: Theme.of(context).extension<AppColors>()!.active,
                    icon: service.iconData,
                  ),
                );
              }),
        ),
        const SizedBox(height: AppSpacing.xlg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
          child: SectionHeaderWithButton(
            title: "Обсуждаемое",
            buttonText: "Все",
            onPressed: () => launchUrlString(
              'https://mirea.ninja/top',
              mode: LaunchMode.externalApplication,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const TopTopicsView(),
        const SizedBox(height: AppSpacing.xlg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
          child: const SectionHeaderWithButton(
            title: "Сообщества",
            buttonText: "Все",
            onPressed: _dummy,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _communities.length,
            itemBuilder: (context, index) {
              final community = _communities[index];
              return Column(
                children: [
                  CommunityCard(
                    title: community.title,
                    url: community.url,
                    logo: CircleAvatar(
                      foregroundImage: NetworkImage(community.logoUrl),
                    ),
                    launchMode: LaunchMode.externalApplication,
                    description: community.description,
                  ),
                  if (index < _communities.length - 1) const SizedBox(height: AppSpacing.sm),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.xlg),
      ],
    );
  }

  static void _dummy() {}

  Widget _buildDigitalUniversityTab() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(top: AppSpacing.md, bottom: MediaQuery.of(context).padding.bottom + AppSpacing.xlg),
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
              child: SectionHeaderWithButton(
                title: 'Актуальное',
                buttonText: 'Все',
                onPressed: () => launchUrlString('https://mirea.ninja/top', mode: LaunchMode.externalApplication),
              ),
            ),
            SizedBox(
              height: 202,
              child: GestureDetector(
                onTap: _pauseAutoScroll,
                onPanDown: (_) => _pauseAutoScroll(),
                child: PageView.builder(
                  controller: _bannersPageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: _banners.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentBannerIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final banner = _banners[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: VerticalBanner(
                        title: banner.title,
                        description: banner.description ?? '',
                        iconData: banner.iconData,
                        color: banner.color,
                        action: banner.action,
                        onTap: () => ServiceUtils.navigateToService(context, banner),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _banners.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentBannerIndex
                        ? Theme.of(context).extension<AppColors>()!.primary
                        : Theme.of(context).extension<AppColors>()!.deactive.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xlg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
          child: const SectionHeader(title: 'Основные сервисы'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: GridView.count(
            crossAxisCount: 4,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            clipBehavior: Clip.none,
            childAspectRatio: 0.82,
            children: _mainServices
                .map((service) => ServiceTile(
                      title: service.title,
                      iconData: service.iconData,
                      color: service.color,
                      onTap: () => ServiceUtils.navigateToService(context, service),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.xlg),
              child: const SectionHeader(title: 'Студенческая жизнь'),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildHorizontalCardsList(),
          ],
        ),
        const SizedBox(height: AppSpacing.xlg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(title: 'Полезное'),
              const SizedBox(height: AppSpacing.lg),
              _buildWideCardsList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalCardsList() {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xlg),
        itemCount: _studentLifeServices.length,
        itemBuilder: (context, index) {
          final service = _studentLifeServices[index];
          return HorizontalServiceCard(
            title: service.title,
            description: service.description ?? '',
            iconData: service.iconData,
            color: service.color,
            onTap: () => ServiceUtils.navigateToService(context, service),
          );
        },
      ),
    );
  }

  Widget _buildWideCardsList() {
    return Column(
      children: _usefulServices.asMap().entries.map((entry) {
        final index = entry.key;
        final service = entry.value;

        return Column(
          children: [
            WideServiceCard(
              title: service.title,
              description: service.description ?? '',
              iconData: service.iconData,
              color: service.color,
              onTap: () => ServiceUtils.navigateToService(context, service),
            ),
            if (index < _usefulServices.length - 1) const SizedBox(height: AppSpacing.sm),
          ],
        );
      }).toList(),
    );
  }
}
