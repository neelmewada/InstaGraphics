//
//  GFUtils.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 06/05/21.
//

import UIKit

class GFUtils {
    public static var orientationWidth: CGFloat {
        let windowScene = UIApplication.shared.getKeyWindow()?.windowScene
        if (windowScene?.interfaceOrientation.isLandscape ?? false) {
            return UIScreen.main.bounds.height
        }
        return UIScreen.main.bounds.width
    }
    
    public static var orientationHeight: CGFloat {
        let windowScene = UIApplication.shared.getKeyWindow()?.windowScene
        if (windowScene?.interfaceOrientation.isLandscape ?? false) {
            return UIScreen.main.bounds.width
        }
        return UIScreen.main.bounds.height
    }
}
