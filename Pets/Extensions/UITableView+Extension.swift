//
//  UITableView+Extension.swift
//  Pets
//
//  Created by Cristian Serea on 20.02.2024.
//

import UIKit

extension UITableView {
    func setupRefreshControl(target: Any?, action: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(target, action: action, for: .valueChanged)
        refreshControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        self.refreshControl = refreshControl
    }
    
    func setupTableFooterView() {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        activityIndicatorView.frame = CGRect(x: .zero, y: .zero,
                                             width: bounds.width, height: GlobalConstants.Layout.defaultHeight)
        activityIndicatorView.startAnimating()
        tableFooterView = activityIndicatorView
    }
}
