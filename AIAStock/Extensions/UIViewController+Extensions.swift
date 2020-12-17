//
//  UIViewController+Extensions.swift
//  AIAStock
//
//  Created by Victor Samuel Cuaca on 17/12/20.
//

import UIKit

extension UIViewController {
    
    func configureSearchBar(placeholder: String, delegate: UISearchBarDelegate) {
        navigationItem.largeTitleDisplayMode = .automatic
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = placeholder
        searchController.searchBar.delegate = delegate
        searchController.searchBar.searchTextField.addDoneToolbar()
        searchController.searchBar.searchTextField.autocorrectionType = .no
        searchController.searchBar.searchTextField.autocapitalizationType = .allCharacters
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
}
