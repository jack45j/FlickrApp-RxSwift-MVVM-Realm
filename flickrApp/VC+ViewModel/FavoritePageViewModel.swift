//
//  FavoritePageViewModel.swift
//  flickrApp
//
//  Created by Yi-Cheng Lin on 2020/11/7.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import RxDataSources

class FavoritePageViewModel: ViewModelType {
	
	let realm = try! Realm()
	let disposeBag = DisposeBag()
	
	struct Input {
		let shouldUpdateData: Observable<Bool>
	}
	
	struct Output {
		let didFetchFavoritePhotosData: Observable<[SectionModel<String, FlickrPhoto>]>
	}
	
	typealias Dependencies = FavoritePhoto
	private var dependencies: Dependencies!
	
	init() {
		self.dependencies = Dependencies()
		self.dependencies.favPhotos.accept(realm.objects(RealmFlickrPhoto.self).toFlickrPhoto())
	}
	
	func transform(input: FavoritePageViewModel.Input) -> FavoritePageViewModel.Output {
		
		input.shouldUpdateData
			.map { [weak self] _ in
				self?.realm.objects(RealmFlickrPhoto.self).toFlickrPhoto().reversed() ?? []
			}
			.bind(to: self.dependencies.favPhotos)
			.disposed(by: disposeBag)
		
		return Output(didFetchFavoritePhotosData: self.dependencies.favPhotos.map { [SectionModel(model: "", items: $0)] }.asObservable())
	}
}

struct FavoritePhoto {
	let favPhotos: BehaviorRelay<[FlickrPhoto]> = .init(value: [])
}
