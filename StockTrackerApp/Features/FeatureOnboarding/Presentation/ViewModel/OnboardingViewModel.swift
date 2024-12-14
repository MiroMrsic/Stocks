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
        repository.signUp(with: .init(email: email, password: password))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion,
                   let error =  AuthErrorCode(rawValue: error.code)?.errorMessage {
                    self.toastManager.showErrorToast(withMessage: error)
                }
            }, receiveValue: { _ in
                self.toastManager.isShowingErrorToast = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: onSuceess)
            })
            .store(in: &cancellables)
    }
    
    func login(_ onSuceess: @escaping () -> Void) {
        validationTriggered = true
        guard canAuthenticate else { return }
        self.toastManager.showLoadingToast()
        let email = getTrimmedValue(for: self.email)
        let password = getTrimmedValue(for: self.password)
        
        self.toastManager.showLoadingToast()
        repository.login(with: .init(email: email, password: password))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion,
                   let error =  AuthErrorCode(rawValue: error.code)?.errorMessage {
                    self.toastManager.showErrorToast(withMessage: error)
                }
            }, receiveValue: { _ in
                self.toastManager.isShowingErrorToast = false
                onSuceess()
            })
            .store(in: &cancellables)
    }
}
