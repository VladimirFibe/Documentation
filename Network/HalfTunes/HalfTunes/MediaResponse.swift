//
//  MediaResponse.swift
//  HalfTunes
//
//  Created by Vladimir Fibe on 12.09.2022.
//

import Foundation

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
