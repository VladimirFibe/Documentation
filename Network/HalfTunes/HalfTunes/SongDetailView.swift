//
//  SongDetailView.swift
//  HalfTunes
//
//  Created by Vladimir Fibe on 08.09.2022.
//

import SwiftUI
import AVKit

struct AudioPlayer: UIViewControllerRepresentable {
  
  func makeUIViewController(context: Context) -> AVPlayerViewController {
    let player = AVPlayer(url: songUrl)
    let playerViewController = AVPlayerViewController()
    playerViewController.player = player
    playerViewController.entersFullScreenWhenPlaybackBegins = true
    return playerViewController
  }
  
  func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
    //
  }
  
  let songUrl: URL
  
}

struct SongDetailView: View {
  
  @Binding var musicItem: MusicItem
  @State private var playMusic = false
  
  var musicImage: UIImage? = nil
  
  var body: some View {
    VStack {
      GeometryReader { reader in
        VStack {
          Image("artwork")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: reader.size.height / 2)
            .cornerRadius(50)
            .padding()
            .shadow(radius: 10)
          Text("\(self.musicItem.trackName) - \(self.musicItem.artistName)")
          Text(self.musicItem.collectionName)
          Button(action: {}) {
            Text("Download")
          }
        }
      }
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
