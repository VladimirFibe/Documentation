import SwiftUI

struct ContentView: View {
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
    var body: some View {
        VStack(spacing: 50.0) {
            Path { path in
                path.move(to: .zero)
                path.addLine(to: CGPoint(x: 300, y: 200))
            }
            .stroke(style: strokeStyle)
            Diamond()
                .stroke(style: strokeStyle)
            Chevron()
                .stroke(lineWidth: 10)
        }
        .padding(50)
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
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
