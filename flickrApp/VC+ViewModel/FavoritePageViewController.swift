//
//  FavoritePageViewController.swift
//  flickrApp
//
//  Created by Yi-Cheng Lin on 2020/11/7.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import UIKit

class FavoritePageViewController: UIViewController {
	@IBOutlet weak var favoriteCollectionView: UICollectionView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		imageCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
		
		
		
    }
	
	func setupImageCollectionViewLayout() {
		let flowLayout = UICollectionViewFlowLayout()
		let size = (favoriteCollectionView.frame.width - 20)
		flowLayout.itemSize = CGSize(width: size, height: size + 60)
		favoriteCollectionView.setCollectionViewLayout(flowLayout, animated: true)
	}
}
