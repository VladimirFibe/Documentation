import Foundation

// MARK: Playlist
public actor Playlist {
  // MARK: Properties
  public let title: String
  public let author: String
  public private(set) var songs: [String]

  // MARK: Initialization
  public init(title: String, author: String, songs: [String]) {
    self.title = title
    self.author = author
    self.songs = songs
  }

  // MARK: Methods
  public func add(song: String) {
    songs.append(song)
  }

  public func remove(song: String) {
    guard !songs.isEmpty, let index = songs.firstIndex(of: song) else {
      return
    }

    songs.remove(at: index)
  }

  public func move(song: String, from playlist: Playlist) async {
    await playlist.remove(song: song)
    add(song: song)
  }

  public func move(song: String, to playlist: Playlist) async {
    await playlist.add(song: song)
    remove(song: song)
  }
}
