import SwiftUI

struct CellView: View {
    @EnvironmentObject var cellStore: CellStore
    @EnvironmentObject var modalViews: ModalViews
    
    @FocusState var textFieldIsFocused: Bool
    @State private var text = ""
    @State private var offset: CGSize = .zero
    @State private var currentOffset: CGSize = .zero
    
    let cell: Cell
    var isSelected: Bool {
        cell == cellStore.selectedCell
    }
    
    var body: some View {
        let flyoutMenu = FlyoutMenu(options: setupOptions())
        let drag = DragGesture()
            .onChanged { value in
                offset = currentOffset + value.translation
            }
            .onEnded { value in
                offset = currentOffset + value.translation
                currentOffset = offset
            }
        ZStack {
            ZStack {
                cell.shape?.shape
                    .foregroundColor(Color(uiColor: .systemBackground))
                
                TimelineView(.animation(minimumInterval: 0.2)) { context in
                    StrokeView(cell: cell, isSelected: isSelected, date: context.date)
                }
                
                if let drawing = cell.drawing {
                    DrawingView(drawing: drawing, size: cell.size)
                        .scaleEffect(0.8)
                } else {
                    TextField("Enter cell text", text: $text)
                        .padding()
                        .multilineTextAlignment(.center)
                        .focused($textFieldIsFocused)
                }
                
            }
            .frame(width: cell.size.width, height: cell.size.height)
            if isSelected {
                flyoutMenu
                    .offset(x: cell.size.width / 2,
                            y: -cell.size.height / 2)
            }
        }
        .offset(cell.offset + offset)
        .onAppear { text = cell.text }
        .onChange(of: isSelected, perform: { isSelected in
            if !isSelected { textFieldIsFocused = false}
        })
        .onTapGesture { cellStore.selectedCell = cell }
        .simultaneousGesture(drag)
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

extension CellView {
    func setupOptions() -> [FlyoutMenu.Option] {
        let options: [FlyoutMenu.Option] = [
            .init(image: .init(systemName: "trash"), color: .blue) {
                cellStore.delete(cell)
            },
            .init(image: .init(systemName: "square.on.circle"), color: .green) {
                modalViews.showShapes.toggle()
            },
            .init(image: .init("crayon"), color: .teal) {
                modalViews.showDrawingPad.toggle()
            },
            .init(image: .init(systemName: "flame"), color: .red),
            .init(image: .init(systemName: "link"), color: .purple)
        ]
        return options
    }
}

extension CellView {
    struct DrawingView: View {
        let drawing: Drawing
        let size: CGSize
        
        var body: some View {
            let scaleFactor = drawing.size.scaleFactor(toFit: size)
            Canvas { context, size in
                context.scaleBy(x: scaleFactor, y: scaleFactor)
                for path in drawing.paths {
                    let style = StrokeStyle(lineWidth: 5,
                                            lineCap: .round,
                                            lineJoin: .round)
                    context.stroke(path.path,
                                   with: .color(path.color),
                                   style: style)
                }
            }
            .aspectRatio(drawing.size, contentMode: .fit)
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
