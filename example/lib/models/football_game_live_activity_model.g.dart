// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'football_game_live_activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StopwatchStateImpl _$$StopwatchStateImplFromJson(Map<String, dynamic> json) =>
    _$StopwatchStateImpl(
      taskName: json['taskName'] as String?,
      taskStartTime: json['taskStartTime'] == null
          ? null
          : DateTime.parse(json['taskStartTime'] as String),
      taskEmoji: json['taskEmoji'] as String?,
      prevTotalElapsed:
          Duration(microseconds: (json['prevTotalElapsed'] as num).toInt()),
      ticker: (json['ticker'] as num).toInt(),
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      targetDuration: json['targetDuration'] == null
          ? null
          : Duration(microseconds: (json['targetDuration'] as num).toInt()),
      isRunning: json['isRunning'] as bool,
      isPipOpen: json['isPipOpen'] as bool,
      is24HourFormat: json['is24HourFormat'] as bool,
      nextTaskName: json['nextTaskName'] as String?,
      nextTaskEmoji: json['nextTaskEmoji'] as String?,
    );

Map<String, dynamic> _$$StopwatchStateImplToJson(
        _$StopwatchStateImpl instance) =>
    <String, dynamic>{
      'taskName': instance.taskName,
      'taskStartTime': instance.taskStartTime?.toIso8601String(),
      'taskEmoji': instance.taskEmoji,
      'prevTotalElapsed': instance.prevTotalElapsed.inMicroseconds,
      'ticker': instance.ticker,
      'startTime': instance.startTime?.toIso8601String(),
      'targetDuration': instance.targetDuration?.inMicroseconds,
      'isRunning': instance.isRunning,
      'isPipOpen': instance.isPipOpen,
      'is24HourFormat': instance.is24HourFormat,
      'nextTaskName': instance.nextTaskName,
      'nextTaskEmoji': instance.nextTaskEmoji,
    };
