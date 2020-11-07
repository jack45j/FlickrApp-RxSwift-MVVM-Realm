//
//  Array+Additions.swift
//  flickrApp
//
//  Created by Yi-Cheng Lin on 2020/11/7.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import Foundation

extension Array where Element == FlickrPhoto {
	
	func queryExistElement(from photo: Element) -> Element? {
		for item in self {
			if 	item == photo {
				return item
			}
		}
		return nil
	}
}
