//
//  ImageCollectionViewCell.swift
//  flickrApp
//
//  Created by Yi-Cheng Lin on 2020/11/6.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import UIKit
import RxSwift

class ImageCollectionViewCell: UICollectionViewCell {
	var disposeBag = DisposeBag()
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var imageTitleLabel: UILabel!
	@IBOutlet weak var downloadButton: UIButton!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	override func prepareForReuse() {
		super.prepareForReuse()
		disposeBag = DisposeBag()
	}
}
