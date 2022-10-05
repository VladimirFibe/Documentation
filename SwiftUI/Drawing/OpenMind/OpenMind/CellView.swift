import SwiftUI

struct CellView: View {
    let cell: Cell
    @State private var text = ""
    @FocusState var textFieldIsFocused: Bool
    @EnvironmentObject var cellStore: CellStore
    var isSelected: Bool {
        cell == cellStore.selectedCell
    }
    
    var body: some View {
        
        
        ZStack {
            cell.shape?.shape
                .foregroundColor(Color(uiColor: .systemBackground))
            
            TimelineView(.animation(minimumInterval: 0.2)) { context in
                StrokeView(cell: cell, isSelected: isSelected, date: context.date)
            }
            TextField("Enter cell text", text: $text)
                .padding()
                .multilineTextAlignment(.center)
                .focused($textFieldIsFocused)
        }
        .frame(width: cell.size.width, height: cell.size.height)
        .offset(cell.offset)
        .onAppear { text = cell.text }
        .onChange(of: isSelected, perform: { isSelected in
            if !isSelected { textFieldIsFocused = false}
        })
        .onTapGesture { cellStore.selectedCell = cell }
    }
}

extension CellView {
    struct StrokeView: View {
        let cell: Cell
        let isSelected: Bool
        let date: Date
        @State var dashPhase = 0.0
        
        var body: some View {
            let basicStyle = StrokeStyle(lineWidth: 5, lineJoin: .round)
            let selectedStyle = StrokeStyle(
                lineWidth: 7,
                lineCap: .round,
                lineJoin: .round,
                dash: [50, 15, 30, 15, 15, 15, 5, 10, 5, 15],
                dashPhase: dashPhase)
            cell.shape?.shape
                .stroke(
                    cell.color.opacity(isSelected ? 0.8 : 1),
                    style: isSelected ? selectedStyle : basicStyle
                )
                .onChange(of: date, perform: { _ in
                    #warning("подумать стоит ли добавить withAnimation")
                    dashPhase += 8
                })
        }
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(cell: Cell())
            .previewLayout(.sizeThatFits)
            .padding(20)
            .environmentObject(CellStore())
    }
}
