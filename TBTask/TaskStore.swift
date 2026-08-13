// TaskStore.swift
import ActivityKit
import CoreSpotlight
import Foundation
import WidgetKit

@MainActor
@Observable
final class TaskStore {
    static let shared = TaskStore()

    private(set) var task: TBTask?
    private let defaultsKey = "TBTask.task"
    private let appGroupID = "group.raja.software.labs.TBTask"
    private var currentActivity: Activity<TBTaskActivityAttributes>?

    private var defaults: UserDefaults {
        guard let suite = UserDefaults(suiteName: appGroupID) else {
            // Falling back to .standard would silently desync the app from the
            // widget/control extension — better to fail loudly during development
            // than debug a "control taps do nothing" mystery later.
            fatalError("App Group '\(appGroupID)' is not configured on this target's entitlements.")
        }
        return suite
    }

    private init() {
        reload()
        // Reattach to an activity already running from a previous launch so we
        // update/end it instead of starting a duplicate.
        currentActivity = Activity<TBTaskActivityAttributes>.activities.first
    }

    // The widget extension process outlives a single timeline refresh, so
    // TaskStore.shared's `task` would otherwise stay frozen at whatever it
    // was when the process launched. Reload from the App Group store on every
    // read so the widget/Shortcuts queries see what the app last wrote.
    private func reload() {
        if let data = defaults.data(forKey: defaultsKey),
           let saved = try? JSONDecoder().decode(TBTask.self, from: data) {
            task = saved
        } else {
            task = nil
        }
    }

    private func persist() {
        if let task {
            if let data = try? JSONEncoder().encode(task) {
                defaults.set(data, forKey: defaultsKey)
            }
        } else {
            defaults.removeObject(forKey: defaultsKey)
        }
        // TODO (Widgets 3/3): Ask WidgetKit to rebuild the widget's timeline.
        //
        // Saving to the App Group is not enough on its own. The widget extension
        // only rebuilds when the system asks it to, which can be many minutes
        // away — that is why a widget appears stuck on old data. Uncomment the
        // line below and target this widget's kind (see TBTaskWidget.kind)
        // rather than reloading every widget in the app.
        //
        // WidgetCenter.shared.reloadTimelines(ofKind: <#kind#>)
        //
        // See "WidgetKit Overview" in the training document.

        syncLiveActivity()
        updateSpotlightIndex()
    }

    // Conforming TBTaskEntity to IndexedEntity is not enough on its own — it
    // only gives the entity a Spotlight attribute set. Nothing reaches the
    // Spotlight index until the app explicitly hands the entities over, which
    // is what this does. Without it the task is findable in Shortcuts (which
    // enumerates via TaskEntityQuery) but never in system search.
    private func updateSpotlightIndex() {
        let entity = task.map(TBTaskEntity.init)
        Task {
            if let entity {
                try? await CSSearchableIndex.default().indexAppEntities([entity])
            } else {
                // The task is gone, so drop it from system search too —
                // otherwise Spotlight keeps offering a task that no longer exists.
                try? await CSSearchableIndex.default()
                    .deleteAppEntities(ofType: TBTaskEntity.self)
            }
        }
    }

    @discardableResult
    func setTask(title: String, dueDate: Date) -> TBTask {
        let newTask = TBTask(title: title, dueDate: dueDate)
        task = newTask
        persist()
        return newTask
    }

    func currentTask() -> TBTask? {
        reload()
        return task
    }

    func clearTask() {
        task = nil
        persist()
    }

    // The control flow below is written for you. What is missing is the three
    // ActivityKit calls that actually drive the activity; each is marked with a
    // TODO and a commented-out version of the call to uncomment and complete.
    //
    // Starts the Live Activity as soon as a task is set and ends it once it's
    // cleared; while running, setting a new task just refreshes its content.
    // Also called when the app backgrounds, so a task set earlier still gets
    // a Live Activity even if nothing changed right before backgrounding.
    func syncLiveActivity() {
        guard let task else {
            guard let activity = currentActivity else { return }
            currentActivity = nil

            // TODO (Live Activities 1/4): End the running activity.
            //
            // The task is gone, so the activity must not sit on the Lock Screen
            // forever. Choose a dismissal policy and say why in a comment:
            // .immediate removes it at once, .default leaves it up for a while
            // so the user still sees the final state.
            //
            // Task { await activity.end(nil, dismissalPolicy: <#policy#>) }
            //
            // See "Ending a Live Activity" in the training document.

            return
        }

        let content = ActivityContent(
            state: TBTaskActivityAttributes.ContentState(title: task.title, dueDate: task.dueDate),
            staleDate: nil
        )

        if let activity = currentActivity {
            // TODO (Live Activities 2/4): Update the activity that is already
            // running, so the Lock Screen and Dynamic Island show the new task
            // instead of a second activity appearing alongside the first.
            //
            // Task { await activity.update(content) }
            //
            // See "Updating a Live Activity" in the training document.

        } else {
            guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }

            // TODO (Live Activities 3/4): Start a new activity, and keep hold of
            // it in `currentActivity` so the next change updates this one rather
            // than stacking another on top. Activity.request is throwing, so
            // `try?` is enough here.
            //
            // currentActivity = try? Activity.request(
            //     attributes: TBTaskActivityAttributes(),
            //     content: content,
            //     pushType: nil
            // )
            //
            // See "Starting a Live Activity" in the training document.
        }
    }
}
