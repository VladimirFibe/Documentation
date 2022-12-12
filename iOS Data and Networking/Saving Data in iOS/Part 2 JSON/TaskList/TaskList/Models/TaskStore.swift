import Combine
import Foundation

final class TaskStore: ObservableObject {
    @Published var prioritizedTasks: [PrioritizedTasks] = [
        PrioritizedTasks(priority: .high, names: []),
        PrioritizedTasks(priority: .medium, names: []),
        PrioritizedTasks(priority: .low, names: []),
        PrioritizedTasks(priority: .no, names: [])
    ] {
        didSet { saveJSONPrioritizedTasks()}
    }
    
    let tasksJSONURL = URL(fileURLWithPath: "Tasks",
                          relativeTo: FileManager.documentsDirectoryURL).appendingPathExtension("json")
    
    init() {
        loadJSONPrioritizedTasks()
    }
    
    func getIndex(for priority: Task.Priority) -> Int {
        prioritizedTasks.firstIndex { $0.priority == priority }!
    }
    
    private func loadJSONPrioritizedTasks() {
        print(FileManager.documentsDirectoryURL)

        let decoder = JSONDecoder()
        
        do {
            let prioritizedTasksData = try Data(contentsOf: tasksJSONURL)
            prioritizedTasks = try decoder.decode([PrioritizedTasks].self, from: prioritizedTasksData)
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }
    
    private func saveJSONPrioritizedTasks() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let tasksData = try encoder.encode(prioritizedTasks)
            
            try tasksData.write(to: tasksJSONURL, options: .atomic)
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
