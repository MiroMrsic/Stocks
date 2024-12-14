//
//  OnboradingRepository.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 04.12.2024..
//

import Foundation
import FirebaseAuth
import Combine

protocol OnboardingProtocol {
    func login(with request: AuthRequest) -> AnyPublisher<Void, NSError>
    func signUp(with request: AuthRequest) -> AnyPublisher<Void, NSError>
}

final class OnboradingRepository: OnboardingProtocol {
    func login(with request: AuthRequest) -> AnyPublisher<Void, NSError> {
        return Future<Void, NSError> { promise in
            Auth.auth().signIn(
                withEmail: request.email,
                password: request.password
            ) { authResult, error in
                if  let error = error as? NSError {
                    return promise(.failure(error))
                }
                
                return promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func signUp(with request: AuthRequest) -> AnyPublisher<Void, NSError> {
        return Future<Void, NSError> { promise in
            Auth.auth().createUser(
                withEmail: request.email,
                password: request.password
            ) { authResult, error in
                if  let error = error as? NSError {
                    return promise(.failure(error))
                }
                
                return promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
}
