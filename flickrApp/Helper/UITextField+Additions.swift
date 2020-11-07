//
//  UITextField+Additions.swift
//  flickrApp
//
//  Created by Yi-Cheng Lin on 2020/11/6.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//	Reference: https://stackoverflow.com/questions/50558613/rxswift-replacement-shouldchangecharactersinrange

import Foundation
import UIKit

func setPreservingCursor(on textField: UITextField) -> (_ newText: String) -> Void {
    return { newText in
        let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: textField.selectedTextRange!.start) + newText.count - (textField.text?.count ?? 0)
        textField.text = newText
        if let newPosition = textField.position(from: textField.beginningOfDocument, offset: cursorPosition) {
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
    }
}
