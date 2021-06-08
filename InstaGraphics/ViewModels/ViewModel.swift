//
//  ViewModel.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 04/05/21.
//

import Foundation

protocol ViewModel: AnyObject {
    associatedtype ViewState
    
    typealias RenderStateCallback = (ViewState) -> ()
    
    /// Use this function to enable View Model class to make render callbacks to the View.
    func setRenderCallback(_ renderCallback: @escaping RenderStateCallback)
}
