import Foundation

extension TaskStore {
    struct PrioritizedTasks: Codable {
        let priority: Task.Priority
        var tasks: [Task]
    }
}

extension TaskStore.PrioritizedTasks: Identifiable {
    var id: Task.Priority { priority }
}
