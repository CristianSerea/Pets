//
//  UIView+Extension.swift
//  Pets
//
//  Created by Cristian Serea on 20.02.2024.
//

import UIKit

extension UIView {
    var nibView: UIView? {
        let type = type(of: self)
        let bundle = Bundle(for: type)
        let name = String(describing: type)
        let nibName = name.components(separatedBy: ".").last ?? name
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        guard let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return nil
        }
        
        nibView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        nibView.frame = bounds
        
        return nibView
    }
}

extension UIView {
    func applyCornerRadius() {
        layer.cornerRadius = GlobalConstants.Layout.cornerRadius
        clipsToBounds = true
    }
}
