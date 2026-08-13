// TBTaskShortcuts.swift
 import AppIntents

 struct TBTaskShortcuts: AppShortcutsProvider {
     static var appShortcuts: [AppShortcut] {
         AppShortcut(
             intent: AddTaskIntent(),
             phrases: [
                 "Add a task in \(.applicationName)",
                 "Create a \(.applicationName) task"
             ],
             shortTitle: "Add Task",
             systemImageName: "plus.circle"
         )
     }
 }
