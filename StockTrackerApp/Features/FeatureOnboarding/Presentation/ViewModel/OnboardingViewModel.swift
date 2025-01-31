//
//  OnboardingViewModel.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 02.12.2024..
//

import Foundation
import FirebaseAuth
import Combine
import UserNotifications

class OnboardingViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private var repository: OnboardingProtocol
    
    @Published var email: ValidatedField = .init()
    @Published var password: ValidatedField = .init()
    @Published var toastManager: ToastManager = .init()
    @Published var validationTriggered: Bool = false
    @Published var canAuthenticate: Bool = false
    @Published var showLogin: Bool = true
    
    init(
        repository: OnboardingProtocol = OnboradingRepository()
    ) {
        self.repository = repository
        self.setValidations()
        self.setupLoginValidations()
    }
}

extension OnboardingViewModel {
    private func setValidations() {
        let rules = TextfieldValidationRules.shared
        self.email = ValidatedField(validationRules: rules.makeEmailRules)
        self.password = ValidatedField(validationRules: rules.makePasswordRules)
    }
    
    private func setupLoginValidations() {
        Publishers.CombineLatest(email.$error, password.$error)
            .map { [weak self] emailError, passswordError in
                return emailError == nil &&
                passswordError == nil &&
                self?.areAllFieldsValid() ?? false
            }
            .assign(to: \.canAuthenticate, on: self)
            .store(in: &cancellables)
    }
    
    private func areAllFieldsValid() -> Bool {
        !email.value.trimmed().isEmpty &&
        !password.value.trimmed().isEmpty
    }
    
    private func getError(for field: ValidatedField, validationTriggered: Bool) -> String? {
        return (field.value.getNilOrTrimmed() != nil || validationTriggered) ? field.error : nil
    }
    
    func getTrimmedValue(for field: ValidatedField) -> String {
        field.value.trimmed()
    }
    
    func resetValues() {
        validationTriggered = false
        email.value = ""
        password.value = ""
    }
}

extension OnboardingViewModel {
    var emailError: String? {
        TextFieldValidationUtil.getError(for: email, validationTriggered: validationTriggered)
    }
    
    var shouldShowEmailError: Bool {
        emailError != nil && validationTriggered
    }
    
    var passwordError: String? {
        TextFieldValidationUtil.getError(for: password, validationTriggered: validationTriggered)
    }
    
    var shouldShowPasswordError: Bool {
        passwordError != nil && validationTriggered
    }
}

extension OnboardingViewModel {
    func signUp(_ onSuceess: @escaping () -> Void) {
        validationTriggered = true
        guard canAuthenticate else { return }
        self.toastManager.showLoadingToast()
        let email = getTrimmedValue(for: self.email)
        let password = getTrimmedValue(for: self.password)
        
        self.toastManager.showLoadingToast()
        self.performSignUp(with: email, password: password, onSuceess: onSuceess)
    }
    
    private func performSignUp(
        with email: String,
        password: String,
        onSuceess: @escaping () -> Void
    ) {
        Task { [weak self] in
            guard let self else { return }
            do {
                try await self.repository.signUp(with: .init(email: email, password: password))
                self.toastManager.isShowingErrorToast = false
                onSuceess()
            } catch {
                if let error = error as? AuthErrorCode,
                   let errorMessage = AuthErrorCode(
                    rawValue: error.code.code.rawValue
                   )?.errorMessage {
                    self.toastManager.showErrorToast(withMessage: errorMessage)
                }
            }
        }
    }
    
    func login(_ onSuceess: @escaping () -> Void) {
        validationTriggered = true
        guard canAuthenticate else { return }
        self.toastManager.showLoadingToast()
        let email = getTrimmedValue(for: self.email)
        let password = getTrimmedValue(for: self.password)
        
        self.toastManager.showLoadingToast()
        self.performLogin(emai: email, password: password, onSuccess: onSuceess)
    }
    
    func performLogin(
        emai: String,
        password: String,
        onSuccess: @escaping () -> Void
    ) {
        Task {
            do {
                try await repository.login(with: .init(email: emai, password: password))
                onSuccess()
            } catch {
                if let error = error as? AuthErrorCode,
                   let errorMessage = AuthErrorCode(
                    rawValue: error.code.code.rawValue
                   )?.errorMessage {
                    self.toastManager.showErrorToast(withMessage: errorMessage)
                }
            }
        }
    }
}
