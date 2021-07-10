//
//  RootNavigationController.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 04/05/21.
//

import UIKit

class RootNavigationController: UINavigationController {
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .lightContent
    }
}
