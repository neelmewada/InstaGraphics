//
//  AppUtils.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 04/05/21.
//

import UIKit

class AppUtils {
    public static weak var navigationController: UINavigationController? = nil
    public static weak var windowScene: UIWindowScene? = nil
    
    public static weak var topViewController: UIViewController? {
        return navigationController?.topViewController
    }
    
    public static func pushVCToNavigation(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    public static func popVCFromNavigation(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    public static func presentVCModally(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        topViewController?.present(viewController, animated: animated, completion: completion)
    }
    
    public static func showYesNoAlert(title: String, message: String, options: (String, String) = ("Yes", "No"), yesHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: options.1, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: options.0, style: .default, handler: yesHandler))
        Self.topViewController?.present(alert, animated: true)
    }
    
    public static func showAlert(title: String, message: String, buttonTitle: String = "Ok") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        Self.topViewController?.present(alert, animated: true)
    }
    
    public static var orientationWidth: CGFloat {
        if (windowScene?.interfaceOrientation.isLandscape ?? false) {
            return UIScreen.main.bounds.height
        }
        return UIScreen.main.bounds.width
    }
    
    public static var orientationHeight: CGFloat {
        if (windowScene?.interfaceOrientation.isLandscape ?? false) {
            return UIScreen.main.bounds.width
        }
        return UIScreen.main.bounds.height
    }
}
