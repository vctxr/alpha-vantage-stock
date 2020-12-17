//
//  ViewController.swift
//  AIAStock
//
//  Created by Victor Samuel Cuaca on 16/12/20.
//

import UIKit

final class IntradayViewController: UIViewController, Alertable {

    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "IntradayTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
            tableView.isScrollEnabled = false
        }
    }
    @IBOutlet var sortByButton: UIButton! {
        didSet {
            sortByButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            sortByButton.layer.shadowColor = UIColor.black.cgColor
            sortByButton.layer.shadowOpacity = 0.2
            sortByButton.layer.shadowRadius = 6
            sortByButton.layer.shadowOffset = CGSize(width: -1, height: 2)
        }
    }
    
    private let viewModel = IntradayListViewModel()
    
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar(placeholder: "Search for symbol", delegate: self)
        navigationItem.searchController?.searchBar.searchTextField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        viewModel.delegate = self
        viewModel.fetchIntraday()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if viewModel.intradayViewModels.isEmpty && !viewModel.isFetching {
            viewModel.fetchIntraday(symbol: viewModel.symbol)
        }
    }
    
    
    // MARK: - Handlers
    
    @IBAction func didTapSort(_ sender: Any) {
        presentAlertSheet(title: "Sort your results by:", message: nil, selectedIndex: viewModel.selectedSort.rawValue) { [weak self] sort in
            self?.viewModel.sortIntraday(by: sort)
        }
    }
    
    @objc private func didChangeText(_ textField: UITextField) {
        textField.text = textField.text?.uppercased()
    }
}


// MARK: - View Model Delegate

extension IntradayViewController: IntradayListViewModelDelegate {
    
    func didUpdateViewModels(error: APIError?) {
        if let error = error {
            print(error)
            tableView.setEmptyMessage(title: "Unable to find stock symbol", subtitle: "Make sure you have a valid API key and haven't reached the daily API call limit.")
            tableView.isScrollEnabled = false
        } else {
            tableView.restore()
            tableView.isScrollEnabled = true
            sortByButton.isHidden = false
        }
        tableView.reloadData()
    }
    
    func didStartFetching() {
        sortByButton.isHidden = true
        tableView.setFetchingState()
    }
}


// MARK: - Search Bar Delegate

extension IntradayViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        viewModel.clearIntradayViewModels()
        viewModel.fetchIntraday(symbol: text)
    }
}


// MARK: - Table View Delegate and Data Source

extension IntradayViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.intradayViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IntradayTableViewCell
        cell.configure(with: viewModel.intradayViewModels[indexPath.row])
        return cell
    }
}
