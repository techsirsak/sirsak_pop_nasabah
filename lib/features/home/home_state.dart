import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default('') String userName,
    @Default(0) int points,
    @Default([]) List<ImpactMetric> impactMetrics,
    Challenge? challenge,
    @Default([]) List<Event> events,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _HomeState;
}

@freezed
abstract class ImpactMetric with _$ImpactMetric {
  const factory ImpactMetric({
    required String label,
    required String value,
    required IconData icon,
  }) = _ImpactMetric;
}

@freezed
abstract class Challenge with _$Challenge {
  const factory Challenge({
    required String title,
    required int current,
    required int total,
    required String itemType,
  }) = _Challenge;
}

@freezed
abstract class Event with _$Event {
  const factory Event({
    required String title,
    required String date,
    required String description,
    String? imageAsset,
  }) = _Event;
}
