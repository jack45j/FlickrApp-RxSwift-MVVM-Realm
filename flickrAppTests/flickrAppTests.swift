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

    func testSearchPageViewModel_ButtonEnable() {
		let keywords: TestableObservable<String?> = testScheduler.createHotObservable([
			.next(100, "abc"), .next(500, nil)
		])
		
		let perPages = testScheduler.createHotObservable([
			.next(150, "0"),
			.next(200, "-1"),
			.next(250, "abc"),
			.next(300, "19"),
			.next(350, "-*/_!&#_)$#*(&"),
			.next(400, "🤣🤣🤣"),
			.next(450, "20"),
			.next(550, "0"),
			.next(600, "-1"),
			.next(650, "abc"),
			.next(700, "19"),
			.next(750, "-*/_!&#_)$#*(&"),
			.next(800, "🤣🤣🤣"),
			.next(850, "20")
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
			.next(450, true),
			.next(500, false),
			.next(550, false),
			.next(600, false),
			.next(650, false),
			.next(700, false),
			.next(750, false),
			.next(800, false),
			.next(850, false)
		])
    }
}
