import SwiftUI

struct ContentView: View {
    @ObservedObject var taskStore: TaskStore
    @State var modalIsPresented = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(taskStore.prioritizedTasks) { index in
                    SectionView(prioritizedTasks: $taskStore.prioritizedTasks[index])
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Tasks")
            .toolbarRole(.navigationStack)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        modalIsPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $modalIsPresented) {
            NewTaskView(taskStore: taskStore)
        }
        .onAppear {
            loadJSON()
        }
    }
    private func loadJSON() {
        guard let tasksJSONURL = Bundle.main.url(forResource: "Tasks",
                                                withExtension: "json"),
              let prioritizedTasksJSONURL = Bundle.main.url(forResource: "PrioritizedTasks", withExtension: "json") else { return }
        
        let decoder = JSONDecoder()
        
        do {
            let tasksData = try Data(contentsOf: tasksJSONURL)
            let prioritizedTasksData = try Data(contentsOf: prioritizedTasksJSONURL)
            let tasks = try decoder.decode([Task].self, from: tasksData)
            let prioritizedTasks = try decoder.decode([TaskStore.PrioritizedTasks].self, from: prioritizedTasksData)
            print("DEBUG: \(tasks)")
            print("DEBUG: \(prioritizedTasks)")
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(taskStore: TaskStore())
    }
}
