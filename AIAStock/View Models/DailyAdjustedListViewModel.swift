//
//  DailyAdjustedListViewModel.swift
//  AIAStock
//
//  Created by Victor Samuel Cuaca on 16/12/20.
//

import Foundation

protocol DailyAdjustedListViewModelDelegate: AnyObject {
    func didUpdateViewModels(error: APIError?)
    func didStartFetching()
}


final class DailyAdjustedListViewModel {
    
    weak var delegate: DailyAdjustedListViewModelDelegate?
    var symbols: [String] = []
    var dailyAdjustedViewModels: [DailyAdjustedViewModel] = []
    var responses: [DailyAdjustedResponse] = []
    var isFetching = false
    var apiError: APIError?
    
    private let alphaVantageAPI: AlphaVantageAPI
    
    
    // MARK: - Init
    
    init(alphaVantageAPI: AlphaVantageAPI = AlphaVantageAPI()) {
        self.alphaVantageAPI = alphaVantageAPI
    }
    
    
    // MARK: - Public Functions
    
    func fetchDailyAdjustedSymbols(completion: ((APIError?) -> Void)? = nil) {
        guard !isFetching else { return }
        
        isFetching = true
        configureInitialState()
        delegate?.didStartFetching()
        
        // Fetch every symbol
        let dispatchGroup = DispatchGroup()
        fetchAllSymbols(with: dispatchGroup)
        
        // Wait until all symbols has been fetched
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let this = self else { return }
            this.isFetching = false
            
            guard let minimumStockDataCount = this.responses.map({ ($0.timeSeriesDaily.stockData.count) }).min() else {
                this.dailyAdjustedViewModels = []
                this.delegate?.didUpdateViewModels(error: this.apiError)
                completion?(this.apiError)
                return
            }
            print("Minimum stock data count: \(minimumStockDataCount)")
            
            this.dailyAdjustedViewModels = this.createDailyAdjustedViewModels(dataCount: minimumStockDataCount)
            this.delegate?.didUpdateViewModels(error: nil)
            completion?(nil)
        }
    }
    
    func isEntryValid(texts: [String?]) -> Bool {
        let symbols = texts.map { $0 ?? "" }
        let filteredSymbol =  symbols.filter{ !$0.isEmpty }
        if filteredSymbol.count >= 2{
            self.symbols = filteredSymbol
            return true
        } else {
            self.symbols = []
            return false
        }
    }
}


// MARK: - Private Functions

extension DailyAdjustedListViewModel {
    
    private func createDailyAdjustedViewModels(dataCount: Int) -> [DailyAdjustedViewModel] {
        var viewModels: [DailyAdjustedViewModel] = []
        
        // Sort the stock data by latest
        for i in 0..<responses.count {
            responses[i].timeSeriesDaily.stockData.sort { $0.dateTime.compare($1.dateTime) == .orderedDescending }
        }
        
        // Loop over every data
        for i in 0..<dataCount {
            
            var stockData: [StockDataDailyAdjusted] = []
            var symbols: [String] = []
            
            for j in 0..<responses.count {  // Create a data pair for every symbol
                stockData.append(responses[j].timeSeriesDaily.stockData[i])
                symbols.append(responses[j].metaData.the2Symbol)
            }
            
            // Debugging purposes
            stockData.enumerated().forEach { print("\($0 + 1). \($1.dateTime)") }
            print("")
            
            // Create view model with those created pairs and append it to the view model array
            viewModels.append(DailyAdjustedViewModel(stockData: stockData, symbols: symbols))
        }
        return viewModels
    }
    
    private func fetchAllSymbols(with dispatchGroup: DispatchGroup) {
        guard !symbols.isEmpty else { return apiError = .failedToDecode }
        
        let outputSize = UserDefaults.standard.getOutputSize()
        
        symbols.forEach { symbol in
            dispatchGroup.enter()

            alphaVantageAPI.fetch(with: .dailyAdjusted(symbol: symbol, outputSize: outputSize)) { [weak self] (result: Result<DailyAdjustedResponse, APIError>) in
                switch result {
                case .success(let response):
                    self?.responses.append(response)
                case .failure(let error):
                    self?.apiError = error
                }
                dispatchGroup.leave()
            }
        }
    }
    
    private func configureInitialState() {
        dailyAdjustedViewModels = []
        responses = []
        apiError = nil
    }
}
