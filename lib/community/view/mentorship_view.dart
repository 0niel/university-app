import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/mentorship/mentorship.dart';
import 'package:rtu_mirea_app/community/models/models.dart';
import 'package:rtu_mirea_app/community/widgets/mentorship/mentor_detail_sheet.dart';
import 'package:rtu_mirea_app/community/widgets/mentorship/mentor_profile_sheet.dart';
import 'package:rtu_mirea_app/community/widgets/mentorship/mentor_request_sheet.dart';
import 'package:rtu_mirea_app/community/widgets/mentorship/mentorship_body.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class MentorshipView extends StatelessWidget {
  const MentorshipView({super.key});

  Future<void> _openMentor(BuildContext context, Mentor mentor) async {
    final proceed = await showAppSheet<bool>(
      context,
      title: mentor.fullName,
      child: MentorDetailSheet(mentor: mentor),
    );
    if (proceed != true || !context.mounted) return;
    if (mentor.isMe) {
      await _editProfile(context);
    } else {
      await _request(context, mentor);
    }
  }

  Future<void> _editProfile(BuildContext context) async {
    final cubit = context.read<MentorshipCubit>();
    await showAppSheet<void>(
      context,
      title: cubit.state.isMentor
          ? context.l10n.mentorshipMyProfileTitle
          : context.l10n.mentorshipBecomeTitle,
      scrollable: false,
      maxHeightFraction: .92,
      child: BlocProvider.value(
        value: cubit,
        child: MentorProfileSheet(current: cubit.state.myProfile),
      ),
    );
  }

  Future<void> _request(BuildContext context, Mentor mentor) async {
    final cubit = context.read<MentorshipCubit>();
    final sent = await showAppSheet<bool>(
      context,
      title: context.l10n.mentorshipRequestSheetTitle,
      scrollable: false,
      maxHeightFraction: .92,
      child: BlocProvider.value(
        value: cubit,
        child: MentorRequestSheet(mentor: mentor),
      ),
    );
    if (sent == true && context.mounted) {
      showNinjaToast(
        context,
        message: context.l10n.mentorshipRequestSent,
      );
    }
  }

  Future<void> _openTelegram(BuildContext context, String? handle) async {
    final uri = mentorTelegramUri(handle);
    if (uri == null) {
      _showError(context, context.l10n.mentorshipInvalidHandle);
      return;
    }
    final opened = await launchUrl(uri, mode: .externalApplication);
    if (!opened && context.mounted) {
      _showError(context, context.l10n.mentorshipOpenTelegramError);
    }
  }

  Future<void> _reply(BuildContext context, MentorRequest request) =>
      _openTelegram(context, request.replyTelegramHandle);

  Future<void> _act(
    BuildContext context,
    MentorRequest request,
    MentorRequestAction action,
  ) async {
    if (action == .cancel && !await _confirmCancellation(context)) return;
    if (!context.mounted) return;
    final changed = await context.read<MentorshipCubit>().actOnRequest(
      request.id,
      action,
    );
    if (!changed && context.mounted) {
      _showError(context, context.l10n.mentorshipRequestActionError);
    }
  }

  Future<bool> _confirmCancellation(BuildContext context) {
    return showNinjaConfirmDialog(
      context,
      title: context.l10n.mentorshipCancelConfirmTitle,
      message: context.l10n.mentorshipCancelConfirmBody,
      confirmLabel: context.l10n.mentorshipCancelConfirmAction,
      cancelLabel: context.l10n.collabNotesCancel,
      destructive: true,
    );
  }

  void _showError(BuildContext context, String message) {
    showNinjaToast(context, showCheck: false, message: message);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MentorshipCubit, MentorshipState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == .failure &&
          current.mentors.isNotEmpty,
      listener: (context, _) =>
          _showError(context, context.l10n.mentorshipRefreshError),
      builder: (context, state) => Scaffold(
        backgroundColor: context.colors.canvas,
        body: MentorshipBody(
          header: AppInnerHeader(
            onBack: () => Navigator.of(context).maybePop(),
            backSemanticsLabel: context.l10n.back,
            title: context.l10n.mentorshipTitle,
            subtitle: context.l10n.mentorshipHeaderSubtitle(
              state.mentors.length,
            ),
          ),
          onEditProfile: () => unawaited(_editProfile(context)),
          onRequest: (mentor) => unawaited(_request(context, mentor)),
          onOpenMentor: (mentor) => unawaited(_openMentor(context, mentor)),
          onReply: (request) => unawaited(_reply(context, request)),
          onAction: (request, action) =>
              unawaited(_act(context, request, action)),
          onOpenTelegram: (handle) => unawaited(_openTelegram(context, handle)),
        ),
      ),
    );
  }
}
