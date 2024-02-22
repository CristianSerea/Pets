//
//  UIApplication+Extension.swift
//  Pets
//
//  Created by Cristian Serea on 21.02.2024.
//

import UIKit

extension UIApplication {
    var firstKeyWindow: UIWindow? {
        return connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows })
            .flatMap({ $0 })
            .first(where: { $0.isKeyWindow })
    }
    
    var topViewController: UIViewController? {
        var topViewController = firstKeyWindow?.rootViewController
        
        while let presentedController = topViewController?.presentedViewController {
            topViewController = presentedController
        }
        
        return topViewController
    }
    
    var bottomSafeAreaInsets: CGFloat {
        return firstKeyWindow?.safeAreaInsets.bottom ?? .zero
    }
}
