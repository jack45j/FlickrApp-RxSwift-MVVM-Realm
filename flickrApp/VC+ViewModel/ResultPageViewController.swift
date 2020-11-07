//
//  ResultPageViewController.swift
//  flickrApp
//
//  Created by Yi-Cheng Lin on 2020/11/6.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxAlamofire
import SDWebImage
import Photos
import NotificationBannerSwift

class ResultPageViewController: UIViewController {
	@IBOutlet weak var imageCollectionView: UICollectionView!
	
	var disposeBag = DisposeBag()
	var viewModel: ResultPageViewModel!
	
	var shouldDownloadImage: PublishSubject<FlickrPhoto> = PublishSubject()

    override func viewDidLoad() {
        super.viewDidLoad()
		PHPhotoLibrary.requestAuthorization({ _ in })
		setupImageCollectionViewLayout()
		imageCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
		bindViewModel()
	}
	
	func bindViewModel() {
		let isNearBottom = imageCollectionView.rx.contentOffset.throttle(.milliseconds(300), scheduler: MainScheduler.instance).map { _ in self.imageCollectionView.isNearBottomEdge() }
		let viewModelInput = ResultPageViewModel.Input(shouldLoadNextPage: isNearBottom, didTapImageDownloadButton: shouldDownloadImage.asObservable())
		let viewModelOutput = viewModel.transform(input: viewModelInput)
		
		let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, FlickrPhoto>>(
			configureCell: { ds, collectionView, indexPath, item in
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
				cell.imageView.sd_setImage(with: URL(string: item.imageURL), completed: nil)
				cell.imageTitleLabel.text = item.title
				cell.downloadButton.rx.tap
					.map { item }
					.bind(to: self.shouldDownloadImage)
					.disposed(by: cell.disposeBag)
				return cell
		})
		
		viewModelOutput.dataDidUpdate
			.bind(to: imageCollectionView.rx.items(dataSource: dataSource))
			.disposed(by: disposeBag)
		
		viewModelOutput.imageDownloaded
			.subscribe(onNext: { (image, urlString) in
				FloatingNotificationBanner(
					title: "Image Downloaded",
					subtitle: "Image title: \(image.title) has been downloaded from \(urlString)",
					style: .success).show() })
			.disposed(by: disposeBag)
		
		viewModelOutput.appearError
			.subscribe(onNext: {
				FloatingNotificationBanner(
					title: "Error: \($0.localizedDescription)",
					style: .danger).show() })
			.disposed(by: disposeBag)
	}
	
	func setupImageCollectionViewLayout() {
		let flowLayout = UICollectionViewFlowLayout()
		let size = (imageCollectionView.frame.width - 20) / 2
		flowLayout.itemSize = CGSize(width: size, height: size + 60)
		imageCollectionView.setCollectionViewLayout(flowLayout, animated: true)
	}
}