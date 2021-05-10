//
//  ViewModel.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 04/05/21.
//

import Foundation

class ViewModel {
    typealias EventCallback = () -> ()
    
    internal var viewModelChanged: EventCallback? = nil
    
    func setViewModelChangedCallback(_ callback: @escaping EventCallback) {
        self.viewModelChanged = callback
    }
}
