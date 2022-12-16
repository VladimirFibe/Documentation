import SwiftUI
import AVFoundation

// MARK: Song Detail View
struct SongDetailView: View {
    // MARK: Properties
    @ObservedObject private var downloader = SongDownloader()
    @ObservedObject private var mutableDownloader = MutableSongDownloader()
    
    @Binding var musicItem: MusicItem
    @MainActor @State private var artworkImage = UIImage(named: "URLSessionArtwork")!
    @MainActor @State private var downloadProgress: Float = 0
    @MainActor @State private var playMusic = false
    @MainActor @State private var isDownloading = false
    @MainActor @State private var showDownloadingFailedAlert = false
    var buttonTitle: String {
        isDownloading ? "Downloading..." :
        downloader.downloadLocation == nil ? "Download" : "Play"
    }
    // MARK: Body
    var body: some View {
        VStack {
            GeometryReader { reader in
                VStack {
                    Image(uiImage: artworkImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: reader.size.width, height: reader.size.height * 0.2)
                        .shadow(radius: 10)
                    Text(musicItem.trackName)
                    Text(musicItem.artistName)
                    Text(musicItem.collectionName)
                    Spacer()
                    Button<Text>(action: mutableDownloadTapped) {
                        switch mutableDownloader.state {
                        case .downloading: return Text("Pause")
                        case .failed: return Text("Retry")
                        case .finished: return Text("Listen")
                        case .paused: return Text("Resume")
                        case .waiting: return Text("Download")
                        }
                    }
                    if mutableDownloader.state == .paused || mutableDownloader.state == .downloading {
                        ProgressView(value: mutableDownloader.downloadProgress)
                    }
                    Spacer()
                }
            }
        }
        .padding()
        .alert("Download Failed", isPresented: $showDownloadingFailedAlert) {
            Button("Dismiss", role: .cancel) {
                showDownloadingFailedAlert = false
            }
        }
    }
    private func downloadArtwork() async {
        guard let artworkURL = URL(string: musicItem.artwork) else { return }
        do {
            let data = try await downloader.downloadImage(at: artworkURL)
            
            guard let image = UIImage(data: data) else {
                return
            }
            
            artworkImage = image
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
        
    }
    private func downloadTapped() async {
        if downloader.downloadLocation == nil {
            isDownloading = true
            defer {
                isDownloading = false
            }
            guard let previewURL = musicItem.previewURL else { return }
            do {
                try await downloader.downloadSongBytes(at: previewURL, progress: $downloadProgress)
            } catch let error {
                print("DEBUG: \(error.localizedDescription)")
                showDownloadingFailedAlert = true
            }
        } else {
            downloader.playSound()
        }
    }
    
    private func downloadSongTapped() async {
        if downloader.downloadLocation == nil {
            guard let artworkURL = URL(string: musicItem.artwork),
                  let previewURL = musicItem.previewURL
            else { return }
            isDownloading = true
            defer { isDownloading = false }
            
            do {
                let data = try await downloader.download(songAt: previewURL, artworkAt: artworkURL)
                
                guard let image = UIImage(data: data) else { return }
                artworkImage = image
            } catch {
                showDownloadingFailedAlert = true
            }
        } else {
            downloader.playSound()
        }
    }
    
    func mutableDownloadTapped() {
        switch mutableDownloader.state {
        case .paused:
            mutableDownloader.resume()
        case .downloading:
            mutableDownloader.pause()
        case .failed, .waiting:
            guard let previewURL = musicItem.previewURL else { return }
            mutableDownloader.downloadSong(at: previewURL)
        case .finished:
            mutableDownloader.playSound()
        }
    }
}

// MARK: - Preview Provider
struct SongDetailView_Previews: PreviewProvider {
    // MARK: Preview Wrapper
    struct PreviewWrapper: View {
        // MARK: Properties
        @State private var musicItem = MusicItem.sample
        // MARK: Body
        var body: some View {
            SongDetailView(musicItem: $musicItem)
        }
    }
    // MARK: Previews
    static var previews: some View {
        PreviewWrapper()
    }
}
