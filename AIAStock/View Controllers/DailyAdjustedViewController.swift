//
//  DailyAdjustedViewController.swift
//  AIAStock
//
//  Created by Victor Samuel Cuaca on 16/12/20.
//

import UIKit

class DailyAdjustedViewController: UIViewController {

    @IBOutlet var firstSymbolField: UITextField!
    @IBOutlet var secondSymbolField: UITextField!
    @IBOutlet var thirdSymbolField: UITextField!
    @IBOutlet var compareButton: UIButton!
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "DailyAdjustedTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        }
    }
    
    private var isCompareButtonActive: Bool = false {
        didSet {
            if isCompareButtonActive {
                compareButton.isEnabled = true
                compareButton.alpha = 1
            } else {
                compareButton.isEnabled = false
                compareButton.alpha = 0.65
            }
        }
    }
    
    private let viewModel = DailyAdjustedListViewModel()
    
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        viewModel.delegate = self
        tableView.setEmptyMessage(title: "No comparison", subtitle: "You can compare up to 3 symbols at a time.")
    }
    
    
    // MARK: - Handlers
    
    @IBAction func didTapCompare(_ sender: Any) {
        viewModel.fetchDailyAdjustedSymbols()
    }
    
    @objc private func didChangeText(_ textField: UITextField) {
        if viewModel.isEntryValid(texts: [firstSymbolField.text, secondSymbolField.text, thirdSymbolField.text]) {
            isCompareButtonActive = true
        } else {
            isCompareButtonActive = false
        }
    }
    
    
    // MARK: - Helper Functions
    
    private func setupTextFields() {
        firstSymbolField.delegate = self
        secondSymbolField.delegate = self
        thirdSymbolField.delegate = self
        
        firstSymbolField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        secondSymbolField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
        thirdSymbolField.addTarget(self, action: #selector(didChangeText), for: .editingChanged)

        firstSymbolField.addDoneToolbar()
        secondSymbolField.addDoneToolbar()
        thirdSymbolField.addDoneToolbar()
    }
}


// MARK: - View Model Delegate

extension DailyAdjustedViewController: DailyAdjustedListViewModelDelegate {
    
    func didUpdateViewModels(error: APIError?) {
        if let error = error {
            print(error)
            tableView.setEmptyMessage(title: "Unable to find stock symbols", subtitle: "Make sure you have a valid API key and haven't reached the daily API call limit.")
        } else {
            tableView.restore()
        }
        
        isCompareButtonActive = true
        tableView.reloadData()
    }
    
    func didStartFetching() {
        view.endEditing(true)
        isCompareButtonActive = false
        tableView.setFetchingState()
    }
}


// MARK: - Table View Delegate and Data Source

extension DailyAdjustedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dailyAdjustedViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DailyAdjustedTableViewCell
        cell.configure(with: viewModel.dailyAdjustedViewModels[indexPath.row])
        return cell
    }
}


// MARK: - Text Field Delegate

extension DailyAdjustedViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstSymbolField:
            secondSymbolField.becomeFirstResponder()
        case secondSymbolField:
            thirdSymbolField.becomeFirstResponder()
        case thirdSymbolField:
            thirdSymbolField.resignFirstResponder()
            viewModel.fetchDailyAdjustedSymbols()
        default:
            break
        }
        return true
    }
}
