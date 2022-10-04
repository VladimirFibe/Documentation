import Combine
import SwiftUI

let minCellSize = CGSize(width: 200, height: 100)
struct Cell: Identifiable, Equatable {
    var id = UUID()
    var color = Color(#colorLiteral(red: 0.247754097, green: 0.0689406991, blue: 0.4423487186, alpha: 1))
    var size = minCellSize
    var offset = CGSize.zero
    var shape = CellShape.allCases.randomElement()
    var text = "New Idea!"
}

class CellStore: ObservableObject {
    @Published var cells = [
        Cell(color: .red, text: "Drawing in SwiftUI"),
        Cell(color: .green, offset: CGSize(width: 100, height: 300), text: "Shapes")
    ]
    
    private func indexOf(cell: Cell) -> Int {
        guard let index = cells.firstIndex(where: { $0.id == cell.id })
        else { fatalError("Cell \(cell) does not exist")}
        return index
    }
}
