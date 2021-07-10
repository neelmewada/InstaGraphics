//
//  StringValidation.swift
//  InstaGraphics
//
//  Created by Neel Mewada on 04/05/21.
//

import Foundation

// MARK: - String

extension String {
    var isValidEmail: Bool {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: self)
    }
    
    var isValidPhone: Bool {
        let regularExpressionForPhone = "^\\d{10}$"
        let testPhone = NSPredicate(format:"SELF MATCHES %@", regularExpressionForPhone)
        return testPhone.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        let passwordPattern =
            // At least 6 characters
            #"(?=.{6,})"#/* +
            
            // At least one capital letter
            #"(?=.*[A-Z])"# +
            
            // At least one lowercase letter
            #"(?=.*[a-z])"# +
            
            // At least one digit
            #"(?=.*\d)"#*/
        
        let result = self.range(of: passwordPattern, options: .regularExpression)
        return result != nil
    }
}
