import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/services/models/service_model.dart';

/// Services configuration
class ServicesConfig {
  /// Get important services for the main tab
  static List<ImportantServiceModel> getImportantServices(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return [
      ImportantServiceModel(
        title: 'Карта МИРЭА',
        description: 'Найди нужный кабинет',
        iconData: Icons.map,
        color: colors.colorful07,
        isExternal: false,
        routePath: '/services/map',
      ),
      ImportantServiceModel(
        title: 'NFC-пропуск',
        description: 'Пропуск для входа в университет',
        iconData: Icons.nfc,
        color: colors.colorful04,
        isExternal: false,
        routePath: '/services/nfc',
      ),
      // ImportantServiceModel(
      //   title: 'Бюро находок',
      //   description: 'Найди потерянные вещи',
      //   iconData: Icons.search_rounded,
      //   color: colors.colorful01,
      //   isExternal: false,
      //   routePath: '/services/lost-and-found',
      // ),
      ImportantServiceModel(
        title: 'Cloud Mirea Ninja',
        iconData: Icons.cloud,
        color: colors.colorful04,
        isExternal: false,
        routePath: '/services/neon',
      ),
    ];
  }

  /// Get communities
  static List<CommunityModel> getCommunities() {
    return [
      const CommunityModel(
        title: 'Mirea Ninja',
        description: 'Самый популярный неофициальный чат',
        url: 'https://t.me/mirea_ninja_chat',
        logoUrl:
            'https://sun9-65.userapi.com/impg/bvdpBQYk7glRfRkmsR-GRMMWwK2Rw3lDIuGjzQ/l4qMdaR-HBA.jpg?size=1200x1200&quality=95&sign=427e8060dea18a64efc92e8ae7ab57da&type=album',
      ),
      const CommunityModel(
        title: 'Кафедра КИС',
        description: 'Кафедра Корпоративных информационных систем',
        url: 'https://vk.com/kis_it_mirea',
        logoUrl:
            'https://sun9-1.userapi.com/impg/JSVkx8BMQSKU2IR27bnX_yajk4Bvb_HMf530gg/QkoTZdc_2mM.jpg?size=500x500&quality=95&sign=6bfc16cfff772b175c927aae3e480aa8&type=album',
      ),
      const CommunityModel(
        title: 'Кафедра ИППО',
        description: 'Кафедра Инструментального и прикладного программного обеспечения',
        url: 'https://vk.com/ippo_it',
        logoUrl:
            'https://sun9-21.userapi.com/impg/Sk3d5lpXhoaiHj3QZz1tt8HQKPcEaoE27WgZAw/nig2y-fcRkU.jpg?size=500x600&quality=95&sign=fa26df3e73f398f91d10029134156e5d&type=album',
      ),
      const CommunityModel(
        title: 'Спортивное программирование МИРЭА',
        description: 'Здесь публикуются различные новости и апдейты по олимпиадному программированию в МИРЭА',
        url: 'https://t.me/cp_mirea',
        logoUrl:
            'https://sun9-55.userapi.com/impg/J-OyvW6fp0ZtQ3mJKhI-OxDwPgQbCLhz_PA7bQ/CicJTono2Wk.jpg?size=1920x1920&quality=96&sign=3d4ffbf9a95a4550f203c6909a1af7cf&type=album',
      ),
    ];
  }

  /// Get banners for the "Digital University" tab
  static List<BannerModel> getBanners(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return [
      BannerModel(
        title: 'Личный кабинет',
        description: 'Доступ к оценкам, заявлениям и другим сервисам',
        iconData: Icons.account_circle_rounded,
        color: colors.colorful03,
        url: 'https://lk.mirea.ru/',
        action: 'Открыть',
      ),
      BannerModel(
        title: 'Учебный портал',
        description: 'Доступ к курсам и материалам',
        iconData: Icons.school_rounded,
        color: colors.colorful05,
        url: 'https://online-edu.mirea.ru/',
        action: 'Перейти',
      ),
      BannerModel(
        title: 'Электронный журнал',
        description: 'Проверка посещаемости, расписание',
        iconData: Icons.book_rounded,
        color: colors.colorful01,
        url: 'https://attendance-app.mirea.ru',
        action: 'Перейти',
      ),
    ];
  }

  /// Get main services for the "Digital University" tab
  static List<ServiceTileModel> getMainServices(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return [
      ServiceTileModel(
        title: 'Расписание',
        iconData: Icons.calendar_month_rounded,
        color: colors.colorful01,
        isExternal: false,
        routePath: '/schedule',
      ),
      ServiceTileModel(
        title: 'Библиотека',
        iconData: Icons.auto_stories_rounded,
        color: colors.colorful07,
        url: 'https://library.mirea.ru/',
      ),
      ServiceTileModel(
        title: 'Бесплатное ПО',
        iconData: Icons.download_rounded,
        color: colors.colorful04,
        url: '/eios/free/',
      ),
      ServiceTileModel(
        title: 'Киберзона',
        iconData: Icons.computer_rounded,
        color: colors.colorful06,
        url: 'https://lk.mirea.ru/cyberzone/',
      ),
      ServiceTileModel(
        title: 'Справочник',
        iconData: Icons.help_outline_rounded,
        color: colors.colorful07,
        url: 'https://student.mirea.ru/help/',
      ),
      ServiceTileModel(
        title: 'Стипендии',
        iconData: Icons.payments_outlined,
        color: colors.colorful05,
        url: 'https://www.mirea.ru/education/scholarships-and-social-support/',
      ),
      ServiceTileModel(
        title: 'Воинский учет',
        iconData: Icons.shield_outlined,
        color: colors.colorful01,
        url: 'https://ump.mirea.ru',
      ),
      ServiceTileModel(
        title: 'Общежития',
        iconData: Icons.apartment_rounded,
        color: colors.colorful03,
        url: 'https://www.mirea.ru/education/hostel/',
      ),
    ];
  }

  /// Get student life services
  static List<HorizontalServiceModel> getStudentLifeServices(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return [
      HorizontalServiceModel(
        title: 'Студенческий офис',
        description: 'Справки, документы, вопросы',
        iconData: Icons.support_agent_rounded,
        color: colors.colorful02,
        url: 'https://student.mirea.ru/services/',
      ),
      HorizontalServiceModel(
        title: 'Центр карьеры',
        description: 'Вакансии и стажировки',
        iconData: Icons.work_rounded,
        color: colors.colorful04,
        url: 'https://career.mirea.ru/',
      ),
      HorizontalServiceModel(
        title: 'Сервис инициатив',
        description: 'Идеи и предложения',
        iconData: Icons.lightbulb_outline_rounded,
        color: colors.colorful06,
        url: 'https://vote.mirea.ru/',
      ),
    ];
  }

  /// Get useful services
  static List<WideServiceModel> getUsefulServices(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return [
      WideServiceModel(
        title: 'Виртуальный тур',
        description: 'Интерактивная экскурсия по корпусам университета',
        iconData: Icons.view_in_ar_rounded,
        color: colors.colorful01,
        isExternal: false,
        routePath: '/mediapage/a-virtual-tour-of-the-university/',
      ),
      WideServiceModel(
        title: 'Стартап-акселератор',
        description: 'Поддержка стартапов и предпринимательских идей',
        iconData: Icons.rocket_launch_rounded,
        color: colors.colorful04,
        url: 'https://project.mirea.ru/',
      ),
      WideServiceModel(
        title: 'Корпоративный портал',
        description: 'Доступ для преподавателей и сотрудников',
        iconData: Icons.business_center_rounded,
        color: colors.colorful06,
        url: 'https://portal.mirea.ru/',
      ),
    ];
  }
}
