import Foundation

extension Task {
    enum Priority: String, CaseIterable, Identifiable {
      case no, low, medium, high
        
        var id: String { self.rawValue}
    }
  }
