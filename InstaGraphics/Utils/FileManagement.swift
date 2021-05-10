//
//  FileManagement.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 04/05/21.
//

import Foundation
import UIKit

// MARK: - FileManager

extension FileManager {
    
    public static var documentDirectoryUrl: URL? {
        return Self.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    public static func documentUrlWith(appendingPath path: String) -> URL? {
        return documentDirectoryUrl?.appendingPathComponent(path)
    }
}
