//
//  ValidatedField.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 03.12.2024..
//

import Combine
import SwiftUI

/// A view model that handles validation for a specific input.
class ValidatedField: ObservableObject {
    @Published var value: String = ""
    @Published var error: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    private let validationRules: [AnyValidationRule<String>]
    
    /// Initializes the ValidatedField with an array of validation rules.
    /// - Parameter validationRules: The validation rules to apply.
    init(validationRules: [AnyValidationRule<String>] = []) {
        self.validationRules = validationRules
        setupValidation()
    }
    
    /// Sets up the validation by observing changes to the value.
    private func setupValidation() {
        $value
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { [weak self] in self?.validate($0) }
            .assign(to: \.error, on: self)
            .store(in: &cancellables)
    }
    
    /// Validates the current value against all validation rules.
    /// - Parameter value: The value to validate.
    /// - Returns: An optional error message if validation fails.
    private func validate(_ value: String) -> String? {
        for rule in validationRules {
            if let error = rule.validate(value) {
                return error
            }
        }
        return nil
    }
}
