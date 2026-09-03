import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

enum FriendsTone { neutral, accent, danger }

(Color, Color) friendsToneColors(AppColors colors, FriendsTone tone) {
  return switch (tone) {
    FriendsTone.neutral => (colors.surface2, colors.ink),
    FriendsTone.accent => (colors.tint, colors.accent),
    FriendsTone.danger => (colors.dangerTint, colors.danger),
  };
}
