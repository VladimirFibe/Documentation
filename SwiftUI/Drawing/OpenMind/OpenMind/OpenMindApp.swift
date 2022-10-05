import SwiftUI

@main
struct OpenMindApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(CellStore())
        }
    }
}
