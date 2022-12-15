import SwiftUI
import AVFoundation

final class SongDownloader: ObservableObject {
    enum SongDownloaderError: Error {
        case invalidResponse
        case documentDirectoryError
        case failedToStoreSong
    }
    enum ArtworkDownloadError: Error {
        case invalidResponse
        case failedToDownloadArtwork
    }
    @Published var downloadLocation: URL?
    var player: AVAudioPlayer?
    private let session: URLSession
    private let sessionConfiguration: URLSessionConfiguration
    
    init() {
        self.sessionConfiguration = URLSessionConfiguration.default
        self.session = URLSession(configuration: sessionConfiguration)
    }
    
    func playSound() {
        do {
            player = try AVAudioPlayer(contentsOf: downloadLocation!)
            player?.play()
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }
    func downloadImage(at url: URL) async throws -> Data {
        let (downloadURL, response) = try await session.download(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ArtworkDownloadError.invalidResponse
        }
        
        do {
            return try Data(contentsOf: downloadURL)
        } catch {
            throw ArtworkDownloadError.failedToDownloadArtwork
        }
        
    }
    
    func downloadSong(at url: URL) async throws {
        let (downloadURL, response) = try await session.download(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            throw SongDownloaderError.invalidResponse
        }
        
        let fileManager = FileManager.default
        guard let documentPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        else {
            throw SongDownloaderError.documentDirectoryError
        }
        
        let lastPathComponent = url.lastPathComponent
        let destinationURL = documentPath.appendingPathComponent(lastPathComponent)
        
        do {
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            
            try fileManager.copyItem(at: downloadURL, to: destinationURL)
            
            await MainActor.run {
                downloadLocation = destinationURL
            }
        } catch {
            throw SongDownloaderError.failedToStoreSong
        }
    }
    
    func downloadSongBytes(at url: URL, progress: Binding<Float>) async throws {
        let (asyncBytes, response) = try await session.bytes(from: url)
        
        let contentLength = Float(response.expectedContentLength)
        
        var data = Data(capacity: Int(contentLength))
        
        for try await byte in asyncBytes {
            data.append(byte)
            
            let currentProgress = Float(data.count) / contentLength
            
            if Int(progress.wrappedValue * 100) != Int(currentProgress * 100) {
                progress.wrappedValue = currentProgress
            }
        }
        
        let fileManager = FileManager.default
        
        guard let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw SongDownloaderError.documentDirectoryError
        }
        
        let lastPathComponent = url.lastPathComponent
        let destinationURL = documentsPath.appendingPathComponent(lastPathComponent)
        
        do {
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            try data .write(to: destinationURL)
            
            await MainActor.run {
                downloadLocation = destinationURL
            }
        } catch {
            throw SongDownloaderError.failedToStoreSong
        }
    }
}
