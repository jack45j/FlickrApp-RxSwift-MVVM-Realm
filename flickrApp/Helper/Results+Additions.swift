//
//  Results+Additions.swift
//  flickrApp
//
//  Created by Yi-Cheng Lin on 2020/11/7.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import Foundation
import RealmSwift

extension Results where Element == RealmFlickrPhoto {
	func toFlickrPhoto() -> [FlickrPhoto] {
		return self.map { realmPhoto in
			return FlickrPhoto(uuid: realmPhoto.uuid,
							   farm: realmPhoto.farm,
							   id: realmPhoto.id,
							   isFamily: realmPhoto.isfamily,
							   isFriend: realmPhoto.isfriend,
							   isPublic: realmPhoto.ispublic,
							   owner: realmPhoto.owner,
							   secret: realmPhoto.secret,
							   server: realmPhoto.server,
							   title: realmPhoto.title)
		}
	}
	
	func queryBy(uuid: String) -> RealmFlickrPhoto? { return self.filter("uuid == '\(uuid)'").first }
}
