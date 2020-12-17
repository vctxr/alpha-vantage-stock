//
//  IntradayListViewModel.swift
//  AIAStock
//
//  Created by Victor Samuel Cuaca on 16/12/20.
//

import Foundation

protocol IntradayListViewModelDelegate: AnyObject {
    func didUpdateViewModels(error: APIError?)
    func didStartFetching()
}


final class IntradayListViewModel {
    
    weak var delegate: IntradayListViewModelDelegate?
    
    var intradayViewModels: [IntradayViewModel] = []
    var symbol: String = "AAPL"
    var selectedSort: IntradaySort = .latest
    var isFetching: Bool = false {
        didSet {
            if isFetching {
                delegate?.didStartFetching()
            }
        }
    }
    
    private let alphaVantageAPI: AlphaVantageAPI
    
    
    // MARK: - Init
    
    init(alphaVantageAPI: AlphaVantageAPI = AlphaVantageAPI()) {
        self.alphaVantageAPI = alphaVantageAPI
    }
    
    
    // MARK: - Public Functions
    
    func fetchIntraday(symbol: String = "AAPL", completion: ((APIError?) -> Void)? = nil) {
        alphaVantageAPI.task?.cancel()
        
        self.symbol = symbol
        isFetching = true
        let interval = UserDefaults.standard.getInterval()
        let outputSize = UserDefaults.standard.getOutputSize()
        
        alphaVantageAPI.fetch(with: .intraday(symbol: symbol, interval: interval, outputSize: outputSize)) { [weak self] (result: Result<IntradayResponse, APIError>) in
            DispatchQueue.main.async {
                self?.isFetching = false

                switch result {
                case .success(let response):
                    self?.intradayViewModels = response.timeSeries.stockData
                                                .map { IntradayViewModel(stockData: $0, symbol: response.metaData.the2Symbol) }
                                                .sorted { $0.rawDate.compare($1.rawDate) == .orderedDescending }
                        
                    self?.delegate?.didUpdateViewModels(error: nil)
                    completion?(nil)
                case .failure(let error):
                    self?.intradayViewModels = []
                    self?.delegate?.didUpdateViewModels(error: error)
                    completion?(error)
                }
            }
        }
    }
    
    func sortIntraday(by sort: IntradaySort) {
        switch sort {
        case .openHighest:
            intradayViewModels.sort(by: { $0.open.compare($1.open) == .orderedDescending })
        case .openLowest:
            intradayViewModels.sort(by: { $0.open.compare($1.open) == .orderedAscending })
        case .highHighest:
            intradayViewModels.sort(by: { $0.high.compare($1.high) == .orderedDescending })
        case .highLowest:
            intradayViewModels.sort(by: { $0.high.compare($1.high) == .orderedAscending })
        case .lowHighest:
            intradayViewModels.sort(by: { $0.low.compare($1.low) == .orderedDescending })
        case .lowLowest:
            intradayViewModels.sort(by: { $0.low.compare($1.low) == .orderedAscending })
        case .latest:
            intradayViewModels.sort(by: { $0.rawDate.compare($1.rawDate) == .orderedDescending })
        case .oldest:
            intradayViewModels.sort(by: { $0.rawDate.compare($1.rawDate) == .orderedAscending })
        }
        selectedSort = sort
        delegate?.didUpdateViewModels(error: nil)
    }
    
    func clearIntradayViewModels() {
        intradayViewModels = []
        delegate?.didUpdateViewModels(error: nil)
    }
}
