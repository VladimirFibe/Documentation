import Cocoa

let reminderDataURL = URL(fileURLWithPath: "Reminders",
                          relativeTo: FileManager.documentDirectoryURL)

let stringURL = FileManager.documentDirectoryURL
    .appendingPathComponent("String")
    .appendingPathExtension("txt")

stringURL.path

let challengeString = "Frame"
let challengeURL = URL(fileURLWithPath: challengeString, relativeTo: FileManager.documentDirectoryURL)
    .appendingPathExtension("png")

print(challengeURL.lastPathComponent)

