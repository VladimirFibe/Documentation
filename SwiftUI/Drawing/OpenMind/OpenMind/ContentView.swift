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
    var body: some View {
        ZStack {
            Color(uiColor: .tertiarySystemBackground)
                .ignoresSafeArea()
            VStack {
                Image("Cat")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                    .clipShape(Circle())
                    .overlay {
                        LinearGradient(gradient: gradient, startPoint: .bottom, endPoint: .top)
                            .clipShape(
                                Circle()
                                    .stroke(lineWidth: 16)
                            )
                }
                Text("Ozma")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
