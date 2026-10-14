// TBTask.swift
import Foundation

struct TBTask: Codable, Hashable {
    // AppEntity requires a stable identifier, so the task carries one even
    // though the app only ever holds a single task at a time.
    var id: UUID = UUID()
    var title: String
    var notes: String
    var dueDate: Date
}
