import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:campus_repository/campus_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtu_mirea_app/community/cubit/mentorship/mentorship.dart';
import 'package:rtu_mirea_app/community/widgets/mentorship/mentor_profile_sheet.dart';
import 'package:rtu_mirea_app/community/widgets/mentorship/mentor_request_sheet.dart';
import 'package:rtu_mirea_app/community/widgets/mentorship/mentorship_body.dart';
import 'package:rtu_mirea_app/community/widgets/widgets.dart';
import 'package:rtu_mirea_app/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class MentorshipView extends StatelessWidget {
  const MentorshipView({super.key});

  Future<void> _editProfile(BuildContext context) async {
    final cubit = context.read<MentorshipCubit>();
    await showAppSheet<void>(
      context,
      title: cubit.state.isMentor
          ? context.l10n.mentorshipMyProfileTitle
          : context.l10n.mentorshipBecomeTitle,
      subtitle: context.l10n.mentorshipBecomeSubtitle,
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

  Future<void> _reply(BuildContext context, MentorRequest request) async {
    final rawHandle = request.requesterHandle ?? '';
    final handle = rawHandle.trim().replaceFirst(RegExp('^@'), '');
    if (!RegExp(r'^[A-Za-z0-9_]{5,32}$').hasMatch(handle)) {
      _showError(context, context.l10n.mentorshipInvalidHandle);
      return;
    }
    final opened = await launchUrl(
      Uri.https('t.me', '/$handle'),
      mode: .externalApplication,
    );
    if (!opened && context.mounted) {
      _showError(context, context.l10n.mentorshipOpenTelegramError);
    }
  }

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
        body: Column(
          children: [
            NinjaCommunityHeader(
              title: context.l10n.mentorshipTitle,
              subtitle: context.l10n.mentorshipHeaderSubtitle(
                state.mentors.length,
              ),
            ),
            Expanded(
              child: MentorshipBody(
                onEditProfile: () => unawaited(_editProfile(context)),
                onRequest: (mentor) => unawaited(_request(context, mentor)),
                onReply: (request) => unawaited(_reply(context, request)),
                onAction: (request, action) =>
                    unawaited(_act(context, request, action)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
