//
//  FlickrPhoto.swift
//  flickrApp
//
//  Created by Yi-Cheng Lin on 2020/11/6.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import Foundation
import RealmSwift

struct FlickrPhoto: Codable, Equatable {
	var realmUUID: String = ""
    let farm: Int
    let id: String
    
    let isfamily: Int
    let isfriend: Int
    let ispublic: Int
    
    let owner: String
    let secret: String
    let server: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case farm
        case id
        
        case isfamily
        case isfriend
        case ispublic
        
        case owner
        case secret
        case server
        case title
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        farm = try container.decode(Int.self, forKey: .farm)
        id = try container.decode(String.self, forKey: .id)
        
        isfamily = try container.decode(Int.self, forKey: .isfamily)
        isfriend = try container.decode(Int.self, forKey: .isfriend)
        ispublic = try container.decode(Int.self, forKey: .ispublic)
        
        owner = try container.decode(String.self, forKey: .owner)
        secret = try container.decode(String.self, forKey: .secret)
        server = try container.decode(String.self, forKey: .server)
        title = try container.decode(String.self, forKey: .title)
    }
	
	init(uuid: String = "", farm: Int = 0, id: String = "", isFamily: Int = 0, isFriend: Int = 0, isPublic: Int = 0, owner: String = "", secret: String = "", server: String = "", title: String = "") {
		self.realmUUID = uuid
		self.farm = farm
		self.id = id
		self.isfamily = isFamily
		self.isfriend = isFriend
		self.ispublic = isPublic
		self.owner = owner
		self.secret = secret
		self.server = server
		self.title = title
	}
	
	var imageURL: String {
		let urlString = String(format: FlickrConstants.imageURL, farm, server, id, secret)
        return urlString
    }
	
	func toRealmFlickPhoto() -> RealmFlickrPhoto {
		let realmPhoto = RealmFlickrPhoto()
		realmPhoto.id = self.id
		realmPhoto.farm = self.farm
		realmPhoto.server = self.server
		realmPhoto.isfamily = self.isfamily
		realmPhoto.isfriend = self.isfriend
		realmPhoto.ispublic = self.ispublic
		realmPhoto.owner = self.owner
		realmPhoto.secret = self.secret
		realmPhoto.title = self.title
		return realmPhoto
	}
	
	static func == (lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
	   return  lhs.farm == rhs.farm &&
			   lhs.id == rhs.id &&
			   lhs.isfamily == rhs.isfamily &&
			   lhs.isfriend == rhs.isfriend &&
			   lhs.ispublic == rhs.ispublic &&
			   lhs.owner == rhs.owner &&
			   lhs.secret == rhs.secret &&
			   lhs.server == rhs.server &&
			   lhs.title == rhs.title
	}
}

