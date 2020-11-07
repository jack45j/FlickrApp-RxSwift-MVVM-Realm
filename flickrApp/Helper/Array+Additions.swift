//
//  Array+Additions.swift
//  flickrApp
//
//  Created by Yi-Cheng Lin on 2020/11/7.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import Foundation

extension Array where Element == FlickrPhoto {
	func isContains(_ photo: Element) -> Bool {
		self.contains(where: {
			$0.farm == photo.farm &&
			$0.id == photo.id &&
			$0.isfamily == photo.isfamily &&
			$0.isfriend == photo.isfriend &&
			$0.ispublic == photo.ispublic &&
			$0.owner == photo.owner &&
			$0.secret == photo.secret &&
			$0.server == photo.server &&
			$0.title == photo.title
		}) }
	
	func queryExistElement(from photo: Element) -> Element? {
		for item in self {
			if 	item.farm == photo.farm &&
				item.id == photo.id &&
				item.isfamily == photo.isfamily &&
				item.isfriend == photo.isfriend &&
				item.ispublic == photo.ispublic &&
				item.owner == photo.owner &&
				item.secret == photo.secret &&
				item.server == photo.server &&
				item.title == photo.title {
				return item
			}
		}
		return nil
	}
}
