//
//  TBTaskWidgetLiveActivity.swift
//  TBTaskWidget
//
//  Created by Raja Software Labs on 11/08/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TBTaskWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        // This closure is the Lock Screen banner. It is a completely separate
        // layout from the Dynamic Island below — not a resized version of it.
        ActivityConfiguration(for: TBTaskActivityAttributes.self) { context in
            HStack(spacing: 12) {
                Image(systemName: "checklist")
                    .font(.title2)
                VStack(alignment: .leading, spacing: 2) {
                    Text(context.state.title)
                        .font(.headline)
                        .lineLimit(1)
                    statusText(for: context.state)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding()
            // TODO (Live Activities 4/4): Style the Lock Screen banner.
            //
            // A Live Activity is drawn by the system, not by your app, so it
            // takes its colours from ActivityKit's own modifiers rather than
            // ordinary SwiftUI backgrounds. Uncomment these and pick colours
            // that stay legible over a Lock Screen wallpaper.
            //
            // .activityBackgroundTint(<#Color#>)
            // .activitySystemActionForegroundColor(<#Color#>)
            //
            // See "Where Live Activities Appear" in the training document.

        } dynamicIsland: { context in
            // TODO (Dynamic Island 1/1): Fill in all of the presentations below.
            //
            // ActivityKit requires every presentation, because the system picks
            // between them based on device state — you do not get to choose
            // which one appears:
            //
            //   * expanded — shown on long press, laid out across the .leading,
            //                .trailing and .bottom regions.
            //   * compact  — the collapsed pill either side of the camera
            //                housing (compactLeading / compactTrailing).
            //   * minimal  — a single glyph, shown when more than one Live
            //                Activity is running at once.
            //
            // Replace each EmptyView() below. Use context.state for the data and
            // reuse the GIVEN statusText(for:) helper for the countdown — do not
            // reimplement it. Keep the compact presentations genuinely compact:
            // the pill fits an icon on one side and a short countdown on the
            // other, nothing more.
            //
            // See "Where Live Activities Appear" and "Building the Dynamic
            // Island Layouts" in the training document.
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    EmptyView()     // suggestion: the checklist icon
                }
                DynamicIslandExpandedRegion(.trailing) {
                    EmptyView()     // suggestion: the countdown
                }
                DynamicIslandExpandedRegion(.bottom) {
                    EmptyView()     // suggestion: the task title
                }
            } compactLeading: {
                EmptyView()         // suggestion: the checklist icon
            } compactTrailing: {
                EmptyView()         // suggestion: the countdown
            } minimal: {
                EmptyView()         // suggestion: the checklist icon
            }
        }
    }

    // GIVEN — do not modify. Text(timerInterval:) ticks live on-device every
    // second with no further ActivityKit updates from the app — but the
    // surrounding "is it overdue" branch only re-evaluates when the activity's
    // content actually refreshes, so a task can sit at "0:00" briefly until the
    // next real update.
    @ViewBuilder
    private func statusText(for state: TBTaskActivityAttributes.ContentState) -> some View {
        if state.dueDate > .now {
            Text(timerInterval: Date.now...state.dueDate, countsDown: true)
        } else {
            Text("Overdue")
        }
    }
}

// GIVEN — sample data for the canvas. Use the preview to check your Lock Screen
// and Dynamic Island layouts without running the app: in the canvas, switch
// between the Lock Screen, compact and expanded presentations.
extension TBTaskActivityAttributes {
    fileprivate static var preview: TBTaskActivityAttributes {
        TBTaskActivityAttributes()
    }
}

extension TBTaskActivityAttributes.ContentState {
    fileprivate static var sample: TBTaskActivityAttributes.ContentState {
        TBTaskActivityAttributes.ContentState(title: "Buy groceries", dueDate: .now.addingTimeInterval(2 * 3600))
    }
}

#Preview("Notification", as: .content, using: TBTaskActivityAttributes.preview) {
   TBTaskWidgetLiveActivity()
} contentStates: {
    TBTaskActivityAttributes.ContentState.sample
}
