//
//  FlickrSecrets.swift
//  flickrApp
//
//  Created by Yi-Cheng Lin on 2020/11/6.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import Foundation

// Better to store key and scret in plist file.
// DO NOT store secret data in source code.
#warning("Secret Data sorage in source code is NOT safe.")
enum FlickrSecrets {
	static let apiKey = "7580c0c8f9ec17495e2c4ff274a7139d"
	static let secret = "d4203c7a6ef31d5d"
}
