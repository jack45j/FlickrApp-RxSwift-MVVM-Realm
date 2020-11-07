//
//  SearchPageViewController.swift
//  flickrApp
//
//  Created by Yi-Cheng Lin on 2020/11/6.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class SearchPageViewController: UIViewController {
	@IBOutlet weak var keywordTextField: UITextField!
	@IBOutlet weak var perPageTextField: UITextField!
	@IBOutlet weak var searchButton: UIButton!
	
	let disposeBag = DisposeBag()
	var viewModel: SearchPageViewModel! = SearchPageViewModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		bindViewModel()
	}
	
	func bindViewModel() {
		let digitsOnlyPerPage = perPageTextField.rx.text.orEmpty
			.map(digitsOnly)
			.do(onNext: setPreservingCursor(on: perPageTextField))
		
		let viewModelInput = SearchPageViewModel.Input(keywordDidChange: keywordTextField.rx.text,
													   perPageDidChange: digitsOnlyPerPage,
													   searchButtonDidTap: searchButton.rx.tap)
		let viewModelOutput = viewModel.transform(input: viewModelInput)
		
		viewModelOutput.shouldResearchButtonEnable
			.bind(to: searchButton.rx.isEnabled)
			.disposed(by: disposeBag)
		
		viewModelOutput.pushToResultPage
			.subscribe(onNext: { [weak self] _ in
				let vc = self?.storyboard?.instantiateViewController(withIdentifier: "ResultPageVC") as! ResultPageViewController
				
				#warning("Force unwrapped UITextField's text")
				vc.viewModel = ResultPageViewModel(dependencies: .init(keyword: (self?.keywordTextField.text)!,
																	   perPage: Int((self?.perPageTextField.text)!)!))
												
				self?.navigationController?.pushViewController(vc, animated: true)
			})
			.disposed(by: disposeBag)
	}
}

