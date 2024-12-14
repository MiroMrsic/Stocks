//
//  ValidationRules.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 03.12.2024..
//

import Foundation
import Combine

class TextfieldValidationRules {
    static let shared = TextfieldValidationRules()

    let makeEmailRules: [AnyValidationRule<String>]
    let makePasswordRules: [AnyValidationRule<String>]

    private init() {
        self.makeEmailRules = [
            AnyValidationRule(EmptyValidationRule(errorMessage: "Email is required.")),
            AnyValidationRule(EmailValidationRule())
        ]
        
        self.makePasswordRules = [
            AnyValidationRule(EmptyValidationRule(errorMessage: "Password cannot be empty.")),
            AnyValidationRule(SpecialCharacterValidationRule())
        ]
    }
}

/// A protocol that defines a validation rule for a specific type of input.
protocol ValidationRule {
    associatedtype Input
    
    /// Validates the given input.
    /// - Parameter input: The input to validate.
    /// - Returns: An optional error message if validation fails.
    func validate(_ input: Input) -> String?
}

// Implementing Type Erasure with AnyValidationRule

/// A type-erased wrapper for any ValidationRule.
struct AnyValidationRule<Input>: ValidationRule {
    private let _validate: (Input) -> String?
    
    /// Initializes the type-erased validation rule with a specific ValidationRule.
    /// - Parameter rule: The validation rule to wrap.
    init<R: ValidationRule>(_ rule: R) where R.Input == Input {
        self._validate = rule.validate
    }
    
    /// Validates the input using the encapsulated validation rule.
    /// - Parameter input: The input to validate.
    /// - Returns: An optional error message if validation fails.
    func validate(_ input: Input) -> String? {
        return _validate(input)
    }
}

// Creating Concrete Validation Rules

/// A validation rule that checks if a string is not empty.
struct EmptyValidationRule: ValidationRule {
    typealias Input = String
    
    let errorMessage: String
    
    /// Initializes the EmptyValidationRule with a custom error message.
    /// - Parameter errorMessage: The message to display if validation fails.
    init(errorMessage: String = "This field cannot be empty.") {
        self.errorMessage = errorMessage
    }
    
    func validate(_ input: String) -> String? {
        return input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? errorMessage : nil
    }
}

struct PasswordMatchValidationRule: ValidationRule {
    typealias Input = (password: String, repeatPassword: String)

    let errorMessage: String

    init(errorMessage: String = "Passwords do not match.") {
        self.errorMessage = errorMessage
    }

    func validate(_ input: Input) -> String? {
        return input.password != input.repeatPassword ? errorMessage : nil
    }
}

/// A validation rule that checks if a string is a valid email address.
struct EmailValidationRule: ValidationRule {
    typealias Input = String
    
    let errorMessage: String
    
    /// Initializes the EmailValidationRule with a custom error message.
    /// - Parameter errorMessage: The message to display if validation fails.
    init(errorMessage: String = "Please enter a valid email address.") {
        self.errorMessage = errorMessage
    }
    
    func validate(_ input: String) -> String? {
        // Simple regex for demonstration purposes.
        let emailRegex = #"^\S+@\S+\.\S+$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: input) ? nil : errorMessage
    }
}

/// A validation rule that checks if a string contains at least one special character.
struct SpecialCharacterValidationRule: ValidationRule {
    typealias Input = String
    
    let errorMessage: String
    
    /// Initializes the SpecialCharacterValidationRule with a custom error message.
    /// - Parameter errorMessage: The message to display if validation fails.
    init(errorMessage: String = "Password must contain at least one special character.") {
        self.errorMessage = errorMessage
    }
    
    func validate(_ input: String) -> String? {
        let specialCharacterRegex = #".*[!@#$%^&*(),.?":{}|<>].*"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", specialCharacterRegex)
        return predicate.evaluate(with: input) ? nil : errorMessage
    }
}

/// A validation rule that combines multiple validation rules.
struct CompositeValidationRule<Input>: ValidationRule {
    typealias Input = Input
    
    private let rules: [AnyValidationRule<Input>]
    
    /// Initializes the CompositeValidationRule with an array of validation rules.
    /// - Parameter rules: The validation rules to combine.
    init(rules: [AnyValidationRule<Input>]) {
        self.rules = rules
    }
    
    func validate(_ input: Input) -> String? {
        for rule in rules {
            if let error = rule.validate(input) {
                return error
            }
        }
        return nil
    }
}
