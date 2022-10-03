import SwiftUI

struct ContentView: View {
    var gradient: Gradient {
        let colors: [Color] = [Color("Violet"), .indigo, .mint]
        return Gradient(colors: colors)
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
