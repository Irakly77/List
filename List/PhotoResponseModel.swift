//
//  a.swift
//  List
//
//  Created by Irakli Chachava on 05.12.2024.
//

import Foundation
import SwiftData

@Model
class PhotoResponseModel: Identifiable, Codable, ObservableObject {
    let albumId: Int
    let id: Int
    @Attribute(.unique) var title: String
    let url: String
    let thumbnailUrl: String
    
    enum CodingKeys: String, CodingKey {
            case albumId = "albumId"
            case id = "id"
            case title = "title"
            case url = "url"
            case thumbnailUrl = "thumbnailUrl"
        }
    required init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
           albumId = try container.decode(Int.self, forKey: .albumId)
           id = try container.decode(Int.self, forKey: .id)
           title = try container.decode(String.self, forKey: .title)
           url = try container.decode(String.self, forKey: .url)
           thumbnailUrl = try container.decode(String.self, forKey: .thumbnailUrl)
       }
    
    init(albumId: Int, id: Int, title: String, url: String, thumbnailUrl: String) {
        self.albumId = albumId
        self.id = id
        self.title = title
        self.url = url
        self.thumbnailUrl = thumbnailUrl
    }
    
    func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(albumId, forKey: .albumId)
            try container.encode(id, forKey: .id)
            try container.encode(title, forKey: .title)
            try container.encode(url, forKey: .url)
            try container.encode(thumbnailUrl, forKey: .thumbnailUrl)
        }
}
