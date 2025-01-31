//
//  OnboradingRepository.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 04.12.2024..
//

import Foundation
import FirebaseAuth

protocol OnboardingProtocol {
    func login(with request: AuthRequest) async throws
    func signUp(with request: AuthRequest) async throws
}

final class OnboradingRepository: OnboardingProtocol {
    func login(with request: AuthRequest) async throws {
        try await Auth.auth().signIn(withEmail: request.email, password: request.password)
    }
    
    func signUp(with request: AuthRequest) async throws {
        try await Auth.auth().createUser(withEmail: request.email, password: request.password)
    }
}
