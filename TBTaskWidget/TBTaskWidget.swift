//
//  TBTaskWidget.swift
//  TBTaskWidget
//
//  Created by Raja Software Labs on 11/08/26.
//

import WidgetKit
import SwiftUI

struct TaskEntry: TimelineEntry {
    let date: Date
    let task: TBTask?
}

struct Provider: TimelineProvider {
    // GIVEN — `placeholder` is the redacted skeleton the system draws while the
    // widget is still loading, so it returns instantly and never touches storage.
    func placeholder(in context: Context) -> TaskEntry {
        TaskEntry(date: .now, task: TBTask(title: "Buy groceries", dueDate: .now.addingTimeInterval(3600)))
    }

    // GIVEN — `getSnapshot` is what the widget gallery previews. Unlike
    // placeholder it may read your real data, so it pulls the current task out
    // of the shared store.
    func getSnapshot(in context: Context, completion: @escaping (TaskEntry) -> Void) {
        Task { @MainActor in
            completion(TaskEntry(date: .now, task: TaskStore.shared.currentTask()))
        }
    }

    // TODO (Widgets 1/3): Choose the reload policy for this timeline.
    //
    // A widget cannot run continuously. You hand the system a list of entries
    // plus a policy telling it when to come back and ask you for more. Reading
    // the task and building the entry is done for you; what is missing is the
    // policy.
    //
    // `.never` below means "do not come back on your own" — which is wrong here
    // on its own, because a due date that has passed would keep showing a stale
    // countdown until something else woke the widget. Replace it with a policy
    // that also refreshes periodically, and explain your choice in a comment.
    //
    // See "Widget Lifecycle" and "WidgetKit Overview" in the training document.
    func getTimeline(in context: Context, completion: @escaping (Timeline<TaskEntry>) -> Void) {
        Task { @MainActor in
            let entry = TaskEntry(date: .now, task: TaskStore.shared.currentTask())

            completion(Timeline(entries: [entry], policy: .never))
        }
    }
}

// GIVEN — the widget's SwiftUI layout is provided; this assignment is about
// WidgetKit, not about laying out a stack.
struct TBTaskWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("TBTask")
                .font(.headline)

            if let task = entry.task {
                Text(task.title)
                    .font(.subheadline)
                    .lineLimit(2)
                Text(task.dueDate.formatted(.dateTime.day().month().hour().minute()))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Text("No task set")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TBTaskWidget: Widget {
    let kind: String = "TBTaskWidget"

    // TODO (Widgets 2/3): Finish configuring the widget.
    //
    // The configuration below works but is bare. Uncomment and complete the
    // lines marked below so that:
    //   a) the entry view gets a widget container background, which the system
    //      requires for the widget to draw correctly on the Home Screen;
    //   b) the widget has a display name and description — these are what the
    //      user reads in the widget gallery when adding it;
    //   c) the widget declares which families it supports.
    //
    // Also add a comment saying why StaticConfiguration is the right choice
    // here rather than AppIntentConfiguration. See "StaticConfiguration vs
    // AppIntentConfiguration" in the training document.
    //
    // This widget must stay READ-ONLY: do not add Button(intent:) or
    // Toggle(intent:) to it.
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TBTaskWidgetEntryView(entry: entry)
                // .containerBackground(<#style#>, for: .widget)
        }
        // .configurationDisplayName(<#name#>)
        // .description(<#description#>)
        // .supportedFamilies([<#families#>])
    }
}

#Preview(as: .systemSmall) {
    TBTaskWidget()
} timeline: {
    TaskEntry(date: .now, task: TBTask(title: "Buy groceries", dueDate: .now.addingTimeInterval(3600)))
    TaskEntry(date: .now, task: nil)
}
