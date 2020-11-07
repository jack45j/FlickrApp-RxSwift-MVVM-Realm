//
//  RealmFlickrPhoto.swift
//  flickrApp
//
//  Created by Yi-Cheng Lin on 2020/11/7.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import Foundation
import RealmSwift

class RealmFlickrPhoto: Object {
	@objc dynamic var uuid = UUID().uuidString
	@objc dynamic var farm = 0
    @objc dynamic var id = ""
    
    @objc dynamic var isfamily = 0
    @objc dynamic var isfriend = 0
    @objc dynamic var ispublic = 0
    
    @objc dynamic var owner = ""
    @objc dynamic var secret = ""
    @objc dynamic var server = ""
    @objc dynamic var title = ""
}
