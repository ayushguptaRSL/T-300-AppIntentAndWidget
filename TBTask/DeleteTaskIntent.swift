import AppIntents

struct DeleteTaskIntent: AppIntent {
    static var title: LocalizedStringResource = "Delete the current task"
    
    static var parameterSummary: some ParameterSummary {
        Summary()
    }
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        guard let taskDetails = await TaskStore.shared.currentTask() else {
            throw TaskIntentError.taskNotFound
        }

        await TaskStore.shared.clearTask()
        return .result(dialog: "The task \(taskDetails.title) has been deleted")
    }
}
