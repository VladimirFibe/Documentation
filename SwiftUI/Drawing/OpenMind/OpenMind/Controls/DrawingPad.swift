import SwiftUI

struct DrawingPath: Identifiable, Equatable {
    var id = UUID()
    var path = Path()
    var points: [CGPoint] = []
    var color: Color = .black
    
    mutating func addLine(to point: CGPoint, color: Color) {
        if path.isEmpty {
            path.move(to: point)
            self.color = color
        } else {
            path.addLine(to: point)
        }
        points.append(point)
    }
    
    mutating func smoothLine() {
        path.interpolatePointsWithHermite(interpolationPoints: points)
    }
}
struct DrawingPad: View {
    @State private var livePath = DrawingPath()
    @State private var paths: [DrawingPath] = []
    let lineWidth = 10.0
    var pickedColor: Color = .black
    
    @Binding var savedDrawing: Drawing?
    
    var body: some View {
        
        var drawingSize: CGSize = .zero
        
        let drag = DragGesture(minimumDistance: 0)
            .onChanged { stroke in
                livePath.addLine(to: stroke.location, color: pickedColor)
                livePath.smoothLine()
            }
            .onEnded { stroke in
                livePath.smoothLine()
                if !livePath.path.isEmpty {
                    paths.append(livePath)
                    savedDrawing?.paths.append(livePath)
                    savedDrawing?.size = drawingSize
                }
                livePath = DrawingPath()
            }
        
        let canvas = Canvas { context, size in
            let style = StrokeStyle(
                lineWidth: lineWidth,
                lineCap: .round,
                lineJoin: .round)
            
            for drawingPath in paths {
                context.stroke(
                    drawingPath.path,
                    with: .color(drawingPath.color),
                    style: style)
            }
            
            drawingSize = size
        }
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            canvas
                .gesture(drag)
            
            livePath.path.stroke(livePath.color, lineWidth: lineWidth)
        }
        .task {
            if let savedPaths = savedDrawing?.paths {
                paths.append(contentsOf: savedPaths)
            } else {
                savedDrawing = Drawing(paths: [])
            }
        }
    }
}

struct DrawingPad_Previews: PreviewProvider {
    static var previews: some View {
        DrawingPad(savedDrawing: .constant(nil))
    }
}
