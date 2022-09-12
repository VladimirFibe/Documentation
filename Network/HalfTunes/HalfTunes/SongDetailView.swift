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
  @State private var musicImage = UIImage(named: "artwork")!
  
  var body: some View {
    VStack {
      Image(uiImage: musicImage)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .shadow(radius: 10)
      Text("\(self.musicItem.trackName) - \(self.musicItem.artistName)")
      Text(self.musicItem.collectionName)
      if download.isDownloading {
        Text("\(Int(download.downloadedAmount * 100))% downloaded")
      }
      HStack {
        Button<Text>(action: downloadButtonTapped) {
          switch download.state {
          case .waiting: return Text("Download")
          case .downloading: return Text("Pause")
          case .paused: return Text("Resume")
          case .finished: return Text("Listen")
          }
        }
        if download.isDownloading {
          Button(action: download.cancel) {
            Text("Cancel")
          }
        }
      }
    }
    .padding()
    .onAppear(perform: displayAlbumArt)
  }
  func downloadButtonTapped() {
    switch download.state  {
      
    case .waiting:
      guard let previewUrl = musicItem.previewUrl else { return }
      download.fetchSongAtUrl(previewUrl)
    case .downloading:
      download.pause()
    case .paused:
      download.resume()
    case .finished:
      audioPlayer = try! AVAudioPlayer(contentsOf: download.downloadLocation!)
      audioPlayer.play()
    }
  }
  func displayAlbumArt() {
    guard let albumImageUrl = URL(string: musicItem.artwork) else { return }
    let task = URLSession.shared.downloadTask(with: albumImageUrl) { location, response, error in
      guard let location = location,
            let imageData = try? Data(contentsOf: location),
      let image = UIImage(data: imageData) else { return }
              
      DispatchQueue.main.async {
        musicImage = image
      }
    }
    task.resume()
  }
}

struct SongDetailView_Previews: PreviewProvider {
  static let musicItem = MusicItem(id: 192678693, artistName: "Leonard Cohen", trackName: "Hallelujah", collectionName: "The Essential Leonard Cohen", preview: "https://audio-ssl.itunes.apple.com/itunes-assets/Music/16/10/b2/mzm.muynlhgk.aac.p.m4a", artwork: "https://is1-ssl.mzstatic.com/image/thumb/Music/v4/77/17/ab/7717ab31-46f9-48ca-7250-9f565306faa7/source/1000x1000bb.jpg")
  static var previews: some View {
    SongDetailView(musicItem: .constant(musicItem))
  }
}






