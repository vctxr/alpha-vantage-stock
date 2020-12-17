//
//  MessageView.swift
//  AIAStock
//
//  Created by Victor Samuel Cuaca on 16/12/20.
//

import UIKit

extension UITableView {

    func setEmptyMessage(title: String, subtitle: String?) {
        let messageLabel = UILabel()
        messageLabel.text = title
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = .preferredFont(forTextStyle: .headline)
        messageLabel.sizeToFit()
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.sizeToFit()
        
        let stack = UIStackView(arrangedSubviews: [messageLabel, subtitleLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .center
        
        let containerView = UIView()
        containerView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
        
        backgroundView = containerView
        separatorStyle = .none
    }
    
    func setFetchingState() {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.center = center
        spinner.startAnimating()
        
        backgroundView = spinner
        separatorStyle = .none
    }

    func restore() {
        backgroundView = nil
        separatorStyle = .singleLine
    }
}
