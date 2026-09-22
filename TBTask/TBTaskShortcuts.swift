// TBTaskShortcuts.swift
 import AppIntents

 struct TBTaskShortcuts: AppShortcutsProvider {
     static var appShortcuts: [AppShortcut] = [
        AppShortcut(
            intent: AddTaskIntent(),
            phrases: [
                "Add a task in \(.applicationName)",
                "Create a \(.applicationName) task"
            ],
            shortTitle: "Add Task",
            systemImageName: "plus.circle"
        ),
        AppShortcut(
           intent: DeleteTaskIntent(),
           phrases: [
               "Delete the task in \(.applicationName)",
               "Remove the task from \(.applicationName)",
               "Clear the task from \(.applicationName)"
            ],
           shortTitle: "Delete task",
           systemImageName: "trash.fill"
        )
     ]
 }
