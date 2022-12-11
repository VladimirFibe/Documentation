import Foundation

extension Task {
    enum Priority: String, CaseIterable, Identifiable, Codable {
      case no, low, medium, high
        
        var id: String { self.rawValue}
    }
  }
