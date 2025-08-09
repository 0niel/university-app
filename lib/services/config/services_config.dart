import 'package:flutter/material.dart';
import 'package:app_ui/app_ui.dart';
import 'package:rtu_mirea_app/services/models/service_model.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';

/// Services configuration
class ServicesConfig {
  /// Get important services for the main tab
  static List<ImportantServiceModel> getImportantServices(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final l10n = context.l10n;

    return [
      ImportantServiceModel(
        title: l10n.mireaMap,
        description: l10n.findNeededClassroom,
        iconData: Icons.map,
        color: colors.colorful07,
        isExternal: false,
        routePath: '/services/map',
      ),
      ImportantServiceModel(
        title: l10n.nfcPass,
        description: l10n.passForUniversityEntry,
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
    ];
  }

  /// Get communities
  static List<CommunityModel> getCommunities(BuildContext context) {
    final l10n = context.l10n;

    return [
      CommunityModel(
        title: l10n.mireaNinja,
        description: l10n.mostPopularUnofficialChat,
        url: 'https://t.me/mirea_ninja_chat',
        logoUrl:
            'https://sun9-65.userapi.com/impg/bvdpBQYk7glRfRkmsR-GRMMWwK2Rw3lDIuGjzQ/l4qMdaR-HBA.jpg?size=1200x1200&quality=95&sign=427e8060dea18a64efc92e8ae7ab57da&type=album',
      ),
      CommunityModel(
        title: l10n.kisDepartment,
        description: l10n.corporateInformationSystems,
        url: 'https://vk.com/kis_it_mirea',
        logoUrl:
            'https://sun9-1.userapi.com/impg/JSVkx8BMQSKU2IR27bnX_yajk4Bvb_HMf530gg/QkoTZdc_2mM.jpg?size=500x500&quality=95&sign=6bfc16cfff772b175c927aae3e480aa8&type=album',
      ),
      CommunityModel(
        title: l10n.ippoDepartment,
        description: l10n.instrumentalAndAppliedSoftware,
        url: 'https://vk.com/ippo_it',
        logoUrl:
            'https://sun9-21.userapi.com/impg/Sk3d5lpXhoaiHj3QZz1tt8HQKPcEaoE27WgZAw/nig2y-fcRkU.jpg?size=500x600&quality=95&sign=fa26df3e73f398f91d10029134156e5d&type=album',
      ),
      CommunityModel(
        title: l10n.competitiveProgrammingMirea,
        description: l10n.competitiveProgrammingDescription,
        url: 'https://t.me/cp_mirea',
        logoUrl:
            'https://sun9-55.userapi.com/impg/J-OyvW6fp0ZtQ3mJKhI-OxDwPgQbCLhz_PA7bQ/CicJTono2Wk.jpg?size=1920x1920&quality=96&sign=3d4ffbf9a95a4550f203c6909a1af7cf&type=album',
      ),
    ];
  }

  /// Get banners for the "Digital University" tab
  static List<BannerModel> getBanners(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final l10n = context.l10n;

    return [
      BannerModel(
        title: l10n.personalAccount,
        description: l10n.accessToGradesAndServices,
        iconData: Icons.account_circle_rounded,
        color: colors.colorful03,
        url: 'https://lk.mirea.ru/',
        action: l10n.openAction,
      ),
      BannerModel(
        title: l10n.educationalPortal,
        description: l10n.accessToCoursesAndMaterials,
        iconData: Icons.school_rounded,
        color: colors.colorful05,
        url: 'https://online-edu.mirea.ru/',
        action: l10n.goToAction,
      ),
      BannerModel(
        title: l10n.electronicJournal,
        description: l10n.attendanceCheckSchedule,
        iconData: Icons.book_rounded,
        color: colors.colorful01,
        url: 'https://attendance-app.mirea.ru',
        action: l10n.goToAction,
      ),
    ];
  }

  /// Get main services for the "Digital University" tab
  static List<ServiceTileModel> getMainServices(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final l10n = context.l10n;

    return [
      ServiceTileModel(
        title: l10n.scheduleAppBarTitle,
        iconData: Icons.calendar_month_rounded,
        color: colors.colorful01,
        isExternal: false,
        routePath: '/schedule',
      ),
      ServiceTileModel(
        title: l10n.library,
        iconData: Icons.auto_stories_rounded,
        color: colors.colorful07,
        url: 'https://library.mirea.ru/',
      ),
      ServiceTileModel(
        title: l10n.freeSoftware,
        iconData: Icons.download_rounded,
        color: colors.colorful04,
        url: '/eios/free/',
      ),
      ServiceTileModel(
        title: l10n.cyberzone,
        iconData: Icons.computer_rounded,
        color: colors.colorful06,
        url: 'https://lk.mirea.ru/cyberzone/',
      ),
      ServiceTileModel(
        title: l10n.handbook,
        iconData: Icons.help_outline_rounded,
        color: colors.colorful07,
        url: 'https://student.mirea.ru/help/',
      ),
      ServiceTileModel(
        title: l10n.scholarships,
        iconData: Icons.payments_outlined,
        color: colors.colorful05,
        url: 'https://www.mirea.ru/education/scholarships-and-social-support/',
      ),
      ServiceTileModel(
        title: l10n.militaryRegistration,
        iconData: Icons.shield_outlined,
        color: colors.colorful01,
        url: 'https://ump.mirea.ru',
      ),
      ServiceTileModel(
        title: l10n.dormitories,
        iconData: Icons.apartment_rounded,
        color: colors.colorful03,
        url: 'https://www.mirea.ru/education/hostel/',
      ),
    ];
  }

  /// Get student life services
  static List<HorizontalServiceModel> getStudentLifeServices(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final l10n = context.l10n;

    return [
      HorizontalServiceModel(
        title: l10n.studentOffice,
        description: l10n.certificatesDocumentsQuestions,
        iconData: Icons.support_agent_rounded,
        color: colors.colorful02,
        url: 'https://student.mirea.ru/services/',
      ),
      HorizontalServiceModel(
        title: l10n.careerCenter,
        description: l10n.vacanciesAndInternships,
        iconData: Icons.work_rounded,
        color: colors.colorful04,
        url: 'https://career.mirea.ru/',
      ),
      HorizontalServiceModel(
        title: l10n.initiativeService,
        description: l10n.ideasAndSuggestions,
        iconData: Icons.lightbulb_outline_rounded,
        color: colors.colorful06,
        url: 'https://vote.mirea.ru/',
      ),
    ];
  }

  /// Get useful services
  static List<WideServiceModel> getUsefulServices(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final l10n = context.l10n;

    return [
      WideServiceModel(
        title: l10n.virtualTour,
        description: l10n.interactiveUniversityTour,
        iconData: Icons.view_in_ar_rounded,
        color: colors.colorful01,
        isExternal: false,
        routePath: '/mediapage/a-virtual-tour-of-the-university/',
      ),
      WideServiceModel(
        title: l10n.startupAccelerator,
        description: l10n.startupSupport,
        iconData: Icons.rocket_launch_rounded,
        color: colors.colorful04,
        url: 'https://project.mirea.ru/',
      ),
      WideServiceModel(
        title: l10n.corporatePortal,
        description: l10n.accessForTeachersAndStaff,
        iconData: Icons.business_center_rounded,
        color: colors.colorful06,
        url: 'https://portal.mirea.ru/',
      ),
    ];
  }
}
