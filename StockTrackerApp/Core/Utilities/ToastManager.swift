//
//  ToastManager.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 01.12.2024..
//

import Foundation

struct ToastManager {
    var isShowingSuccessToast = false
    var successToastMessage = ""
    var isShowingErrorToast = false
    var errorToastMessage = ""
    var isShowingLoadingToast = false
    var loadingToastMessage = ""
}

extension ToastManager {
    mutating func showSuccessToast(withMessage message: String) {
        isShowingLoadingToast = false
        successToastMessage = message
        isShowingSuccessToast.toggle()
    }
    
    mutating func showErrorToast(_ error: NetworkError) {
        isShowingLoadingToast = false
        errorToastMessage = error.description ?? error.localizedDescription
        isShowingErrorToast.toggle()
    }
    
    mutating func showErrorToast(withMessage message: String) {
        isShowingLoadingToast = false
        errorToastMessage = message
        isShowingErrorToast.toggle()
    }
    
    mutating func showLoadingToast() {
        isShowingLoadingToast = true
    }
    
    mutating func hideLoadingToast() {
        isShowingLoadingToast = false
    }
}
