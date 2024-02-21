//
//  UIViewController+Extension.swift
//  Pets
//
//  Created by Cristian Serea on 20.02.2024.
//

import UIKit

extension UIViewController {
    func showAlertController(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: LocalizableConstants.errorLabelTitle, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: LocalizableConstants.doneButtonTitle, style: .default, handler: { _ in
            completion?()
        })
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func showAlertController(error: Error, completion: (() -> Void)? = nil) {
        showAlertController(message: error.localizedDescription, completion: completion)
    }
}

extension UIViewController {
    func presentActionSheetController(withTitle title: String? = nil,
                                      withActionTitles actionTitles: [String]?,
                                      completion: ((Int) -> Void)?) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        if let actionTitles = actionTitles, actionTitles.count > .zero {
            for (index, actionTitle) in actionTitles.enumerated() {
                let action = UIAlertAction(title: actionTitle, style: .default, handler: { _ in
                    completion?(index)
                })
                alertController.addAction(action)
            }
        }

        let cancelAction = UIAlertAction(title: LocalizableConstants.cancelButtonTitle, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }
}
