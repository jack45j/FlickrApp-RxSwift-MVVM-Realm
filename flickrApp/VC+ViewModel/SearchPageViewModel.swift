//
//  SearchPageViewModel.swift
//  flickrApp
//
//  Created by Yi-Cheng Lin on 2020/11/6.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchPageViewModel: ViewModelType {
	struct Input {
		let keywordDidChange: Observable<String?>
		let perPageDidChange: Observable<String>
		let searchButtonDidTap: Observable<Void>
	}
	
	struct Output {
		let shouldResearchButtonEnable: Observable<Bool>
		let pushToResultPage: Observable<Void>
	}
	
	/// ViewModel Dependencies
	///
	typealias Dependencies = Void
	
	/// initializer of ViewModel
	///
	init() {}
	
	func transform(input: SearchPageViewModel.Input) -> SearchPageViewModel.Output {		
		let shouldEnableSearchButton = Observable
			.combineLatest(input.keywordDidChange,
						   input.perPageDidChange)
			.map { !($0.0?.isEmpty ?? false) && !($0.1.isEmpty) && (Int($0.1) ?? 0 >= 20) }
		
		return Output(shouldResearchButtonEnable: shouldEnableSearchButton, pushToResultPage: input.searchButtonDidTap.asObservable())
	}
}
