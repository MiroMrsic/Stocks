//
//  OnboardingView.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 02.12.2024..
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Environment(\.appState) private var appState
    
    var body: some View {
        HStack {
            if viewModel.showLogin {
                AuthView(
                    email: $viewModel.email.value,
                    password: $viewModel.password.value,
                    title: "Stock Tracker App",
                    subtitle: "Please sign in to your account",
                    textfielMessage: viewModel.emailError,
                    showTextfieldError: viewModel.shouldShowEmailError,
                    showTextfieldMessage: viewModel.emailError != nil,
                    secureTextfieldMessage: viewModel.passwordError,
                    showSecureTextfieldError: viewModel.shouldShowPasswordError,
                    showSecureTextfieldMessage: viewModel.passwordError != nil,
                    actionButtonTitle: "Sign in",
                    onActionButtonPress: { viewModel.login { appState(.home) } },
                    footerActionTitle: "Don't have an account? Sign up",
                    onFooterActionPress: {
                        withAnimation(.smooth) {
                            viewModel.resetValues()
                            viewModel.showLogin.toggle()
                        }
                    }
                )
                .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
            } else {
                AuthView(
                    email: $viewModel.email.value,
                    password: $viewModel.password.value,
                    title: "Create new account",
                    subtitle: "Please fill in the form to continue",
                    textfielMessage: viewModel.emailError,
                    showTextfieldError: viewModel.shouldShowEmailError,
                    showTextfieldMessage: viewModel.emailError != nil,
                    secureTextfieldMessage: viewModel.passwordError,
                    showSecureTextfieldError: viewModel.shouldShowPasswordError,
                    showSecureTextfieldMessage: viewModel.passwordError != nil,
                    actionButtonTitle: "Sign up",
                    onActionButtonPress: { viewModel.signUp { appState(.home) } },
                    footerActionTitle: "Already have an account? Sign in",
                    onFooterActionPress: {
                        withAnimation(.smooth) {
                            viewModel.resetValues()
                            viewModel.showLogin.toggle()
                        }
                    }
                )
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .trailing)))
            }
        }
        .toast(
            isPresenting: $viewModel.toastManager.isShowingSuccessToast
        ) {
            AlertToast(
                displayMode: .banner(.pop),
                type: .complete(.green),
                title: viewModel.toastManager.successToastMessage
            )
        }
        .toast(
            isPresenting: $viewModel.toastManager.isShowingLoadingToast
        ) {
            AlertToast(type: .loading)
        }
        .toast(
            isPresenting: $viewModel.toastManager.isShowingErrorToast
        ) {
            AlertToast(
                displayMode: .banner(.pop),
                type: .error(.red),
                title: viewModel.toastManager.errorToastMessage,
                style: .style(titleColor: .red,titleFont: .body, subTitleFont: .body)
            )
        }
    }
}
