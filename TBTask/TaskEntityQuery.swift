// TaskEntityQuery.swift
import AppIntents

struct TaskEntityQuery: EntityQuery, EntityStringQuery, EnumerableEntityQuery {

    // Called when the system ALREADY HAS an id and just needs the full object —
    // e.g. resolving the task that AddTaskIntent handed back earlier in a Shortcut.
    func entities(for identifiers: [TBTaskEntity.ID]) async throws -> [TBTaskEntity] {
        await currentEntities().filter { identifiers.contains($0.id) }
    }

    // Called when the system only has TEXT — e.g. Siri heard "the milk task" and
    // needs to search by title to find a match.
    func entities(matching string: String) async throws -> [TBTaskEntity] {
        await currentEntities().filter { $0.title.localizedCaseInsensitiveContains(string) }
    }

    // Tells the system it's allowed to list every task, which is what makes
    // Spotlight indexing possible — it periodically calls this to stay up to date.
    func allEntities() async throws -> [TBTaskEntity] {
        await currentEntities()
    }

    // The app holds at most one task, so "all entities" is either empty or a
    // single element — every query above is just a filter over that.
    private func currentEntities() async -> [TBTaskEntity] {
        guard let task = await TaskStore.shared.currentTask() else { return [] }
        return [TBTaskEntity(task: task)]
    }
}
