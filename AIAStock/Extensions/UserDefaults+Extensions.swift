//
//  UserDefaults+Extensions.swift
//  AIAStock
//
//  Created by Victor Samuel Cuaca on 17/12/20.
//

import Foundation

extension UserDefaults {
    
    // Enum for user defaults key to make reduce "stringly" typed keys which are unsafe.
    private enum UserDefaultsKey: String {
        case interval
        case outputSize
    }
    
    func setInterval(interval: DataPointInterval) {
        setValue(interval.rawValue, forKey: UserDefaultsKey.interval.rawValue)
    }
    
    func getInterval() -> DataPointInterval {
        return DataPointInterval(rawValue: string(forKey: UserDefaultsKey.interval.rawValue) ?? "1min") ?? .oneMin
    }
    
    func setOutputSize(outputSize: OutputSize) {
        setValue(outputSize.rawValue, forKey: UserDefaultsKey.outputSize.rawValue)
    }
    
    func getOutputSize() -> OutputSize {
        return OutputSize(rawValue: string(forKey: UserDefaultsKey.outputSize.rawValue) ?? "compact") ?? .compact
    }
}
