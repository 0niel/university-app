import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rtu_mirea_app/lost_and_found/lost_and_found.dart';
import 'package:university_app_server_api/client.dart';

class CreateLostFoundItemPage extends StatefulWidget {
  final LostFoundItem? item;

  const CreateLostFoundItemPage({super.key, this.item});

  @override
  State<CreateLostFoundItemPage> createState() => _CreateLostFoundItemPageState();
}

class _CreateLostFoundItemPageState extends State<CreateLostFoundItemPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late final TextEditingController _contactController;
  late final TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();
  late LostFoundFormState _formState;
  final List<File> _selectedImages = [];
  late final bool _isEdit;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.item != null;

    _formState = LostFoundFormState(
      title: ItemTitle.pure(widget.item?.itemName ?? ''),
      description: Description.pure(widget.item?.description ?? ''),
      telegramContact: TelegramContact.pure(widget.item?.telegramContactInfo ?? ''),
      phoneContact: PhoneContact.pure(widget.item?.phoneNumberContactInfo ?? ''),
      status: widget.item?.status ?? LostFoundItemStatus.lost,
      images: widget.item?.images ?? [],
    );

    _nameController = TextEditingController(text: _formState.title.value);
    _descController = TextEditingController(text: _formState.description.value);
    _contactController = TextEditingController(text: _formState.telegramContact.value);
    _phoneController = TextEditingController(text: _formState.phoneContact.value);

    _nameController.addListener(_onNameChanged);
    _descController.addListener(_onDescriptionChanged);
    _contactController.addListener(_onTelegramChanged);
    _phoneController.addListener(_onPhoneChanged);
  }

  void _onNameChanged() {
    setState(() {
      _formState = _formState.copyWith(title: ItemTitle.dirty(_nameController.text));
    });
  }

  void _onDescriptionChanged() {
    setState(() {
      _formState = _formState.copyWith(description: Description.dirty(_descController.text));
    });
  }

  void _onTelegramChanged() {
    setState(() {
      _formState = _formState.copyWith(telegramContact: TelegramContact.dirty(_contactController.text));
    });
  }

  void _onPhoneChanged() {
    setState(() {
      _formState = _formState.copyWith(phoneContact: PhoneContact.dirty(_phoneController.text));
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return BlocListener<LostFoundBloc, LostFoundState>(
      listener: (context, state) {
        if (state is LostFoundOperationSuccess) {
          Navigator.of(context).pop();
        } else if (state is LostFoundError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Ошибка: ${state.message}'), backgroundColor: appColors.colorful07));
          setState(() {
            _formState = _formState.copyWith(formStatus: FormzSubmissionStatus.failure);
          });
        }
      },
      child: Scaffold(
        backgroundColor: appColors.background03,
        appBar: AppBar(
          title: Text(_isEdit ? 'Редактировать' : 'Добавить'),
          actions: [
            if (_formState.formStatus == FormzSubmissionStatus.inProgress)
              Container(
                padding: const EdgeInsets.all(10),
                width: 40,
                height: 40,
                child: CircularProgressIndicator(strokeWidth: 2, color: appColors.white),
              )
            else
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: _formState.isValid ? _submitForm : null,
                color: _formState.isValid ? null : appColors.deactive,
              ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImagePicker(appColors),
                const SizedBox(height: 20),
                Text(
                  'Статус объявления',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: appColors.active),
                ),
                const SizedBox(height: 8),
                _buildStatusSelector(context),
                const SizedBox(height: 20),
                Text(
                  'Основная информация',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: appColors.active),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(color: appColors.active),
                  decoration: InputDecoration(
                    labelText: 'Название',
                    hintText: 'Например: Ключи с брелоком',
                    filled: true,
                    fillColor: appColors.background02,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    errorText: _formState.title.isNotValid ? _formState.title.error?.text() : null,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descController,
                  style: TextStyle(color: appColors.active),
                  decoration: InputDecoration(
                    labelText: 'Описание',
                    hintText: 'Подробности о предмете, где и когда был найден/утерян...',
                    filled: true,
                    fillColor: appColors.background02,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                Text(
                  'Контактная информация',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: appColors.active),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _contactController,
                  style: TextStyle(color: appColors.active),
                  decoration: InputDecoration(
                    labelText: 'Телеграм',
                    hintText: '@username',
                    prefixIcon: Icon(Icons.telegram, color: appColors.colorful03),
                    filled: true,
                    fillColor: appColors.background02,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  style: TextStyle(color: appColors.active),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Телефон',
                    hintText: '+7 900 000-00-00',
                    prefixIcon: Icon(Icons.phone, color: appColors.colorful04),
                    filled: true,
                    fillColor: appColors.background02,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    onPressed: _formState.isValid ? _submitForm : null,
                    text: _isEdit ? 'Сохранить изменения' : 'Опубликовать',
                    enabled: _formState.isValid && _formState.formStatus != FormzSubmissionStatus.inProgress,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSelector(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;

    return Container(
      height: 64,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(child: _buildStatusOption('Потеряно', LostFoundItemStatus.lost, Icons.search, appColors)),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatusOption('Найдено', LostFoundItemStatus.found, Icons.check_circle_outline, appColors),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusOption(String label, LostFoundItemStatus value, IconData icon, AppColors appColors) {
    final isSelected = _formState.status == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _formState = _formState.copyWith(status: value);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? appColors.primary : appColors.background02,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? appColors.white : appColors.active),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: isSelected ? appColors.white : appColors.active, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(AppColors appColors) {
    final hasItemImages = _formState.images.isNotEmpty;

    if (_selectedImages.isEmpty && !hasItemImages) {
      return InkWell(
        onTap: _pickImages,
        child: Container(
          height: 200,
          decoration: BoxDecoration(color: appColors.background02, borderRadius: BorderRadius.circular(8)),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_a_photo, size: 40, color: appColors.deactive),
                const SizedBox(height: 8),
                Text('Добавить фотографию', style: TextStyle(color: appColors.deactive)),
              ],
            ),
          ),
        ),
      );
    } else {
      final existingImages = _formState.images.cast<String>();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // Новые выбранные фото
              for (final file in _selectedImages)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(file, width: 100, height: 100, fit: BoxFit.cover),
                ),
              // Уже существующие фото (при редактировании)
              for (final url in existingImages)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(url, width: 100, height: 100, fit: BoxFit.cover),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _pickImages,
              icon: Icon(Icons.add_a_photo, color: appColors.primary),
              label: Text('Добавить ещё фото', style: TextStyle(color: appColors.primary)),
            ),
          ),
        ],
      );
    }
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      final newSelectedImages = _selectedImages + images.map((e) => File(e.path)).toList();
      setState(() {
        _selectedImages.addAll(images.map((e) => File(e.path)).toList());
        _formState = _formState.copyWith(images: [..._formState.images, ...images.map((e) => File(e.path))]);
      });
    }
  }

  void _submitForm() {
    if (!_formState.isValid) return;

    setState(() {
      _formState = _formState.copyWith(formStatus: FormzSubmissionStatus.inProgress);
    });

    final now = DateTime.now();
    final bloc = context.read<LostFoundBloc>();

    if (_isEdit) {
      final item = widget.item!;
      // We're updating an existing item
      bloc.add(UpdateLostFoundItem(item, _selectedImages));
    } else {
      // Creating new item
      bloc.add(
        CreateLostFoundItem(
          title: _nameController.text,
          description: _descController.text,
          telegram: _contactController.text,
          phoneNumber: _phoneController.text,
          status: _formState.status,
          images: _selectedImages,
        ),
      );
    }
  }
}
