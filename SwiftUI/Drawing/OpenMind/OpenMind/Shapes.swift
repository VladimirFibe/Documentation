import SwiftUI

enum CellShape: CaseIterable {
    case rectangle
    case ellipse
    case capsule
    case diamond
    case chevron
    case heart
    case roundRect
    
    var shape: some Shape {
        switch self {
        case .rectangle: return Rectangle().anyShape()
        case .ellipse: return Ellipse().anyShape()
        case .capsule:
            return Capsule().anyShape()
        case .diamond:
            return Diamond().anyShape()
        case .chevron:
            return Chevron().anyShape()
        case .heart:
            return Heart().anyShape()
        case .roundRect:
            return RoundedRectangle(cornerRadius: 30).anyShape()
        }
    }
}

struct ShapeSelectionGrid: View {
    var body: some View {
        let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(CellShape.allCases, id: \.self) { cellShape in
                cellShape.shape
                    .foregroundColor(Color.accentColor.opacity(0.3))
                    .overlay {
                        cellShape.shape
                            .stroke(style: StrokeStyle(lineWidth: 10, lineJoin: .round))
                            .foregroundColor(.accentColor)
                    }
            }
            .aspectRatio(2, contentMode: .fit)
            .padding()
        }
    }
}
struct Shapes: View {
    var gradient: Gradient {
        let stops: [Gradient.Stop] = [
            .init(color: Color("Violet"), location: 0.0),
            .init(color: .indigo, location: 0.4),
            .init(color: .mint, location: 0.45)
        ]
        return Gradient(stops: stops)
    }
    let strokeStyle = StrokeStyle(lineWidth: 10,
                                  lineCap: .round,
                                  lineJoin: .round,
                                  dash: [50, 20, 10, 20],
                                  dashPhase: 40
    )
    var diamond = CellShape.diamond
    var heart = CellShape.heart
    var body: some View {
        VStack(spacing: 50.0) {
            diamond.shape
                .stroke(style: strokeStyle)
            heart.shape
                .stroke()
        }
        .padding(50)
    }
}

struct AnyShape: Shape {
    func path(in rect: CGRect) -> Path {
        path(rect)
    }
    
    private let path: (CGRect) -> Path
    
    init<T: Shape> (_ shape: T) {
        path = { shape.path(in: $0)}
    }
}
struct Heart: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let flip = CGAffineTransform(translationX: rect.width, y: 0)
            .scaledBy(x: -1, y: 1)
        
        let bottom = CGPoint(x: 0.5 * rect.width, y: rect.height)
        let leftSide = CGPoint(x: 0, y: 0.25 * rect.height)
        let leftTop = CGPoint(x: 0.25 * rect.width, y: 0)
        let midTop = CGPoint(x: 0.5 * rect.width, y: 0.25 * rect.height)
        
        let rightSide = leftSide.applying(flip)
        let rightTop = leftTop.applying(flip)
        
        let sideControl = CGPoint(x: 0, y: 0.75 * rect.height)
        let cornerControl = CGPoint.zero
        let midControl = CGPoint(x: 0.5 * rect.width, y: 0)
        
        path.move(to: bottom)
        path.addCurve(to: leftSide, control1: bottom, control2: sideControl)
        path.addCurve(to: leftTop, control1: leftSide, control2: cornerControl)
        path.addCurve(to: midTop, control1: midControl, control2: midTop)
        path.addCurve(to: rightTop, control1: midTop, control2: midControl)
        path.addCurve(to: rightSide, control1: cornerControl.applying(flip), control2: rightSide)
        path.addCurve(to: bottom, control1: sideControl.applying(flip), control2: bottom)
        return path
    }
}

struct FullHeart: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let bottom = CGPoint(x: 0.5 * rect.width, y: rect.height)
        let leftSide = CGPoint(x: 0, y: 0.25 * rect.height)
        let leftTop = CGPoint(x: 0.25 * rect.width, y: 0)
        let midTop = CGPoint(x: 0.5 * rect.width, y: 0.25 * rect.height)
        let sideControl = CGPoint(x: 0, y: 0.75 * rect.height)
        let cornerControl = CGPoint.zero
        let midControl = CGPoint(x: 0.5 * rect.width, y: 0)
        let flip = CGAffineTransform(translationX: rect.width, y: 0)
            .scaledBy(x: -1, y: 1)
        path.move(to: bottom)
        path.addCurve(to: leftSide, control1: bottom, control2: sideControl)
        path.addCurve(to: leftTop, control1: leftSide, control2: cornerControl)
        path.addCurve(to: midTop, control1: midControl, control2: midTop)
        
        path.addPath(path, transform: flip)
        return path
    }
}
struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addLines([
                CGPoint(x: rect.width / 2, y: 0),
                CGPoint(x: rect.width, y: rect.height / 2),
                CGPoint(x: rect.width / 2, y: rect.height),
                CGPoint(x: 0, y: rect.height / 2)
            ])
            path.closeSubpath()
        }
    }
}

struct Chevron: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addLines([
                CGPoint(x: 0.25 * rect.width, y: 0.5 * rect.height),
                CGPoint(x: 0, y: 0),
                CGPoint(x: 0.75 * rect.width, y: 0),
                CGPoint(x: rect.width, y: 0.5 * rect.height),
                CGPoint(x: 0.75 * rect.width, y: rect.height),
                CGPoint(x: 0, y: rect.height)
            ])
            path.closeSubpath()
        }
    }
}

extension Shape {
    func anyShape() -> AnyShape {
        AnyShape(self)
    }
}

struct Shapes_Previews: PreviewProvider {
    static var previews: some View {
        ShapeSelectionGrid()
    }
}
