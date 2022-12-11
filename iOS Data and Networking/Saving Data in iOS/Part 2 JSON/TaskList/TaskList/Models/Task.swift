import Foundation

struct Task: Identifiable, Codable {
    let id = UUID()
    
    var name: String
    var completed = false
}
