import SwiftUI

let sharedSession = URLSession.shared
sharedSession.configuration.allowsCellularAccess
sharedSession.configuration.allowsCellularAccess = false
sharedSession.configuration.allowsCellularAccess

let myDefaultConfiguration = URLSessionConfiguration.default
let ephemeralConfiguration = URLSessionConfiguration.ephemeral
let backgroundConfiguration = URLSessionConfiguration.background(withIdentifier: "com.learningAbout.URLSession")

myDefaultConfiguration.allowsCellularAccess
myDefaultConfiguration.allowsCellularAccess = false
myDefaultConfiguration.allowsCellularAccess

myDefaultConfiguration.allowsExpensiveNetworkAccess = true
myDefaultConfiguration.allowsConstrainedNetworkAccess = true

let myDefaultSession = URLSession(configuration: myDefaultConfiguration)
myDefaultSession.configuration.allowsCellularAccess


// iTunes

let configuration = URLSessionConfiguration.default
let session = URLSession(configuration: configuration)

guard let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=starlight") else {
    fatalError("Could not create the URL.")
}
Task {
    let (data, response) = try await session.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode),
          let dataString = String(data: data, encoding: .utf8)
    else { return }
    
    print(httpResponse.statusCode)
    print(dataString)
}
