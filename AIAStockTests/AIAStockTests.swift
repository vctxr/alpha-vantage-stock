//
//  AIAStockTests.swift
//  AIAStockTests
//
//  Created by Victor Samuel Cuaca on 17/12/20.
//

import XCTest
@testable import AIAStock

class AIAStockTests: XCTestCase {
    
    private var intradayListViewModel: IntradayListViewModel!
    private var dailyAdjustedListViewModel: DailyAdjustedListViewModel!
    
    override func setUp() {
        intradayListViewModel = IntradayListViewModel(alphaVantageAPI: AlphaVantageAPI())
        dailyAdjustedListViewModel = DailyAdjustedListViewModel(alphaVantageAPI: AlphaVantageAPI())
    }
    
    override func tearDown() {
        intradayListViewModel = nil
        dailyAdjustedListViewModel = nil
    }
    
    func testCanStoreStringDataInKeyChain() {
        let string = "testData"
        let data = Data(string.utf8)
        let status = KeyChain.save(key: "TEST_DATA", data: data)
        XCTAssertEqual(status, 0)
    }
    
    func testCanGetStringDataFromKeyChain() {
        let data = KeyChain.load(key: "TEST_DATA")!
        let string = String(decoding: data, as: UTF8.self)
        XCTAssertEqual(string, "testData")
    }
    
    func testCanFetchValidIntradayData() {
        let expectation = self.expectation(description: "fetchIntraday")
        intradayListViewModel.fetchIntraday(symbol: "AAPL") { [self] error in
            expectation.fulfill()
            if error == nil {
                XCTAssert(intradayListViewModel.intradayViewModels.count > 0)
            } else {
                XCTAssertEqual(intradayListViewModel.intradayViewModels.count, 0)
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(intradayListViewModel.isFetching, false)
    }
    
    func testCanFetchInvalidIntradayData() {
        let expectation = self.expectation(description: "fetchIntraday")
        intradayListViewModel.fetchIntraday(symbol: "VICTORSAMUEL") { [self] error in
            expectation.fulfill()
            if error == nil {
                XCTAssert(intradayListViewModel.intradayViewModels.count > 0)
            } else {
                XCTAssertEqual(intradayListViewModel.intradayViewModels.count, 0)
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(intradayListViewModel.isFetching, false)
    }
    
    func testCanFetchValidDailyAdjustedSymbols() {
        let expectation = self.expectation(description: "fetchDailyAdjustedSymbols")
        dailyAdjustedListViewModel.symbols = ["AAPL", "BBCA"]
        dailyAdjustedListViewModel.fetchDailyAdjustedSymbols { [self] error in
            expectation.fulfill()
            if error == nil {
                XCTAssert(dailyAdjustedListViewModel.dailyAdjustedViewModels.count > 0)
            } else {
                XCTAssertEqual(dailyAdjustedListViewModel.dailyAdjustedViewModels.count, 0)
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(dailyAdjustedListViewModel.isFetching, false)
    }
    
    func testCanFetchInvalidDailyAdjustedSymbols() {
        let expectation = self.expectation(description: "fetchDailyAdjustedSymbols")
        dailyAdjustedListViewModel.symbols = ["VICTOR", "SAMUEL", "CUACA"]
        dailyAdjustedListViewModel.fetchDailyAdjustedSymbols { [self] error in
            expectation.fulfill()
            if error == nil {
                XCTAssert(dailyAdjustedListViewModel.dailyAdjustedViewModels.count > 0)
            } else {
                XCTAssertEqual(dailyAdjustedListViewModel.dailyAdjustedViewModels.count, 0)
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(dailyAdjustedListViewModel.isFetching, false)
    }
    
    func testCanFetchEmptyDailyAdjustedSymbols() {
        let expectation = self.expectation(description: "fetchDailyAdjustedSymbols")
        dailyAdjustedListViewModel.symbols = []
        dailyAdjustedListViewModel.fetchDailyAdjustedSymbols { [self] error in
            expectation.fulfill()
            if error == nil {
                XCTAssert(dailyAdjustedListViewModel.dailyAdjustedViewModels.count > 0)
            } else {
                XCTAssertEqual(dailyAdjustedListViewModel.dailyAdjustedViewModels.count, 0)
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(dailyAdjustedListViewModel.isFetching, false)
    }
    
    func testCanValidateEntries() {
        XCTAssertEqual(dailyAdjustedListViewModel.isEntryValid(texts: ["", "", ""]), false)
        XCTAssertEqual(dailyAdjustedListViewModel.isEntryValid(texts: ["AAPL", "", ""]), false)
        XCTAssertEqual(dailyAdjustedListViewModel.isEntryValid(texts: ["AAPL", "BBCA", ""]), true)
        XCTAssertEqual(dailyAdjustedListViewModel.isEntryValid(texts: ["AAPL", "BBCA", "ANTM"]), true)
    }
}
