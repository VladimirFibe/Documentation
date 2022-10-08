//: [Previous](@previous)

import Foundation

let favoriteBytes: [UInt8] = [
  240,          159,          152,          184,
  240,          159,          152,          185,
  0b1111_0000,  0b1001_1111,  0b1001_1000,  186,
  0xF0,         0x9F,         0x98,         187
]

MemoryLayout<UInt8>.size * favoriteBytes.count

let faviriteBytesData = Data(favoriteBytes)
let favoriteBytesURL = URL(fileURLWithPath: "Favorite Bytes",
                           relativeTo: FileManager.documentDirectoryURL)
try faviriteBytesData.write(to: favoriteBytesURL)
let savedFavoriteBytesData = try Data(contentsOf: favoriteBytesURL)
let savedFavoriteBytes = Array(savedFavoriteBytesData)

try faviriteBytesData.write(to: favoriteBytesURL.appendingPathExtension("txt"))
let string = String(data: savedFavoriteBytesData, encoding: .utf8) ?? ""

let stringURL = URL(fileURLWithPath: "Cats.txt", relativeTo: FileManager.documentDirectoryURL)
try string.write(to: stringURL, atomically: true, encoding: .utf8)
let savedString = try String(contentsOf: stringURL)
