//
//  AuthContentView.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 02.12.2024..
//

import SwiftUI

struct AuthView: View {
    @Binding var email: String
    @Binding var password: String
    
    var title: String
    var subtitle: String
    
    var textfieldPlaceholder: String = "Email"
    var textfielMessage: String?
    var showTextfieldError: Bool
    var showTextfieldMessage: Bool
    
    var secureTextfieldPlaceholder: String = "Password"
    var secureTextfieldMessage: String?
    var showSecureTextfieldError: Bool
    var showSecureTextfieldMessage: Bool
    
    var actionButtonTitle: String
    var onActionButtonPress: () -> Void
    var footerActionTitle: String
    var onFooterActionPress: () -> Void
    
    var body: some View {
        ScrollView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.top, 25)
                    
                    Text(subtitle)
                        .foregroundStyle(.gray)
                    
                    VStack {
                        MaterialDesignTextField(
                            text: $email,
                            placeholder: textfieldPlaceholder,
                            message: textfielMessage,
                            showError: showTextfieldError,
                            showMessage: showTextfieldMessage
                        )
                        
                        MaterialDesignTextField(
                            text: $password,
                            placeholder: secureTextfieldPlaceholder,
                            message: secureTextfieldMessage,
                            showError: showSecureTextfieldError,
                            showMessage: showSecureTextfieldMessage,
                            isSecureField: true
                        )
                    }
                }
                .padding()
            }
        }
        .overlay(alignment: .bottom) {
            VStack {
                BoldButtonWithAction(
                    buttonTitle: actionButtonTitle
                ) {
                    onActionButtonPress()
                }
                .buttonStyle(FilledButton(foregroundStyle: .black, backgroundColor: .white))
                
                Button(action: {
                    onFooterActionPress()
                }) {
                    Text(footerActionTitle).foregroundStyle(.gray)
                }
            }
            .padding()
        }
    }
}

extension AuthView {
//    private func getPadding() -> CGFloat {
//        showTextfieldError ||
//        showTextfieldMessage ||
//        showSecureTextfieldError ||
//        showSecureTextfieldMessage ? 10 : 15
//    }
}
