//
//  SongDetailView.swift
//  HalfTunes
//
//  Created by Vladimir Fibe on 08.09.2022.
//

import SwiftUI
import AVKit

struct SongDetailView: View {
  @ObservedObject var download = SongDownload()
  @Binding var musicItem: MusicItem
  @State private var playMusic = false
  @State var audioPlayer: AVAudioPlayer!
  var musicImage: UIImage? = nil
  
  var body: some View {
    VStack {
      Image("artwork")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .shadow(radius: 10)
      Text("\(self.musicItem.trackName) - \(self.musicItem.artistName)")
      Text(self.musicItem.collectionName)
      Button(action: downloadButtonTapped) {
        Text(download.downloadLocation == nil ? "Download" : "Listen")
      }
    }
    .padding()
  }
  func downloadButtonTapped() {
    if self.download.downloadLocation == nil {
      guard let previewUrl = self.musicItem.previewUrl else { return }
      self.download.fetchSongAtUrl(previewUrl)
    } else {
      audioPlayer = try! AVAudioPlayer(contentsOf: download.downloadLocation!)
      audioPlayer.play()
    }
  }
}

struct SongDetailView_Previews: PreviewProvider {
  static let musicItem = MusicItem(id: 192678693, artistName: "Leonard Cohen", trackName: "Hallelujah", collectionName: "The Essential Leonard Cohen", preview: "https://audio-ssl.itunes.apple.com/itunes-assets/Music/16/10/b2/mzm.muynlhgk.aac.p.m4a", artwork: "https://is1-ssl.mzstatic.com/image/thumb/Music/v4/77/17/ab/7717ab31-46f9-48ca-7250-9f565306faa7/source/1000x1000bb.jpg")
  static var previews: some View {
    SongDetailView(musicItem: .constant(musicItem))
  }
}

struct MediaResponse: Codable{
  var results: [MusicItem]
}

struct MusicItem: Codable, Identifiable  {
  
  let id: Int
  let artistName: String
  let trackName: String
  let collectionName: String
  let preview: String
  let artwork: String
  
  var localFile: URL?
  var isDownloading = false
  var downloadLocation: URL?
  var previewUrl: URL? { URL(string: preview)}
  
  enum CodingKeys: String, CodingKey {
    case id = "trackId"
    case artistName
    case trackName
    case collectionName
    case preview = "previewUrl"
    case artwork = "artworkUrl100"
  }
}

class SongDownload: NSObject, ObservableObject {
  @Published var downloadLocation: URL?
  var downloadTask: URLSessionDownloadTask?
  var downloadUrl: URL?
  
  lazy var urlSession: URLSession = {
    let configuration = URLSessionConfiguration.default
    return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
  }()
  
  func fetchSongAtUrl(_ url: URL) {
    downloadUrl = url
    downloadTask = urlSession.downloadTask(with: url)
    downloadTask?.resume()
  }
}

extension SongDownload: URLSessionDownloadDelegate {
  
  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    if let error = error {
      print("DEBUG: \(error.localizedDescription)")
    }
  }
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    let fileManager = FileManager.default
    guard let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first,
          let lastPathComponent = downloadUrl?.lastPathComponent else { fatalError() }
    let destinationUrl = documentPath.appendingPathComponent(lastPathComponent)
    do {
      if fileManager.fileExists(atPath: destinationUrl.path) {
        try fileManager.removeItem(at: destinationUrl)
      }
      try fileManager.copyItem(at: location, to: destinationUrl)
      DispatchQueue.main.async {
        self.downloadLocation = destinationUrl
      }
    } catch {
      print("DEBUG: \(error.localizedDescription)")
    }
  }
}
