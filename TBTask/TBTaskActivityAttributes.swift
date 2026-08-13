// TBTaskActivityAttributes.swift
import ActivityKit
import Foundation

struct TBTaskActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var title: String
        var dueDate: Date
    }
}
