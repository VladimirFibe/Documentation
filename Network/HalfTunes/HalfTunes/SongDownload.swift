//
//  SongDownload.swift
//  HalfTunes
//
//  Created by Vladimir Fibe on 12.09.2022.
//

import Foundation
class SongDownload: NSObject, ObservableObject {
  @Published var downloadLocation: URL?
  @Published var downloadedAmount: Float = 0
  @Published var state = DownloadState.waiting
  
  enum DownloadState {
    case waiting
    case downloading
    case paused
    case finished
  }
  
  var downloadTask: URLSessionDownloadTask?
  var downloadUrl: URL?
  var resumeData: Data?
  var isDownloading: Bool { state == .downloading || state == .paused }
  lazy var urlSession: URLSession = {
    let configuration = URLSessionConfiguration.default
    return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
  }()
  
  func fetchSongAtUrl(_ url: URL) {
    downloadUrl = url
    downloadTask = urlSession.downloadTask(with: url)
    downloadTask?.resume()
    state = .downloading
  }
  
  func cancel() {
    state = .waiting
    downloadTask?.cancel()
    DispatchQueue.main.async {
      self.downloadedAmount = 0
    }
  }
  
  func pause() {
    downloadTask?.cancel(byProducingResumeData: { data in
      DispatchQueue.main.async {
        self.resumeData = data
        self.state = .paused
      }
    })
  }
  
  func resume() {
    guard let resumeData = resumeData else { return }
    downloadTask = urlSession.downloadTask(withResumeData: resumeData)
    downloadTask?.resume()
    state = .downloading
  }
}

extension SongDownload: URLSessionDownloadDelegate {
  func urlSession(_ session: URLSession,
                  downloadTask: URLSessionDownloadTask,
                  didWriteData bytesWritten: Int64,
                  totalBytesWritten: Int64,
                  totalBytesExpectedToWrite: Int64) {
    DispatchQueue.main.async {
      self.downloadedAmount = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
      print(self.downloadedAmount)
    }
  }
  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    if let error = error {
      print("DEBUG: \(error.localizedDescription)")
    } else {
      DispatchQueue.main.async {
        self.state = .finished
      }
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
        self.state = .finished
      }
    } catch {
      print("DEBUG: \(error.localizedDescription)")
    }
  }
}
