//
//  FirebaseSession.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 02.12.2024..
//

import FirebaseAuth

class FirebaseSession {
    static let shared = FirebaseSession()
    
    func signOut(_ onSuccess: (() -> Void)?) {
        do {
            try Auth.auth().signOut()
            onSuccess?()
        } catch {
            print("Error signing out: \(error)")
        }
    }
    
    func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
}
