import SwiftUI

class ModalViews: ObservableObject {
    @Published var showShapes = false
    @Published var showDrawingPad = false
}

struct ContentView: View {
    @EnvironmentObject var cellStore: CellStore
    @EnvironmentObject var modalViews: ModalViews
    @State private var sliderValue = 0.0
    @State private var cellShape = CellShape.roundRect
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                BackgroundView(size: geometry.size)
            }
            .onChange(of: cellShape) { shape in
                guard let cell = cellStore.selectedCell else { return }
                cellStore.updateShape(cell: cell, shape: shape)
            }
            .sheet(isPresented: $modalViews.showShapes) {
                ShapeSelectionGrid(selectedCellShape: $cellShape)
            }
            .fullScreenCover(isPresented: $modalViews.showDrawingPad) {
                DrawingPadView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CellStore())
            .environmentObject(ModalViews())
    }
}
