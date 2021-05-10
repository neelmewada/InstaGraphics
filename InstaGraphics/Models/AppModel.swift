//
//  AppModel.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 04/05/21.
//

import UIKit

// Tha Main Model class for the entire app
final class AppModel: NSObject {
    // MARK: - Lifecycle
    
    private static var _shared: AppModel? = nil
    
    public static var shared: AppModel {
        if _shared == nil {
            _shared = AppModel()
        }
        return _shared!
    }
    
    private override init() {
        super.init()
        loadInitialData()
    }
    
    /// Call this function to explicitly initialize the AppModel singleton at app-launch.
    public static func initShared() {
        let _ = Self.shared
    }
    
    // MARK: - Initialization Methods
    
    /// Loads the required basic data on app startup, like user preferences, cached data, etc.
    func loadInitialData() {
        
    }
    
    func subscribeForModelChanges(_ handler: @escaping Event.EventHandler) {
        self.modelChangeEvent.addSubscriber(handler)
    }
    
    // MARK: - Internal Properties
    
    private let modelChangeEvent: Event = Event()
    
    // MARK: - State Properties
    
    // MARK: - Model Interface
    
    
}
