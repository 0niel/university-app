import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

enum FriendsTone { neutral, accent, danger }

(Color, Color) friendsToneColors(NinjaColors colors, FriendsTone tone) {
  return switch (tone) {
    FriendsTone.neutral => (colors.surfaceAlt, colors.ink),
    FriendsTone.accent => (colors.brandTint, colors.brandInk),
    FriendsTone.danger => (colors.dangerTint, colors.scarlet),
  };
}
