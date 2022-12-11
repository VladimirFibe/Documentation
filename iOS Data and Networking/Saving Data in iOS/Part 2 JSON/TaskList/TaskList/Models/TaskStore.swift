import Combine
import Foundation

final class TaskStore: ObservableObject {
    @Published var prioritizedTasks: [PrioritizedTasks] = []
    
    init() {
        loadJSONPrioritizedTasks()
    }
    
    func getIndex(for priority: Task.Priority) -> Int {
        prioritizedTasks.firstIndex { $0.priority == priority }!
    }
    
    private func loadJSONPrioritizedTasks() {
        guard let prioritizedTasksJSONURL = Bundle.main.url(forResource: "PrioritizedTasks", withExtension: "json")
        else { return }
        
        let decoder = JSONDecoder()
        
        do {
            let prioritizedTasksData = try Data(contentsOf: prioritizedTasksJSONURL)
            prioritizedTasks = try decoder.decode([PrioritizedTasks].self, from: prioritizedTasksData)
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }
}

private extension TaskStore.PrioritizedTasks {
    init(priority: Task.Priority, names: [String]) {
        self.init(
            priority: priority,
            tasks: names.map { Task(name: $0) }
        )
    }
}
