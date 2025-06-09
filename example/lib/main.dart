import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:live_activities/live_activities.dart';
import 'package:live_activities/models/live_activity_file.dart';
import 'package:live_activities/models/url_scheme_data.dart';
import 'package:live_activities_example/models/football_game_live_activity_model.dart';
import 'package:live_activities_example/widgets/score_widget.dart';
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
  TaskPlayerModel? _taskPlayerModel;

  int teamAScore = 0;
  int teamBScore = 0;

  String teamAName = 'PSG';
  String teamBName = 'Chelsea';

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
          'group.habitedge.liveActivitiesExample.favorite_button_clicked');
      _liveActivitiesPlugin.registerButtonActionNotification(
          'group.habitedge.liveActivitiesExample.share_button_clicked');
      _liveActivitiesPlugin.registerButtonActionNotification(
          'group.habitedge.liveActivitiesExample.play_button_clicked');
      _liveActivitiesPlugin.registerButtonActionNotification(
          'group.habitedge.liveActivitiesExample.pause_button_clicked');
    }
  }

  void _handleButtonAction(Map<String, dynamic> actionData) {
    final action = actionData['action'] as String?;
    final timestamp = actionData['timestamp'] as double?;
    final matchId = actionData['matchId'] as String?;
    final notificationName = actionData['notificationName'] as String?;

    print(
        'Button action received: $action at $timestamp for match: $matchId from notification: $notificationName');

    // Handle different actions based on notification name and action type
    if (notificationName ==
        'group.habitedge.liveActivitiesExample.favorite_button_clicked') {
      switch (action) {
        case 'favorite_match':
          setState(() {
            // Update your app state here
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Match favorited! ❤️'),
                duration: Duration(seconds: 2),
              ),
            );
          });
          break;
        default:
          print('Unknown action: $action');
      }
    } else if (notificationName ==
        'group.habitedge.liveActivitiesExample.share_button_clicked') {
      switch (action) {
        case 'share_match':
          setState(() {
            // Update your app state here
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Match shared! 📤'),
                duration: Duration(seconds: 2),
              ),
            );
          });
          break;
        default:
          print('Unknown action: $action');
      }
    } else if (notificationName ==
        'group.habitedge.liveActivitiesExample.play_button_clicked') {
      switch (action) {
        case 'play_match':
          setState(() {
            _taskPlayerModel = _taskPlayerModel?.copyWith(isPlaying: true);
            _updateActivity();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Match resumed! ▶️'),
                duration: Duration(seconds: 2),
              ),
            );
          });
          break;
        default:
          print('Unknown action: $action');
      }
    } else if (notificationName ==
        'group.habitedge.liveActivitiesExample.pause_button_clicked') {
      switch (action) {
        case 'pause_match':
          setState(() {
            _taskPlayerModel = _taskPlayerModel?.copyWith(isPlaying: false);
            _updateActivity();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Match paused! ⏸️'),
                duration: Duration(seconds: 2),
              ),
            );
          });
          break;
        default:
          print('Unknown action: $action');
      }
    } else {
      print('Unknown notification: $notificationName');
    }
  }

  // Update the activity with current model state
  void _updateActivity() {
    if (_taskPlayerModel != null && _latestActivityId != null) {
      print('updating activity: ${_taskPlayerModel!.toMap()}');
      _liveActivitiesPlugin.updateActivity(
        _latestActivityId!,
        _taskPlayerModel!.toMap(),
      );
    }
  }

  @override
  void dispose() {
    buttonActionSubscription?.cancel();

    // Unregister notification when disposing
    if (Platform.isIOS) {
      _liveActivitiesPlugin.unregisterButtonActionNotification(
          'group.habitedge.liveActivitiesExample.favorite_button_clicked');
      _liveActivitiesPlugin.unregisterButtonActionNotification(
          'group.habitedge.liveActivitiesExample.share_button_clicked');
      _liveActivitiesPlugin.unregisterButtonActionNotification(
          'group.habitedge.liveActivitiesExample.play_button_clicked');
      _liveActivitiesPlugin.unregisterButtonActionNotification(
          'group.habitedge.liveActivitiesExample.pause_button_clicked');
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
                        final currentIsPlaying =
                            _taskPlayerModel?.isPlaying ?? false;
                        _taskPlayerModel = _taskPlayerModel?.copyWith(
                            isPlaying: !currentIsPlaying);
                        _updateActivity();
                      });
                    },
                    icon: Icon(
                      (_taskPlayerModel?.isPlaying ?? false)
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      size: 32,
                    ),
                    label: Text(
                      (_taskPlayerModel?.isPlaying ?? false) ? 'Pause' : 'Play',
                      style: const TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      backgroundColor: (_taskPlayerModel?.isPlaying ?? false)
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
                    teamAScore = 0;
                    teamBScore = 0;
                    _taskPlayerModel = TaskPlayerModel(
                      matchName: 'World cup ⚽️',
                      teamAName: 'PSG',
                      teamAState: 'Home',
                      ruleFile: Platform.isIOS
                          ? LiveActivityFileFromAsset('assets/files/rules.txt')
                          : null,
                      teamALogo: Platform.isIOS
                          ? LiveActivityFileFromAsset.image(
                              'assets/images/psg.png')
                          : null,
                      teamBLogo: Platform.isIOS
                          ? LiveActivityFileFromAsset.image(
                              'assets/images/chelsea.png',
                              imageOptions: LiveActivityImageFileOptions(
                                  resizeFactor: 0.2))
                          : null,
                      teamBName: 'Chelsea',
                      teamBState: 'Guest',
                      matchStartDate: DateTime.now(),
                      matchEndDate: DateTime.now().add(
                        const Duration(
                          minutes: 6,
                          seconds: 30,
                        ),
                      ),
                      isPlaying: false,
                    );

                    final activityId =
                        await _liveActivitiesPlugin.createActivity(
                      DateTime.now().millisecondsSinceEpoch.toString(),
                      _taskPlayerModel!.toMap(),
                    );
                    print("ActivityID: $activityId");
                    setState(() => _latestActivityId = activityId);
                  },
                  child: const Column(
                    children: [
                      Text('Start football match ⚽️'),
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
                      Text('Stop match ✋'),
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

  Future _updateScore() async {
    if (_taskPlayerModel == null) {
      return;
    }

    final data = _taskPlayerModel!.copyWith(
      teamAScore: teamAScore,
      teamBScore: teamBScore,
      // teamAName: null,
    );
    return _liveActivitiesPlugin.updateActivity(
      _latestActivityId!,
      data.toMap(),
    );
  }
}
