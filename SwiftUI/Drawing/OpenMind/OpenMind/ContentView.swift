import SwiftUI

struct ContentView: View {                   
    var body: some View {
        GeometryReader { geometry in
            BackgroundView(size: geometry.size)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
