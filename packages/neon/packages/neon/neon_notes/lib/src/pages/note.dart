import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:neon_notes/l10n/localizations.dart';
import 'package:neon_notes/src/blocs/note.dart';
import 'package:neon_notes/src/blocs/notes.dart';
import 'package:neon_notes/src/options.dart';
import 'package:neon_notes/src/utils/category_color.dart';
import 'package:neon_notes/src/utils/exception_handler.dart';
import 'package:neon_notes/src/widgets/dialog.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class NotesNotePage extends StatefulWidget {
  const NotesNotePage({
    required this.bloc,
    required this.notesBloc,
    super.key,
  });

  final NotesNoteBloc bloc;
  final NotesBloc notesBloc;

  @override
  State<NotesNotePage> createState() => _NotesNotePageState();
}

class _NotesNotePageState extends State<NotesNotePage> {
  final _contentController = TextEditingController();
  final _titleController = TextEditingController();
  final _contentFocusNode = FocusNode();
  final _titleFocusNode = FocusNode();
  bool _showEditor = false;
  final _contentStreamController = StreamController<String>();
  final _titleStreamController = StreamController<String>();

  void _focusEditor() {
    _contentFocusNode.requestFocus();
    _contentController.selection = TextSelection.collapsed(offset: _contentController.text.length);
  }

  @override
  void initState() {
    super.initState();

    widget.bloc.errors.listen((error) {
      handleNotesException(context, error);
    });

    _contentController.text = widget.bloc.initialContent;
    _titleController.text = widget.bloc.initialTitle;

    _contentStreamController.stream.debounceTime(const Duration(seconds: 1)).listen(widget.bloc.updateContent);
    _titleStreamController.stream.debounceTime(const Duration(seconds: 1)).listen(widget.bloc.updateTitle);
    _contentController.addListener(() => _contentStreamController.add(_contentController.text));
    _titleController.addListener(() => _titleStreamController.add(_titleController.text));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(WakelockPlus.enable());

      if (widget.bloc.options.defaultNoteViewTypeOption.value == DefaultNoteViewType.edit ||
          widget.bloc.initialContent.isEmpty) {
        setState(() {
          _showEditor = true;
        });
        _focusEditor();
      }
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    _titleController.dispose();
    _contentFocusNode.dispose();
    _titleFocusNode.dispose();
    unawaited(_contentStreamController.close());
    unawaited(_titleStreamController.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BackButtonListener(
        onBackButtonPressed: () async {
          unawaited(WakelockPlus.disable());

          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            titleSpacing: 0,
            title: TextField(
              controller: _titleController,
              focusNode: _titleFocusNode,
              style: const TextStyle(
                fontSize: 22,
              ),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: UnderlineInputBorder(),
                focusedBorder: UnderlineInputBorder(),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _showEditor = !_showEditor;
                  });
                  if (_showEditor) {
                    _focusEditor();
                  } else {
                    // Prevent the cursor going back to the title field
                    _contentFocusNode.unfocus();
                    _titleFocusNode.unfocus();
                  }
                },
                tooltip: _showEditor
                    ? NotesLocalizations.of(context).noteShowPreview
                    : NotesLocalizations.of(context).noteShowEditor,
                icon: Icon(
                  _showEditor ? Icons.visibility : Icons.edit,
                ),
              ),
              StreamBuilder(
                stream: widget.bloc.category,
                builder: (context, categorySnapshot) {
                  final category = categorySnapshot.data ?? '';

                  return IconButton(
                    onPressed: () async {
                      final result = await showAdaptiveDialog<String>(
                        context: context,
                        builder: (context) => NotesSelectCategoryDialog(
                          bloc: widget.notesBloc,
                          initialCategory: category,
                        ),
                      );
                      if (result != null) {
                        widget.bloc.updateCategory(result);
                      }
                    },
                    tooltip: NotesLocalizations.of(context).noteChangeCategory,
                    icon: Icon(
                      MdiIcons.tag,
                      color: category.isNotEmpty ? NotesCategoryColor.compute(category) : null,
                    ),
                  );
                },
              ),
            ],
          ),
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showEditor = true;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: _showEditor ? 20 : 10,
                ),
                color: Colors.transparent,
                constraints: const BoxConstraints.expand(),
                child: _showEditor
                    ? TextField(
                        controller: _contentController,
                        focusNode: _contentFocusNode,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      )
                    : SingleChildScrollView(
                        child: MarkdownBody(
                          data: _contentController.text,
                          onTapLink: (text, href, title) async {
                            if (href != null) {
                              await launchUrlString(
                                href,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                        ),
                      ),
              ),
            ),
          ),
        ),
      );
}
