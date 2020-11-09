//
//  flickrAppTests.swift
//  flickrAppTests
//
//  Created by Yi-Cheng Lin on 2020/11/9.
//  Copyright © 2020 Yi-Cheng Lin. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
@testable import flickrApp

class flickrAppTests: XCTestCase {
	
	var viewModel: SearchPageViewModel!
	var disposeBag = DisposeBag()
	var scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
    var testScheduler = TestScheduler(initialClock: 0)
	
    override func setUp() {
		super.setUp()
		self.viewModel = SearchPageViewModel()
    }

    override func tearDown() {
        disposeBag = DisposeBag()
        viewModel = nil
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        testScheduler = TestScheduler(initialClock: 0)
        super.tearDown()
    }

    func testSearchPageViewModel_ButtonEnable_ValidKeyword_InvalidPerPage() {
		let keywords: TestableObservable<String?> = testScheduler.createHotObservable([
			.next(100, "abc")
		])
		
		let perPages = testScheduler.createHotObservable([
			.next(150, "1"),
			.next(200, "0"),
			.next(250, "-1"),
			.next(300, "abc"),
			.next(350, "19"),
			.next(400, "-*/_!&#_)$#*(&"),
			.next(450, "🤣🤣🤣")
		])
		
		let input = SearchPageViewModel.Input(keywordDidChange: keywords.asObservable(),
											  perPageDidChange: perPages.asObservable(),
											  searchButtonDidTap: Observable.empty())
		let output = viewModel.transform(input: input)
		
		let buttonEnable = testScheduler.createObserver(Bool.self)
		output.shouldResearchButtonEnable.bind(to: buttonEnable).disposed(by: disposeBag)
		
		output.shouldResearchButtonEnable
			.map { $0 }
			.subscribe()
			.disposed(by: disposeBag)
		
		testScheduler.start()
		XCTAssertEqual(buttonEnable.events, [
			.next(150, false),
			.next(200, false),
			.next(250, false),
			.next(300, false),
			.next(350, false),
			.next(400, false),
			.next(450, false)
		])
    }
}
