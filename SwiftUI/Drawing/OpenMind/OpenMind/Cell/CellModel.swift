import Combine
import SwiftUI

let minCellSize = CGSize(width: 200, height: 100)

struct Drawing: Equatable {
    var paths: [DrawingPath] = []
    var size = CGSize.zero
}
struct Cell: Identifiable, Equatable {
    var id = UUID()
    var color = Color(#colorLiteral(red: 0.247754097, green: 0.0689406991, blue: 0.4423487186, alpha: 1))
    var size = minCellSize
    var offset = CGSize.zero
    var shape = CellShape.allCases.randomElement()
    var text = "New Idea!"
    var drawing: Drawing?
    
    mutating func update(_ drawing: Drawing) {
        self.drawing = drawing
    }
    mutating func update(_ shape: CellShape) {
        self.shape = shape
    }
}

class CellStore: ObservableObject {
    @Published var selectedCell: Cell?
    @Published var cells = [
        Cell(color: .red, text: "Drawing in SwiftUI"),
        Cell(color: .green, offset: CGSize(width: 100, height: 300), text: "Shapes")
    ]
    
    private func indexOf(cell: Cell) -> Int {
        guard let index = cells.firstIndex(where: { $0.id == cell.id })
        else { fatalError("Cell \(cell) does not exist")}
        return index
    }
    
    func addCell(offset: CGSize) -> Cell {
        let cell = Cell(offset: offset)
        cells.append(cell)
        return cell
    }
    
    func delete(_ cell: Cell?) {
        guard let cell else { return }
        if selectedCell == cell {
            selectedCell = nil
        }
        cells.removeAll { $0.id == cell.id }
    }
    
    func updateShape(cell: Cell, shape: CellShape) {
        let index = indexOf(cell: cell)
        cells[index].update(shape)
    }
    
    func updateDrawing(cell: Cell, drawing: Drawing) {
        let index = indexOf(cell: cell)
        cells[index].update(drawing)
    }
}
