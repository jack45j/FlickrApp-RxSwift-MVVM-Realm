//
//  String+Additions.swift
//  flickrApp
//
//  Created by Yi-Cheng Lin on 2020/11/6.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//	Reference: https://stackoverflow.com/questions/50558613/rxswift-replacement-shouldchangecharactersinrange

import Foundation

func digitsOnly(_ text: String) -> String {
    return text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
}
