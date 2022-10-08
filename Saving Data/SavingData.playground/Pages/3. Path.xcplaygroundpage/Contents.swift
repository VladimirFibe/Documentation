import Cocoa

let reminderDataURL = URL(fileURLWithPath: "Reminders",
                          relativeTo: FileManager.documentDirectoryURL)

let stringURL = FileManager.documentDirectoryURL
    .appendingPathComponent("String")
    .appendingPathExtension("txt")

stringURL
