import Foundation

let reminderDataURL = URL(fileURLWithPath: "Reminders",
                          relativeTo: FileManager.documentDirectoryURL)

let stringURL = FileManager.documentDirectoryURL
    .appendingPathComponent("String")
    .appendingPathExtension("txt")

stringURL.path

let challengeString: String
let challengeStringURL: URL

challengeString = "Hello"
//challengeStringURL = URL(fileURLWithPath: challengeString, relativeTo: FileManager.documentDirectoryURL)

challengeStringURL = FileManager.documentDirectoryURL
    .appendingPathComponent(challengeString)
    .appendingPathExtension("txt")

challengeStringURL.lastPathComponent

let favoriteBytes: [UInt8] = [
240, 159, 152, 184,
240, 159, 152, 185,
0b1111_0000, 0b1001_1111, 0b1001_1000, 186,
0xF0, 0x9F, 0x98, 187
]

MemoryLayout<UInt8>.size * favoriteBytes.count

let favoriteBytesData = Data(favoriteBytes)

let favoriteBytesURL = URL(fileURLWithPath: "Favorite Bytes", relativeTo: FileManager.documentDirectoryURL).appendingPathExtension("txt")

try favoriteBytesData.write(to: favoriteBytesURL)
let savedFavoriteBytesData = try Data(contentsOf: favoriteBytesURL)
let savedFavoriteBytes = Array(savedFavoriteBytesData)

favoriteBytes == savedFavoriteBytes

let string = String(data: savedFavoriteBytesData, encoding: .utf8)!

let catsURL = FileManager.documentDirectoryURL
    .appendingPathComponent("Cats")
    .appendingPathExtension("txt")
try string.write(to: catsURL, atomically: true, encoding: .utf8)
let catData = try Data(contentsOf: catsURL)
let catString = String(data: catData, encoding: .utf8)
let catChallengeString = try String(String(contentsOf: catsURL))
