import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notifications_repository/notifications_repository.dart';

part 'notification_preferences_state.dart';
part 'notification_preferences_event.dart';

enum Category {
  /// Общеуниверситетские объявления.
  announcements,

  /// Уведомления, связанные с изменениями в расписании. Привязаны к группе.
  scheduleUpdates,

  /// Уведомления для конкретной группы. Обязательная категория, которую
  /// пользователь не может отключить.
  group,
}

const visibleCategoryNames = {
  Category.announcements: 'Объявления',
  Category.scheduleUpdates: 'Обновления расписания',
};

/// Транслитерирует название группы для использования в качестве названия
/// категории уведомлений.
String transletirateGroupName(String groupName) {
  final mappings = {
    'А': 'A',
    'Б': 'B',
    'В': 'V',
    'Г': 'G',
    'Д': 'D',
    'Е': 'E',
    'Ё': 'E',
    'Ж': 'Zh',
    'З': 'Z',
    'И': 'I',
    'Й': 'I',
    'К': 'K',
    'Л': 'L',
    'М': 'M',
    'Н': 'N',
    'О': 'O',
    'П': 'P',
    'Р': 'R',
    'С': 'S',
    'Т': 'T',
    'У': 'U',
    'Ф': 'F',
    'Х': 'H',
    'Ц': 'Ts',
    'Ч': 'Ch',
    'Ш': 'Sh',
    'Щ': 'Sch',
    'Ъ': '',
    'Ы': 'Y',
    'Ь': '',
    'Э': 'E',
    'Ю': 'Ju',
    'Я': 'Ja',
  };

  return groupName.split('-').map((word) => word.split('').map((char) => mappings[char] ?? char).join('')).join('-');
}

/// Категория уведомлений. [toString] возвращает название категории, которое
/// используется при подписке на уведомления. [fromString] возвращает объект
/// [Topic] из названия категории.
class Topic extends Equatable {
  Topic({
    required this.topic,
    String? groupName,
  }) {
    if (topic == Category.group || topic == Category.scheduleUpdates) {
      assert(groupName != null);

      this.groupName = transletirateGroupName(groupName ?? '');
    } else {
      this.groupName = null;
    }
  }

  final Category topic;
  late final String? groupName;

  @override
  String toString() {
    switch (topic) {
      case Category.announcements:
        return 'Announcements';
      case Category.scheduleUpdates:
        return 'ScheduleUpdates__${groupName!}';
      case Category.group:
        return groupName!;
    }
  }

  String getVisibleName() {
    switch (topic) {
      case Category.announcements:
        return visibleCategoryNames[Category.announcements]!;
      case Category.scheduleUpdates:
        return visibleCategoryNames[Category.scheduleUpdates]!;
      case Category.group:
        return groupName!;
    }
  }

  static Topic fromVisibleName(String name, String groupName) {
    switch (name) {
      case 'Объявления':
        return Topic(topic: Category.announcements);
      case 'Обновления расписания':
        return Topic(
          topic: Category.scheduleUpdates,
          groupName: groupName,
        );
      default:
        return Topic(
          topic: Category.group,
          groupName: name,
        );
    }
  }

  static Topic fromString(String category) {
    final categoryParts = category.split('__');
    final topic = categoryParts[0];

    switch (topic) {
      case 'Announcements':
        return Topic(topic: Category.announcements);
      case 'ScheduleUpdates':
        return Topic(
          topic: Category.scheduleUpdates,
          groupName: categoryParts[1],
        );
      default:
        return Topic(
          topic: Category.group,
          groupName: category,
        );
    }
  }

  @override
  List<Object?> get props => [topic, groupName];
}

class NotificationPreferencesBloc extends Bloc<NotificationPreferencesEvent, NotificationPreferencesState> {
  NotificationPreferencesBloc({
    required NotificationsRepository notificationsRepository,
  })  : _notificationsRepository = notificationsRepository,
        super(
          NotificationPreferencesState.initial(),
        ) {
    on<CategoriesPreferenceToggled>(
      _onCategoriesPreferenceToggled,
    );
    on<InitialCategoriesPreferencesRequested>(
      _onInitialCategoriesPreferencesRequested,
    );
  }

  final NotificationsRepository _notificationsRepository;

  FutureOr<void> _onCategoriesPreferenceToggled(
    CategoriesPreferenceToggled event,
    Emitter<NotificationPreferencesState> emit,
  ) async {
    emit(state.copyWith(status: NotificationPreferencesStatus.loading));

    final updatedCategories = Set<String>.from(state.selectedCategories);

    updatedCategories.contains(event.category)
        ? updatedCategories.remove(event.category)
        : updatedCategories.add(event.category);

    try {
      final categoriesToSubscribe =
          updatedCategories.map((category) => Topic.fromVisibleName(category, event.group)).toSet();

      /// Добавляем в категории названия академической группы для подписки на
      /// уведомления для группы. Это обязательная категория, которую
      /// пользователь не может отключить.
      categoriesToSubscribe.add(
        Topic(topic: Category.group, groupName: event.group),
      );

      /// Убираем те категории, название которых содержит название группы, но
      /// не совпадает с названием группы в [event.group].
      categoriesToSubscribe.removeWhere((category) {
        if (category.groupName == null) {
          return false;
        }

        final groupName = category.groupName!.toLowerCase();
        final eventGroupName = transletirateGroupName(event.group).toLowerCase();

        return groupName != eventGroupName;
      });

      emit(
        state.copyWith(
          status: NotificationPreferencesStatus.success,
          selectedCategories: updatedCategories,
        ),
      );

      await _notificationsRepository.setCategoriesPreferences(categoriesToSubscribe.map((e) => e.toString()).toSet());
    } catch (error, stackTrace) {
      emit(
        state.copyWith(status: NotificationPreferencesStatus.failure),
      );
      addError(error, stackTrace);
    }
  }

  FutureOr<void> _onInitialCategoriesPreferencesRequested(
    InitialCategoriesPreferencesRequested event,
    Emitter<NotificationPreferencesState> emit,
  ) async {
    emit(state.copyWith(status: NotificationPreferencesStatus.loading));

    try {
      Set<Topic> selectedCategories = await _notificationsRepository
          .fetchCategoriesPreferences()
          .then((categories) => categories?.map((e) => Topic.fromString(e)).toSet() ?? {});

      /// Подписываемся на уведомления для группы [event.group] и отписываемся
      /// от уведомлений для других групп.
      if (!selectedCategories.contains(
        Topic(topic: Category.group, groupName: event.group),
      )) {
        selectedCategories = selectedCategories.where((category) => category.topic != Category.group).toSet();

        selectedCategories.add(
          Topic(topic: Category.group, groupName: event.group),
        );

        await _notificationsRepository.setCategoriesPreferences(selectedCategories.map((e) => e.toString()).toSet());
      }

      await _notificationsRepository.toggleNotifications(
        enable: selectedCategories.isNotEmpty,
      );

      emit(
        state.copyWith(
          status: NotificationPreferencesStatus.success,
          selectedCategories: selectedCategories.map((e) => e.getVisibleName()).toSet(),
          categories: visibleCategoryNames.values.toSet(),
        ),
      );
    } catch (error, stackTrace) {
      emit(
        state.copyWith(status: NotificationPreferencesStatus.failure),
      );
      addError(error, stackTrace);
    }
  }
}
