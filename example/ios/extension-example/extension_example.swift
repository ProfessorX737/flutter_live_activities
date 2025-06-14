//
//  extension_example.swift
//  extension-example
//
//  Created by Dimitri Dessus on 28/09/2022.
//

import ActivityKit
import AppIntents
import SwiftUI
import WidgetKit

@main
struct Widgets: WidgetBundle {
  var body: some Widget {
    if #available(iOS 16.1, *) {
      FootballMatchApp()
    }
  }
}

// We need to redefined live activities pipe
struct LiveActivitiesAppAttributes: ActivityAttributes, Identifiable {
  public typealias LiveDeliveryData = ContentState

  public struct ContentState: Codable, Hashable {}

  var id = UUID()
}

// Create shared default with custom group
let sharedDefault = UserDefaults(suiteName: "group.habitedge.liveActivitiesExample")!

@available(iOSApplicationExtension 16.1, *)
struct FootballMatchApp: Widget {

  var body: some WidgetConfiguration {
    ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
      FootballMatchView(context: context)
    } dynamicIsland: { context in
      // let matchName = sharedDefault.string(forKey: context.attributes.prefixedKey("matchName"))!

      // let teamAName = sharedDefault.string(forKey: context.attributes.prefixedKey("teamAName"))!
      // let teamAState = sharedDefault.string(forKey: context.attributes.prefixedKey("teamAState"))!
      // let teamAScore = sharedDefault.integer(forKey: context.attributes.prefixedKey("teamAScore"))
      // let teamALogo = sharedDefault.string(forKey: context.attributes.prefixedKey("teamALogo"))!

      // let teamBName = sharedDefault.string(forKey: context.attributes.prefixedKey("teamBName"))!
      // let teamBState = sharedDefault.string(forKey: context.attributes.prefixedKey("teamBState"))!
      // let teamBScore = sharedDefault.integer(forKey: context.attributes.prefixedKey("teamBScore"))
      // let teamBLogo = sharedDefault.string(forKey: context.attributes.prefixedKey("teamBLogo"))!

      // let matchStartDate = Date(timeIntervalSince1970: sharedDefault.double(forKey: context.attributes.prefixedKey("matchStartDate")) / 1000)
      // let matchEndDate = Date(timeIntervalSince1970: sharedDefault.double(forKey: context.attributes.prefixedKey("matchEndDate")) / 1000)
      // let matchRemainingTime = matchStartDate...matchEndDate

      return DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          // VStack(alignment: .center, spacing: 2.0) {

          //   if let uiImageTeamA = UIImage(contentsOfFile: teamALogo)
          //   {
          //     Image(uiImage: uiImageTeamA)
          //       .resizable()
          //       .frame(width: 80, height: 80)
          //       .offset(y:0)
          //   }

          //   Spacer()

          //   Text(teamAName)
          //     .lineLimit(1)
          //     .font(.subheadline)
          //     .fontWeight(.bold)
          //     .multilineTextAlignment(.center)

          //   Text(teamAState)
          //     .lineLimit(1)
          //     .font(.footnote)
          //     .fontWeight(.bold)
          //     .multilineTextAlignment(.center)
          // }
          // .frame(width: 70, height: 120)
          // .padding(.bottom, 8)
          // .padding(.top, 8)
        }
        DynamicIslandExpandedRegion(.trailing) {
          // VStack(alignment: .center, spacing: 2.0) {

          //   if let uiImageTeamB = UIImage(contentsOfFile: teamBLogo)
          //   {
          //     Image(uiImage: uiImageTeamB)
          //       .resizable()
          //       .frame(width: 80, height: 80)
          //       .offset(y:0)
          //   }

          //   Spacer()

          //   Text(teamBName)
          //     .lineLimit(1)
          //     .font(.subheadline)
          //     .fontWeight(.bold)
          //     .multilineTextAlignment(.center)

          //   Text(teamBState)
          //     .lineLimit(1)
          //     .font(.footnote)
          //     .fontWeight(.bold)
          //     .multilineTextAlignment(.center)
          // }
          // .frame(width: 70, height: 120)
          // .padding(.bottom, 8)
          // .padding(.top, 8)
        }
        DynamicIslandExpandedRegion(.center) {
          // VStack(alignment: .center, spacing: 6.0) {
          //   HStack {
          //     Text("\(teamAScore)")
          //       .font(.title)
          //       .fontWeight(.bold)

          //     Text(":")
          //       .font(.title)
          //       .fontWeight(.bold)
          //       .foregroundStyle(.primary)

          //     Text("\(teamBScore)")
          //       .font(.title)
          //       .fontWeight(.bold)
          //   }
          //   .padding(.horizontal, 5.0)
          //   .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))

          //   HStack(alignment: .center, spacing: 2.0) {
          //     Text(timerInterval: matchRemainingTime, countsDown: true)
          //       .multilineTextAlignment(.center)
          //       .frame(width: 50)
          //       .monospacedDigit()
          //       .font(.footnote)
          //       .foregroundStyle(.white)
          //   }

          //   VStack(alignment: .center, spacing: 1.0) {
          //     Link(destination: URL(string: "la://my.app/stats")!) {
          //       Text("See stats 📊")
          //     }.padding(.vertical, 5).padding(.horizontal, 5)
          //     Text(matchName)
          //       .font(.footnote)
          //       .foregroundStyle(.white)
          //   }

          // }
          // .padding(.vertical, 6.0)
        }
      } compactLeading: {
        // HStack {
        //   if let uiImageTeamA = UIImage(contentsOfFile: teamALogo)
        //   {
        //     Image(uiImage: uiImageTeamA)
        //       .resizable()
        //       .frame(width: 26, height: 26)
        //   }

        //   Text("\(teamAScore)")
        //     .font(.title)
        //     .fontWeight(.bold)
        // }
      } compactTrailing: {
        // HStack {
        //   Text("\(teamBScore)")
        //     .font(.title)
        //     .fontWeight(.bold)
        //   if let uiImageTeamB = UIImage(contentsOfFile: teamBLogo)
        //   {
        //     Image(uiImage: uiImageTeamB)
        //       .resizable()
        //       .frame(width: 26, height: 26)
        //   }
        // }
      } minimal: {
        // ZStack {
        //   if let uiImageTeamA = UIImage(contentsOfFile: teamALogo)
        //   {
        //     Image(uiImage: uiImageTeamA)
        //       .resizable()
        //       .frame(width: 26, height: 26)
        //       .offset(x:-6)
        //   }

        //   if let uiImageTeamB = UIImage(contentsOfFile: teamBLogo)
        //   {
        //     Image(uiImage: uiImageTeamB)
        //       .resizable()
        //       .frame(width: 26, height: 26)
        //       .offset(x:6)
        //   }
        // }
      }
    }
  }
}

@available(iOSApplicationExtension 16.1, *)
struct FootballMatchView: View {
  let context: ActivityViewContext<LiveActivitiesAppAttributes>

  init(context: ActivityViewContext<LiveActivitiesAppAttributes>) {
    self.context = context
  }

  var body: some View {
    let isPlaying = sharedDefault.bool(forKey: context.attributes.prefixedKey("isPlaying"))

    let startTime = Date()
    let endTime = Date().addingTimeInterval(300)  // 5 minutes
    let timeRange = startTime...endTime

    ZStack {
      // LinearGradient(colors: [Color.black.opacity(0.5),Color.black.opacity(0.3)], startPoint: .topLeading, endPoint: .bottom)

      VStack(spacing: 12) {
        Text(timerInterval: timeRange, countsDown: true)
          .font(.title2)
          .monospacedDigit()
        HStack {
          // Button with immediate state update for responsive UI
          Button(
            intent: SetPlayingIntent.withOptimisticUpdate(isPlaying: !isPlaying) {
              sharedDefault.set(!isPlaying, forKey: context.attributes.prefixedKey("isPlaying"))
            }
          ) {
            ZStack {
              if isPlaying {
                Image(systemName: "pause.fill")
                  .font(.system(size: 32))
                  .foregroundColor(.black)
                  .transition(
                    .asymmetric(
                      insertion: .scale(scale: 0.1).combined(with: .opacity),
                      removal: .scale(scale: 0.1).combined(with: .opacity)
                    ))
              } else {
                Image(systemName: "play.fill")
                  .font(.system(size: 32))
                  .foregroundColor(.black)
                  .transition(
                    .asymmetric(
                      insertion: .scale(scale: 0.1).combined(with: .opacity),
                      removal: .scale(scale: 0.1).combined(with: .opacity)
                    ))
              }
            }
            .animation(.easeInOut(duration: 0.15), value: isPlaying)
          }
          .buttonStyle(.plain)
        }
        .padding(.horizontal, 2.0)

        .padding(.horizontal, 16)
      }
    }
    .frame(height: 160)
    .activityBackgroundTint(Color.white.opacity(0.4))
    .onAppear {
    }
  }

  // Helper function to format time
  private func formatTime(_ seconds: Double) -> String {
    let totalSeconds = Int(seconds)
    let minutes = totalSeconds / 60
    let remainingSeconds = totalSeconds % 60
    return String(format: "%d:%02d", minutes, remainingSeconds)
  }
}

extension LiveActivitiesAppAttributes {
  func prefixedKey(_ key: String) -> String {
    return "\(id)_\(key)"
  }
}

// Base protocol for match-related intents
protocol MatchIntent: AppIntent {
  var actionType: String { get }
  var notificationSuffix: String { get }
  var additionalData: [String: Any] { get }
  var optimisticUpdateClosure: (() -> Void)? { get }
}

extension MatchIntent {
  // Default implementation - no additional data
  var additionalData: [String: Any] { [:] }

  // Default implementation - no optimistic update
  var optimisticUpdateClosure: (() -> Void)? { nil }

  func perform() async throws -> some IntentResult {
    // Perform optimistic update first if provided
    optimisticUpdateClosure?()

    let notificationName = "group.habitedge.liveActivitiesExample.\(notificationSuffix)"

    // Store action in UserDefaults using notification name as key directly
    let existingActions = sharedDefault.array(forKey: notificationName) as? [[String: Any]] ?? []

    // Create base action data
    var newAction: [String: Any] = [
      "action": actionType,
      "timestamp": Date().timeIntervalSince1970,
      "matchId": "current_match",
    ]

    // Merge additional data if provided
    for (key, value) in additionalData {
      newAction[key] = value
    }

    sharedDefault.set(existingActions + [newAction], forKey: notificationName)

    // Send Darwin notification to notify the main app immediately
    CFNotificationCenterPostNotification(
      CFNotificationCenterGetDarwinNotifyCenter(),
      CFNotificationName(notificationName as CFString),
      nil,
      nil,
      true
    )

    // Don't reload timelines automatically to prevent view re-initialization
    WidgetCenter.shared.reloadAllTimelines()

    return .result()
  }
}

struct SetPlayingIntent: MatchIntent {
  static var title: LocalizedStringResource = "Set Playing State"
  static var description = IntentDescription("Set the playing state of the match.")

  @Parameter(title: "Is Playing")
  var isPlaying: Bool

  var actionType: String { isPlaying ? "play_match" : "pause_match" }
  var notificationSuffix: String { "button_clicked" }

  var optimisticUpdateClosure: (() -> Void)? = nil

  init() {
    self.isPlaying = false
  }

  init(isPlaying: Bool) {
    self.isPlaying = isPlaying
  }

  static func withOptimisticUpdate(isPlaying: Bool, _ closure: @escaping () -> Void)
    -> SetPlayingIntent
  {
    var intent = SetPlayingIntent(isPlaying: isPlaying)
    intent.optimisticUpdateClosure = closure
    return intent
  }
}

struct FavoriteMatchIntent: MatchIntent {
  static var title: LocalizedStringResource = "Favorite Match"
  static var description = IntentDescription("Favorite this match.")

  var actionType: String { "favorite_match" }
  var notificationSuffix: String { "button_clicked" }
}

// Intent for the share button interaction
struct ShareMatchIntent: MatchIntent {
  static var title: LocalizedStringResource = "Share Match"
  static var description = IntentDescription("Share this match with friends.")

  var actionType: String { "share_match" }
  var notificationSuffix: String { "button_clicked" }
}

struct SetSliderValueIntent: MatchIntent {
  static var title: LocalizedStringResource = "Set Slider Value"
  static var description = IntentDescription("Set the slider value for the progress.")

  @Parameter(title: "Slider Value")
  var value: Double

  var actionType: String { "set_slider_value" }
  var notificationSuffix: String { "button_clicked" }

  var additionalData: [String: Any] {
    return ["sliderValue": value]
  }

  init() {
    self.value = 0.0
  }

  init(value: Double) {
    self.value = value
  }

  func perform() async throws -> some IntentResult {
    // Update the slider value immediately in shared defaults
    if let currentActivity = Activity<LiveActivitiesAppAttributes>.activities.first {
      sharedDefault.set(value, forKey: currentActivity.attributes.prefixedKey("sliderValue"))
    }

    let notificationName = "group.habitedge.liveActivitiesExample.\(notificationSuffix)"

    // Store action in UserDefaults using notification name as key directly
    let existingActions = sharedDefault.array(forKey: notificationName) as? [[String: Any]] ?? []

    // Create base action data
    var newAction: [String: Any] = [
      "action": actionType,
      "timestamp": Date().timeIntervalSince1970,
      "matchId": "current_match",
      "sliderValue": value,
    ]

    sharedDefault.set(existingActions + [newAction], forKey: notificationName)

    // Send Darwin notification to notify the main app immediately
    CFNotificationCenterPostNotification(
      CFNotificationCenterGetDarwinNotifyCenter(),
      CFNotificationName(notificationName as CFString),
      nil,
      nil,
      true
    )

    return .result()
  }
}
