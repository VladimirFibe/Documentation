import SwiftUI

//let reminderDataURL = URL(fileURLWithPath: "Reminders",
//                          relativeTo: FileManager.documentDirectoryURL)
//
//let stringURL = FileManager.documentDirectoryURL
//    .appendingPathComponent("String")
//    .appendingPathExtension("txt")
//
//stringURL.path
//
//let challengeString: String
//let challengeStringURL: URL
//
//challengeString = "Hello"
////challengeStringURL = URL(fileURLWithPath: challengeString, relativeTo: FileManager.documentDirectoryURL)
//
//challengeStringURL = FileManager.documentDirectoryURL
//    .appendingPathComponent(challengeString)
//    .appendingPathExtension("txt")
//
//challengeStringURL.lastPathComponent
//
//let favoriteBytes: [UInt8] = [
//240, 159, 152, 184,
//240, 159, 152, 185,
//0b1111_0000, 0b1001_1111, 0b1001_1000, 186,
//0xF0, 0x9F, 0x98, 187
//]
//
//MemoryLayout<UInt8>.size * favoriteBytes.count
//
//let favoriteBytesData = Data(favoriteBytes)
//
//let favoriteBytesURL = URL(fileURLWithPath: "Favorite Bytes", relativeTo: FileManager.documentDirectoryURL).appendingPathExtension("txt")
//
//try favoriteBytesData.write(to: favoriteBytesURL)
//let savedFavoriteBytesData = try Data(contentsOf: favoriteBytesURL)
//let savedFavoriteBytes = Array(savedFavoriteBytesData)
//
//favoriteBytes == savedFavoriteBytes
//
//let string = String(data: savedFavoriteBytesData, encoding: .utf8)!
//
//let catsURL = FileManager.documentDirectoryURL
//    .appendingPathComponent("Cats")
//    .appendingPathExtension("txt")
//try string.write(to: catsURL, atomically: true, encoding: .utf8)
//let catData = try Data(contentsOf: catsURL)
//let catString = String(data: catData, encoding: .utf8)
//let catChallengeString = try String(String(contentsOf: catsURL))
// http://157.245.17.10/api/v1/channels.list?query={"u.username":{"$regex":"muragul"}}
//var url = URL(string: "http://157.245.17.10/api/v1/channels.list")
//url?.append(queryItems: [URLQueryItem(name: "u.username", value: [URLQueryItem(name: "$regex", value: "muragul")])])
//print(url) // http://www.google.com/search?q=soccer
let username = "Vladimir123"
let parameters: [String: [String: String]] = [
    "u.username": [
        "$regex": username
    ]
]

do {
    let data = try JSONSerialization.data(withJSONObject: ["u.username": ["$regex": username]], options: .prettyPrinted)
    let jsonString = String(data: data, encoding: .utf8)
    let urlEncodedJson = jsonString!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    let urlString = "http://157.245.17.10/api/v1/channels.list?query=\(urlEncodedJson!)"

    print(urlString)
    // Trigger alaomofire request with url
}
catch  {
    print("DEBUG: \(error.localizedDescription)")
}
