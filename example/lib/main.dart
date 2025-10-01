import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:live_activities/live_activities.dart';
import 'package:live_activities_example/models/football_game_live_activity_model.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _liveActivitiesPlugin = LiveActivities();
  String? _latestActivityId;
  StreamSubscription<Map<String, dynamic>>? buttonActionSubscription;
  StopwatchState? _stopwatchState;

  @override
  void initState() {
    super.initState();

    _liveActivitiesPlugin.init(
        appGroupId: 'group.habitedge.liveActivitiesExample', urlScheme: 'la');

    if (Platform.isIOS) {
      _liveActivitiesPlugin.activityUpdateStream.listen((event) {
        print('Activity update: $event');
      });

      // Listen for button actions from Live Activities
      buttonActionSubscription =
          _liveActivitiesPlugin.buttonActionStream.listen((actionData) {
        _handleButtonAction(actionData);
      });

      // Register the specific notification names used by this app
      _liveActivitiesPlugin.registerButtonActionNotification(
          'group.habitedge.liveActivitiesExample.button_clicked');
    }
  }

  void _handleButtonAction(Map<String, dynamic> actionData) {
    final action = actionData['action'] as String?;
    final timestamp = actionData['timestamp'] as double?;
    final matchId = actionData['matchId'] as String?;
    final notificationName = actionData['notificationName'] as String?;

    print(
        'Button action received: $action at $timestamp for match: $matchId from notification: $notificationName');

    // Handle different actions based on action type
    switch (action) {
      case 'play_match':
        setState(() {
          _stopwatchState = _stopwatchState?.copyWith(
            isRunning: true,
            startTime: DateTime.now(),
          );
          _updateActivity();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Resumed! ▶️'),
              duration: Duration(seconds: 2),
            ),
          );
        });
        break;
      case 'pause_match':
        setState(() {
          if (_stopwatchState != null && _stopwatchState!.isRunning) {
            final elapsed = DateTime.now()
                .difference(_stopwatchState!.startTime ?? DateTime.now());
            _stopwatchState = _stopwatchState?.copyWith(
              isRunning: false,
              prevTotalElapsed: _stopwatchState!.prevTotalElapsed + elapsed,
              startTime: null,
            );
          }
          _updateActivity();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Paused! ⏸️'),
              duration: Duration(seconds: 2),
            ),
          );
        });
        break;
      case 'plus_action':
        setState(() {
          if (_stopwatchState != null) {
            final currentTarget =
                _stopwatchState!.targetDuration ?? Duration.zero;
            _stopwatchState = _stopwatchState!.copyWith(
              targetDuration: currentTarget + const Duration(minutes: 5),
            );
            _updateActivity();
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Added 5 minutes! ➕'),
              duration: Duration(seconds: 2),
            ),
          );
        });
        break;
      default:
        print('Unknown action: $action');
    }
  }

  // Convert StopwatchState to JSON with Unix timestamp for startTime
  Map<String, dynamic> _prepareActivityData(StopwatchState state) {
    final json = state.toJson();

    // Convert startTime from ISO8601 string to Unix milliseconds for Swift
    if (json['startTime'] != null) {
      final dateTime = DateTime.parse(json['startTime'] as String);
      json['startTime'] = dateTime.millisecondsSinceEpoch;
    }

    return json;
  }

  // Update the activity with current model state
  void _updateActivity() {
    if (_stopwatchState != null && _latestActivityId != null) {
      _liveActivitiesPlugin.updateActivity(
        _latestActivityId!,
        _prepareActivityData(_stopwatchState!),
      );
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    buttonActionSubscription?.cancel();

    // Unregister notification when disposing
    if (Platform.isIOS) {
      _liveActivitiesPlugin.unregisterButtonActionNotification(
          'group.habitedge.liveActivitiesExample.button_clicked');
    }

    _liveActivitiesPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Live Activities (Flutter)',
          style: TextStyle(
            fontSize: 19,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Debug display of current stopwatch state
              if (_stopwatchState != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Debug - Flutter State:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Running: ${_stopwatchState!.isRunning}'),
                      Text(
                          'Target: ${_stopwatchState!.targetDuration?.inSeconds}s'),
                      Text(
                          'Prev Elapsed: ${_stopwatchState!.prevTotalElapsed.inMilliseconds}ms'),
                      Text('Start Time: ${_stopwatchState!.startTime}'),
                      Text(
                          'Remaining: ${_stopwatchState!.clampedRemainingDuration.inSeconds}s'),
                      Text(
                          'Remaining (formatted): ${_formatDuration(_stopwatchState!.clampedRemainingDuration)}'),
                    ],
                  ),
                ),
              if (_latestActivityId != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Card(
                    child: SizedBox(
                      width: double.infinity,
                      height: 120,
                      child: Row(
                        children: [
                          // Expanded(
                          //   child: ScoreWidget(
                          //     score: teamAScore,
                          //     teamName: teamAName,
                          //     onScoreChanged: (score) {
                          //       setState(() {
                          //         teamAScore = score < 0 ? 0 : score;
                          //       });
                          //       _updateScore();
                          //     },
                          //   ),
                          // ),
                          // Expanded(
                          //   child: ScoreWidget(
                          //     score: teamBScore,
                          //     teamName: teamBName,
                          //     onScoreChanged: (score) {
                          //       setState(() {
                          //         teamBScore = score < 0 ? 0 : score;
                          //       });
                          //       _updateScore();
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (_latestActivityId != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        final currentIsRunning =
                            _stopwatchState?.isRunning ?? false;
                        if (currentIsRunning) {
                          // Pause
                          if (_stopwatchState != null) {
                            final elapsed = DateTime.now().difference(
                                _stopwatchState!.startTime ?? DateTime.now());
                            _stopwatchState = _stopwatchState?.copyWith(
                              isRunning: false,
                              prevTotalElapsed:
                                  _stopwatchState!.prevTotalElapsed + elapsed,
                              startTime: null,
                            );
                          }
                        } else {
                          // Play
                          _stopwatchState = _stopwatchState?.copyWith(
                            isRunning: true,
                            startTime: DateTime.now(),
                          );
                        }
                        _updateActivity();
                      });
                    },
                    icon: Icon(
                      (_stopwatchState?.isRunning ?? false)
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      size: 32,
                    ),
                    label: Text(
                      (_stopwatchState?.isRunning ?? false) ? 'Pause' : 'Play',
                      style: const TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      backgroundColor: (_stopwatchState?.isRunning ?? false)
                          ? Colors.orange
                          : Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              if (_latestActivityId == null)
                TextButton(
                  onPressed: () async {
                    await _liveActivitiesPlugin.endAllActivities();
                    await Permission.notification.request();
                    _stopwatchState = StopwatchState.initial(
                      taskName: "Stopwatch",
                      taskEmoji: "⏱️",
                      targetDuration: const Duration(minutes: 5),
                      isRunning: false,
                    );

                    final activityId =
                        await _liveActivitiesPlugin.createActivity(
                      DateTime.now().millisecondsSinceEpoch.toString(),
                      _prepareActivityData(_stopwatchState!),
                    );
                    print("ActivityID: $activityId");
                    setState(() => _latestActivityId = activityId);
                  },
                  child: const Column(
                    children: [
                      Text('Start Timer ⏱️'),
                      Text(
                        '(start a new live activity)',
                        style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              if (_latestActivityId == null)
                TextButton(
                  onPressed: () async {
                    final supported =
                        await _liveActivitiesPlugin.areActivitiesEnabled();
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(
                              supported ? 'Supported' : 'Not supported',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text('Is live activities supported ? 🤔'),
                ),
              if (_latestActivityId != null)
                TextButton(
                  onPressed: () {
                    _liveActivitiesPlugin.endAllActivities();
                    _latestActivityId = null;
                    setState(() {});
                  },
                  child: const Column(
                    children: [
                      Text('Stop Timer ✋'),
                      Text(
                        '(end all live activities)',
                        style: TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
