import SwiftUI

struct ContentView: View {
    @EnvironmentObject var cellStore: CellStore
    @State private var sliderValue = 0.0
    var body: some View {
        VStack {
            VStack {
                Text(String(format: "%.2f", sliderValue))
                ColorSlider(sliderValue: $sliderValue,
                            range: 0...255,
                            color: cellStore.selectedCell?.color ?? .blue
                )
            }
            .padding()
            .frame(height: 80)
            GeometryReader { geometry in
                BackgroundView(size: geometry.size)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CellStore())
    }
}
