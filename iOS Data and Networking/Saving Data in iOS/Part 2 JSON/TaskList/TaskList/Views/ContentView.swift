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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(taskStore: TaskStore())
    }
}
