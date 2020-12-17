//
//  SettingsViewController.swift
//  AIAStock
//
//  Created by Victor Samuel Cuaca on 16/12/20.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var outputSizeSwitch: UISwitch!
    @IBOutlet var apiKeyField: UITextField!
    
    private let intervals: [DataPointInterval] = DataPointInterval.allCases
    
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureIntervalPicker()
        configureOutputSizeSwitch()
        configureAPIKeyTextField()
    }
    
    
    // MARK: - Handlers
    
    @IBAction func didTapFullOutputSize(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.setOutputSize(outputSize: .full)
        } else {
            UserDefaults.standard.setOutputSize(outputSize: .compact)
        }
    }
    
    
    // MARK: - Helper Functions
    
    private func configureIntervalPicker() {
        let interval = UserDefaults.standard.getInterval()
        if let index = intervals.firstIndex(where: { $0 == interval }) {
            pickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    private func configureOutputSizeSwitch() {
        let outputSize = UserDefaults.standard.getOutputSize()
        switch outputSize {
        case .compact:
            outputSizeSwitch.setOn(false, animated: false)
        case .full:
            outputSizeSwitch.setOn(true, animated: false)
        }
    }
    
    private func configureAPIKeyTextField() {
        apiKeyField.addDoneToolbar()
        apiKeyField.delegate = self
        if let data = KeyChain.load(key: "API_KEY") {
            let apiKey = String(decoding: data, as: UTF8.self)
            apiKeyField.text = apiKey
        }
    }
}


// MARK: - Text Field Delegate

extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let text = textField.text ?? ""
        let status = KeyChain.save(key: "API_KEY", data: Data(text.utf8))
        print("Status: \(status)")
    }
}


// MARK: - Picker View Delegate and Data Source

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return intervals.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch intervals[row] {
        case .oneMin:
            return "1 min"
        case .fiveMin:
            return "5 min"
        case .fifteenMin:
            return "15 min"
        case .thirtyMin:
            return "30 min"
        case .sixtyMin:
            return "60 min"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.setInterval(interval: intervals[row])
    }
}
