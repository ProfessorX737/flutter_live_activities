//
//  extension_example.swift
//  extension-example
//
//  Created by Dimitri Dessus on 28/09/2022.
//

import ActivityKit
import WidgetKit
import SwiftUI
import AppIntents

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
  
  public struct ContentState: Codable, Hashable { }
  
  var id = UUID()
}

// Create shared default with custom group
let sharedDefault = UserDefaults(suiteName: "group.habitedge.liveActivitiesExample")!

@available(iOSApplicationExtension 16.1, *)
struct FootballMatchApp: Widget {

  var body: some WidgetConfiguration {
    ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
      // let matchName = sharedDefault.string(forKey: context.attributes.prefixedKey("matchName"))!
      // let ruleFile = sharedDefault.string(forKey: context.attributes.prefixedKey("ruleFile"))!
      
      // let teamAName = sharedDefault.string(forKey: context.attributes.prefixedKey("teamAName"))!
      // let teamAState = sharedDefault.string(forKey: context.attributes.prefixedKey("teamAState"))!
      // let teamAScore = sharedDefault.integer(forKey: context.attributes.prefixedKey("teamAScore"))
      // let teamALogo = sharedDefault.string(forKey: context.attributes.prefixedKey("teamALogo"))!
      
      // let teamBName = sharedDefault.string(forKey: context.attributes.prefixedKey("teamBName"))!
      // let teamBState = sharedDefault.string(forKey: context.attributes.prefixedKey("teamBState"))!
      let teamBScore = sharedDefault.integer(forKey: context.attributes.prefixedKey("teamBScore"))
      // let teamBLogo = sharedDefault.string(forKey: context.attributes.prefixedKey("teamBLogo"))!
      
      // let rule = (try? String(contentsOfFile: ruleFile, encoding: .utf8)) ?? ""
      // let matchStartDate = Date(timeIntervalSince1970: sharedDefault.double(forKey: context.attributes.prefixedKey("matchStartDate")) / 1000)
      // let matchEndDate = Date(timeIntervalSince1970: sharedDefault.double(forKey: context.attributes.prefixedKey("matchEndDate")) / 1000)
      // let matchRemainingTime = matchStartDate...matchEndDate
      let isPlaying = sharedDefault.bool(forKey: context.attributes.prefixedKey("isPlaying"))
      
      ZStack {
        // LinearGradient(colors: [Color.black.opacity(0.5),Color.black.opacity(0.3)], startPoint: .topLeading, endPoint: .bottom)
        HStack {
          // For better animation responsiveness, we'll use a local variable that gets updated immediately
          // and then force a widget timeline refresh
          Button(intent: SetPlayingIntent.withOptimisticUpdate(isPlaying: !isPlaying) {
              print("🔘 Button pressed - Current isPlaying: \(isPlaying), New value: \(!isPlaying)")
              let key = context.attributes.prefixedKey("isPlaying")
              sharedDefault.set(!isPlaying, forKey: key)
              
              // Request immediate widget refresh for faster animation
              // WidgetCenter.shared.reloadTimelines(ofKind: "extension-example")
          }) {
            ZStack {
              if isPlaying {
                Image(systemName: "pause.fill")
                  .font(.largeTitle)
                  .foregroundColor(.black)
                  .transition(.asymmetric(
                    insertion: .scale(scale: 0.1).combined(with: .opacity),
                    removal: .scale(scale: 0.1).combined(with: .opacity)
                  ))
              } else {
                Image(systemName: "play.fill")
                  .font(.largeTitle)
                  .foregroundColor(.black)
                  .transition(.asymmetric(
                    insertion: .scale(scale: 0.1).combined(with: .opacity),
                    removal: .scale(scale: 0.1).combined(with: .opacity)
                  ))
              }
            }
            .animation(.easeInOut(duration: 0.15), value: isPlaying)
          }
          .buttonStyle(.plain)

          // Animated text transition
          HStack {
            if isPlaying {
              Text("Playing")
                .font(.title2)
                .transition(.asymmetric(
                  insertion: .scale(scale: 0.1).combined(with: .opacity),
                  removal: .scale(scale: 0.1).combined(with: .opacity)
                ))
            } else {
              Text("Paused")
                .font(.title2)
                .transition(.asymmetric(
                  insertion: .scale(scale: 0.1).combined(with: .opacity),
                  removal: .scale(scale: 0.1).combined(with: .opacity)
                ))
            }
          }
          .animation(.easeInOut(duration: 0.25), value: isPlaying)
              
          Text("\(teamBScore)")
            .font(.title)
            .fontWeight(.bold)
            .scaleEffect(isPlaying ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isPlaying)
        }
        .padding(.horizontal, 2.0)
      }
      .frame(height: 160)
      .activityBackgroundTint(Color.white.opacity(0.4))
      .onAppear {
        print("🎵 Live Activity - isPlaying: \(isPlaying)")
      }
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
            "matchId": "current_match"
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
        
        return .result()
    }
}

struct SetPlayingIntent: MatchIntent {
    static var title: LocalizedStringResource = "Set Playing State"
    static var description = IntentDescription("Set the playing state of the match.")
    
    @Parameter(title: "Is Playing")
    var isPlaying: Bool
    
    var actionType: String { isPlaying ? "play_match" : "pause_match" }
    var notificationSuffix: String { isPlaying ? "play_button_clicked" : "pause_button_clicked" }
    
    var optimisticUpdateClosure: (() -> Void)? = nil
    
    init() {
        self.isPlaying = false
    }
    
    init(isPlaying: Bool) {
        self.isPlaying = isPlaying
    }
    
    static func withOptimisticUpdate(isPlaying: Bool, _ closure: @escaping () -> Void) -> SetPlayingIntent {
        var intent = SetPlayingIntent(isPlaying: isPlaying)
        intent.optimisticUpdateClosure = closure
        return intent
    }
}

struct FavoriteMatchIntent: MatchIntent {
    static var title: LocalizedStringResource = "Favorite Match"
    static var description = IntentDescription("Favorite this match.")
    
    var actionType: String { "favorite_match" }
    var notificationSuffix: String { "favorite_button_clicked" }
}

// Intent for the share button interaction
struct ShareMatchIntent: MatchIntent {
    static var title: LocalizedStringResource = "Share Match"
    static var description = IntentDescription("Share this match with friends.")
    
    var actionType: String { "share_match" }
    var notificationSuffix: String { "share_button_clicked" }
}
