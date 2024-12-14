//
//  AuthErrorCode.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 04.12.2024..
//

import Foundation
import FirebaseAuth

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .operationNotAllowed:
            return "Sign-in provider is disabled"
        case .emailAlreadyInUse:
            return "Email address is already in use"
        case .invalidEmail:
            return "Email address is badly formatted"
        case .weakPassword:
            return "Password must be 6 characters long or more"
        default:
            return "Unknown error occurred. Please try again."
        }
    }
}
