//
//  Alertable.swift
//  AIAStock
//
//  Created by Victor Samuel Cuaca on 16/12/20.
//

import UIKit

enum IntradaySort: Int {
    case openHighest = 0
    case openLowest  = 1
    case highHighest = 2
    case highLowest  = 3
    case lowHighest  = 4
    case lowLowest   = 5
    case latest      = 6
    case oldest      = 7
}


/// Enables the view controller to show custom alerts.
protocol Alertable where Self: UIViewController {
    func presentAlertSheet(title: String?, message: String?, selectedIndex: Int, completion: @escaping (IntradaySort) -> Void)
}

extension Alertable {
    
    /// Presents a basic sort alert sheet with the specified title and message.
    func presentAlertSheet(title: String?, message: String?, selectedIndex: Int, completion: @escaping (IntradaySort) -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let openHighest = UIAlertAction(title: "Open - Highest to Lowest", style: .default) { (_) in
            completion(.openHighest)
        }
        
        let openLowest = UIAlertAction(title: "Open - Lowest to Highest", style: .default) { (_) in
            completion(.openLowest)
        }
        
        let highHighest = UIAlertAction(title: "High - Highest to Lowest", style: .default) { (_) in
            completion(.highHighest)
        }
        
        let highLowest = UIAlertAction(title: "High - Lowest to Highest", style: .default) { (_) in
            completion(.highLowest)
        }
        
        let lowHighest = UIAlertAction(title: "Low - Highest to Lowest", style: .default) { (_) in
            completion(.lowHighest)
        }
        
        let lowLowest = UIAlertAction(title: "Low - Lowest to Highest", style: .default) { (_) in
            completion(.lowLowest)
        }
        
        let latest = UIAlertAction(title: "Latest", style: .default) { (_) in
            completion(.latest)
        }
        
        let oldest = UIAlertAction(title: "Oldest", style: .default) { (_) in
            completion(.oldest)
        }
        
        let actions = [openHighest, openLowest, highHighest, highLowest, lowHighest, lowLowest, latest, oldest]
        actions.forEach({ alert.addAction($0) })
        actions[selectedIndex].setValue(true, forKey: "checked")
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.pruneNegativeWidthConstraints()       // To silence constraint error

        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
