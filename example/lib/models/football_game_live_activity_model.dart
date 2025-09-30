import 'package:freezed_annotation/freezed_annotation.dart';

part 'football_game_live_activity_model.freezed.dart';
part 'football_game_live_activity_model.g.dart';

@freezed
class StopwatchState with _$StopwatchState {
  const StopwatchState._();

  factory StopwatchState({
    required String? taskName,
    required DateTime? taskStartTime,
    required String? taskEmoji,
    required Duration prevTotalElapsed,
    required int ticker,
    required DateTime? startTime,
    required Duration? targetDuration,
    required bool isRunning,
    required bool isPipOpen,
    required bool is24HourFormat,
    required String? nextTaskName,
    required String? nextTaskEmoji,
  }) = _StopwatchState;

  factory StopwatchState.initial({
    String? taskName,
    DateTime? taskStartTime,
    String? taskEmoji,
    Duration? prevTotalElapsed,
    int? ticker,
    DateTime? startTime,
    Duration? targetDuration,
    bool? isRunning,
    bool? isPipOpen,
    bool? is24HourFormat,
    String? nextTaskName,
    String? nextTaskEmoji,
  }) {
    return StopwatchState(
      taskName: taskName,
      taskStartTime: taskStartTime,
      taskEmoji: taskEmoji,
      prevTotalElapsed: prevTotalElapsed ?? Duration.zero,
      ticker: ticker ?? 0,
      startTime: startTime,
      targetDuration: targetDuration,
      isRunning: isRunning ?? false,
      isPipOpen: isPipOpen ?? false,
      is24HourFormat: is24HourFormat ?? false,
      nextTaskName: nextTaskName,
      nextTaskEmoji: nextTaskEmoji,
    );
  }

  factory StopwatchState.fromJson(Map<String, dynamic> json) =>
      _$StopwatchStateFromJson(json);

  Duration get currentElapsedDuration => isRunning
      ? DateTime.now().difference(startTime ?? DateTime.now())
      : Duration.zero;
  Duration get elapsedDuration => prevTotalElapsed + currentElapsedDuration;
  DateTime? get originalStartTime => startTime?.subtract(prevTotalElapsed);
  Duration get remainingDuration =>
      (targetDuration ?? Duration.zero) - elapsedDuration;
  Duration get clampedRemainingDuration =>
      remainingDuration < Duration.zero ? Duration.zero : remainingDuration;
  Duration get overtimeDuration =>
      remainingDuration < Duration.zero ? -remainingDuration : Duration.zero;
  bool get isPaused => startTime != null && !isRunning;
  bool get isStopped => startTime == null;
}
