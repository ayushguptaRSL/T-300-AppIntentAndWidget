// AddTaskIntent.swift
import AppIntents

struct AddTaskIntent: AppIntent {
    static var title: LocalizedStringResource = "Set Due Task"

    @Parameter(title: "Task") var taskTitle: String
    @Parameter(title: "Task Notes") var notes: String
    @Parameter(title: "Due Date") var dueDate: Date

    static var parameterSummary: some ParameterSummary {
        Summary("Set \(\.$taskTitle) with note \(\.$notes) due \(\.$dueDate)")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<TBTaskEntity> & ProvidesDialog {
        let task = await TaskStore.shared.setTask(title: taskTitle, dueDate: dueDate, notes: notes)
        return .result(value: TBTaskEntity(task: task),
                       dialog: "Set \(task.title) as your next due task")
    }
}
