//
//  UIApplication+Extension.swift
//  Pets
//
//  Created by Cristian Serea on 21.02.2024.
//

import UIKit

extension UIApplication {
    var bottomSafeAreaInsets: CGFloat {
        return connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows })
            .flatMap({ $0 })
            .first(where: { $0.isKeyWindow })?
            .safeAreaInsets.bottom ?? .zero
    }
}
