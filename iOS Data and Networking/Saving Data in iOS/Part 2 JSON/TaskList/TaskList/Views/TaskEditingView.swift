//
//  TaskEditingView.swift
//  TaskList
//
//  Created by Vladimir Fibe on 12/11/22.
//

import SwiftUI

struct TaskEditingView: View {
    @Binding var task: Task
    var body: some View {
        Form {
            TextField("Name", text: $task.name)
            Toggle("Completed", isOn: $task.completed)
        }
        .navigationTitle(task.name)
    }
}

struct TaskEditingView_Previews: PreviewProvider {
    static var previews: some View {
        TaskEditingView(task: .constant(Task(name: "To Do")))
    }
}
