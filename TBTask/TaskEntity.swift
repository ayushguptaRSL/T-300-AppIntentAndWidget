// TaskEntity.swift
import AppIntents

struct TBTaskEntity: AppEntity {
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Task")
    static var defaultQuery = TaskEntityQuery()

    var id: UUID
    var title: String
    var dueDate: Date

    // This is what shows up as the title/subtitle wherever the system displays
    // this task — a Spotlight result row, a Siri response, a Shortcuts variable.
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(title)",
            subtitle: "Due \(dueDate.formatted(.dateTime.day().month()))"
        )
    }

    init(task: TBTask) {
        self.id = task.id
        self.title = task.title
        self.dueDate = task.dueDate
    }
}

// Lets Spotlight index the task so it can appear in system search results.
extension TBTaskEntity: IndexedEntity {}
