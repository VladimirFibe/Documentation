import SwiftUI

struct ContentView: View {
    var body: some View {
        SongDetailView(musicItem: .constant(MusicItem.sample))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
