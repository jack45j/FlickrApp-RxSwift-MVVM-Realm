//
//  ResultPageViewModel.swift
//  flickrApp
//
//  Created by Yi-Cheng Lin on 2020/11/6.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
import RxDataSources
import RealmSwift

class ResultPageViewModel: ViewModelType {
	
	let realm = try! Realm()
	let disposeBag = DisposeBag()
	let images = BehaviorRelay<[FlickrPhoto]>(value: [])
	let downloadedImage = PublishSubject<(FlickrPhoto, String)>()
	let appearError = PublishSubject<Error>()
	
	struct Input {
		let shouldLoadNextPage: Observable<Bool>
		let didTapImageDownloadButton: Observable<FlickrPhoto>
		let didTapImageFavButton: Observable<FlickrPhoto>
	}
	
	struct Output {
		let dataDidUpdate: Observable<[SectionModel<String, FlickrPhoto>]>
		let imageDownloaded: Observable<(FlickrPhoto, String)>
		let appearError: Observable<Error>
		let favoriteListDidChange: BehaviorRelay<[FlickrPhoto]>
	}
	
	typealias Dependencies = SearchCons
	private var dependencies: Dependencies!
	
	init(dependencies: Dependencies) {
		self.dependencies = dependencies
//		try! realm.write {
//			realm.deleteAll()
//		}
		let favPhotos = realm.objects(RealmFlickrPhoto.self)
		self.dependencies.favPhotos.accept(self.dependencies.favPhotos.value + favPhotos.toFlickrPhoto())
	}
	
	func transform(input: ResultPageViewModel.Input) -> ResultPageViewModel.Output {
		
		input.shouldLoadNextPage
			.distinctUntilChanged()
			.debug()
			.filter { $0 }
			.subscribe({ [weak self] _ in self?.fetchNextPageImages() })
			.disposed(by: disposeBag)
			
		input.didTapImageDownloadButton
			.subscribe(onNext: downloadImage)
			.disposed(by: disposeBag)
		
		input.didTapImageFavButton
			.subscribe(onNext: { [weak self] photo in
				let favPhotos = self?.dependencies.favPhotos
				let realm = try! Realm()
				if favPhotos?.value.isContains(photo) ?? false {
					if let realmPhoto = realm.objects(RealmFlickrPhoto.self).queryBy(uuid: favPhotos?.value.queryExistElement(from: photo)?.realmUUID ?? "") {
						try! realm.write {
							realm.delete(realmPhoto)
						}
					}
				} else {
					try! realm.write {
						realm.add(photo.toRealmFlickPhoto())
					}
				}
				
				favPhotos?.accept(realm.objects(RealmFlickrPhoto.self).toFlickrPhoto())
			})
			.disposed(by: disposeBag)
		
		return Output(dataDidUpdate: images.map { [SectionModel(model: "", items: $0)] },
					  imageDownloaded: downloadedImage.asObservable(),
					  appearError: appearError.asObservable(),
					  favoriteListDidChange: self.dependencies.favPhotos)
	}
	
	func downloadImage(photo: FlickrPhoto) {
		RxAlamofire
			.requestData(.get, URL(string: FlickrConstants.imageURL(with: .url_z, farm: photo.farm, server: photo.server, id: photo.id, secret: photo.secret))!)
			.subscribe(onNext: { [weak self] response, data in
				
				// Better to throw data out to controller.
				guard let image = UIImage(data: data) else { return }
				UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
				self?.downloadedImage.onNext((photo, FlickrConstants.imageURL(with: .url_z, farm: photo.farm, server: photo.server, id: photo.id, secret: photo.secret)))
			}, onError: { [weak self] error in
				self?.appearError.onNext(error)
			})
			.disposed(by: disposeBag)
	}
	
	// NEED to refactory for better testability
	@objc func fetchNextPageImages() {
		dependencies.currentPage += 1
		RxAlamofire
			.requestData(.get, URL(string: Endpoint.FlickrApiURL)!,
						parameters: ["api_key": FlickrSecrets.apiKey,
									"method": Endpoint.SearchMethod,
									"format":"json", "nojsoncallback": 1,
									"per_page": dependencies.perPage,
									"page": dependencies.currentPage,
									"text": dependencies.keyword])
			.retry(5)
			.subscribe(onNext: { [weak self] (r, json) in
				do {
					let photos = try JSONDecoder().decode(FlickrSearchResults.self, from: json)
					self?.images.accept((self?.images.value ?? []) + photos.photos!.photo)
				} catch let error as NSError {
					self?.appearError.onNext(error)
					print("Failed to load: \(error.localizedDescription)")
				}
			})
		.	disposed(by: disposeBag)
	}
}

struct SearchCons {
	let keyword: String
	let perPage: Int
	var currentPage: Int = 0
	var favPhotos: BehaviorRelay<[FlickrPhoto]> = .init(value: [])
}
