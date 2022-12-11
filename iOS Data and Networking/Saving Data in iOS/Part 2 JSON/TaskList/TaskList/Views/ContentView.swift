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
        guard let taskJSONURL = Bundle.main.url(forResource: "Task",
                                                withExtension: "json"),
              let prioritizedTaskJSONURL = Bundle.main.url(forResource: "PrioritizedTask", withExtension: "json") else { return }
        
        let decoder = JSONDecoder()
        
        do {
            let taskData = try Data(contentsOf: taskJSONURL)
            let prioritizedTaskData = try Data(contentsOf: prioritizedTaskJSONURL)
            let task = try decoder.decode(Task.self, from: taskData)
            let prioritizedTask = try decoder.decode(TaskStore.PrioritizedTasks.self, from: prioritizedTaskData)
            let dataAsString = String(data: taskData, encoding: .utf8) ?? ""
            print("DEBUG: \(task)")
            print("DEBUG: \(prioritizedTask)")
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
