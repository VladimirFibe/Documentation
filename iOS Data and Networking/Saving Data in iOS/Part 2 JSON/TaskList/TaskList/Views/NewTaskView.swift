import SwiftUI

struct NewTaskView: View {
    var taskStore: TaskStore
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var text = ""
    @State var priority: Task.Priority = .no
    
    var body: some View {
        Form {
            TextField("Task Name", text: $text)
            
            VStack {
                Text("Priority")
                Picker("Priority", selection: $priority) {
                    ForEach(Task.Priority.allCases) { item in
                        Text(item.rawValue.capitalized)
                            .tag(item)
                    }
                }
                .pickerStyle( SegmentedPickerStyle() )
            }
            
            Button("Add") {
                let priorityIndex = self.taskStore.getIndex(for: self.priority)
                self.taskStore.prioritizedTasks[priorityIndex].tasks.append(
                    Task(name: self.text)
                )
                
                self.presentationMode.wrappedValue.dismiss()
            }
            .disabled(text.isEmpty)
        }
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView(taskStore: TaskStore())
    }
}
