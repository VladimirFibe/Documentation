import Foundation

extension TaskStore {
  struct PrioritizedTasks {
    let priority: Task.Priority
    var tasks: [Task]
  }
}

extension TaskStore.PrioritizedTasks: Identifiable {
  var id: Task.Priority { priority }
}
