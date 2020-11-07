//
//  FlickrSearchResult.swift
//  flickrApp
//
//  Created by Yi-Cheng Lin on 2020/11/6.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import Foundation

struct FlickrSearchResults: Codable {
    let stat: String?
    let photos: FlickrPhotos?
    
    enum CodingKeys: String, CodingKey {
        case stat
        case photos
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        stat = try container.decodeIfPresent(String.self, forKey: .stat)
        photos = try container.decodeIfPresent(FlickrPhotos.self, forKey: .photos)
    }
}
