//
//  FavoritePageViewController.swift
//  flickrApp
//
//  Created by Yi-Cheng Lin on 2020/11/7.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class FavoritePageViewController: UIViewController {
	@IBOutlet weak var favoriteCollectionView: UICollectionView!
	
	let viewModel: FavoritePageViewModel! = FavoritePageViewModel()
	let disposeBag = DisposeBag()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Favorite"
		setupImageCollectionViewLayout()
		favoriteCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
		bindViewModel()
    }
	
	func bindViewModel() {
		let viewModelInput = FavoritePageViewModel.Input(shouldUpdateData: self.rx.viewWillAppear.asObservable())
		let viewModelOutput = viewModel.transform(input: viewModelInput)
		
		let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, FlickrPhoto>>(
			configureCell: { ds, collectionView, indexPath, item in
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
				cell.imageView.sd_setImage(with: URL(string: item.imageURL), completed: nil)
				cell.imageTitleLabel.text = item.title
				cell.favoriteButton.isHidden = true
				cell.downloadButton.isHidden = true
				return cell
		})
		
		viewModelOutput.didFetchFavoritePhotosData
			.bind(to: favoriteCollectionView.rx.items(dataSource: dataSource))
			.disposed(by: disposeBag)
	}
	
	func setupImageCollectionViewLayout() {
		let flowLayout = UICollectionViewFlowLayout()
		let size = (favoriteCollectionView.frame.width - 20)
		flowLayout.itemSize = CGSize(width: size, height: size + 60)
		favoriteCollectionView.setCollectionViewLayout(flowLayout, animated: true)
	}
}
