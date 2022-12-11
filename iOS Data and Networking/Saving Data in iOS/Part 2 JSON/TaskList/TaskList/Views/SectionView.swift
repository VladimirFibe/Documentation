import SwiftUI

struct SectionView: View {
    @Binding var prioritizedTasks: TaskStore.PrioritizedTasks
    
    var body: some View {
        Section(header: Text("\(prioritizedTasks.priority.rawValue.capitalized) Priority")) {
            ForEach(prioritizedTasks.tasks) { index in
                RowView(task: $prioritizedTasks.tasks[index])
            }
            .onMove { sourceIndices, destinationIndex in
                prioritizedTasks.tasks.move(fromOffsets: sourceIndices, toOffset: destinationIndex)
            }
            .onDelete { indexSet in
                prioritizedTasks.tasks.remove(atOffsets: indexSet)
            }
        }
    }
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionView(prioritizedTasks: .constant(TaskStore.PrioritizedTasks(priority: .low, tasks: [Task(name: "To Do")])))
    }
}
