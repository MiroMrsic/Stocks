//
//  MaterialDesignTextField.swift
//  StockTrackerApp
//
//  Created by Miroslav Mrsic on 04.12.2024..
//

import SwiftUI

struct MaterialDesignTextField: View {
    @Binding var text: String
    
    var placeholder: String
    var message: String? = nil
    var showError: Bool = false
    var showMessage: Bool = false
    var isSecureField: Bool = false
    
    @State private var borderColor = Color.white
    @State private var borderWidth = 1.0
    @State private var placeholderBackgroundOpacity = 0.0
    @State private var placeholderBottomPadding = 0.0
    @State private var placeholderColor = Color.white
    @State private var placeholderFontSize = 16.0
    @State private var placeholderLeadingPadding = 2.0
    @State private var editing: Bool = false
    @State private var isSecure: Bool = true
    
    @FocusState private var focusField: Field?
    
    var body: some View {
        ZStack {
            Group {
                if isSecureField {
                    HStack {
                        if isSecure {
                            SecureField("", text: $text)
                        } else {
                            TextField("", text: $text)
                        }
                        
                        Button(action: {
                            withAnimation(.easeOut) {
                                isSecure.toggle()
                            }
                        }) {
                            Image(systemName: isSecure ? "eye.slash" : "eye")
                                .foregroundStyle(.white)
                        }
                    }
                } else {
                    TextField("", text: $text)
                }
            }
            .padding(10)
            .background(Color.white.opacity(0.1))
            .foregroundStyle(.white)
            .clipShape(.rect(cornerRadius: 8))
            .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(borderColor, lineWidth: borderWidth))
            .focused($focusField, equals: .textField)
            
            HStack {
                ZStack {
                    Text(placeholder)
                        .foregroundStyle(.white.opacity(0.6))
                        .animatableFont(size: placeholderFontSize)
                        .padding(.horizontal, text.isEmpty ? 8 : 2)
                        .padding(.vertical, text.isEmpty ? 0 : 0)
                        .layoutPriority(1)
                        .bold(!text.isEmpty)
                }
                .padding([.leading], placeholderLeadingPadding)
                .padding([.bottom], placeholderBottomPadding)
                Spacer()
            }
            
            if let message {
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Text(message)
                            .font(.system(size: 12.0))
                            .foregroundStyle(showError ? .red : .white.opacity(0.6))
                            .padding([.trailing], 10.0)
                    }
                }
                .padding(.top, showError || showMessage ? 62 : 0)
            }
        }
        .onChange(of: text) { _, newValue in
            editing = newValue.isEmpty ? false : true
            withAnimation(.easeOut) {
                updateBorder()
                updatePlaceholder()
            }
        }
        .onChange(of: showError) { _, _ in
            withAnimation(.easeOut) {
                updateBorder()
                updatePlaceholder()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 75.0)
    }
    
    private func updateBorder() {
        updateBorderColor()
        updateBorderWidth()
    }
    
    private func updateBorderColor() {
        if  showError {
            return borderColor = .red
        }
        
        if  showMessage {
            return borderColor = .white
        }
        
        return borderColor = .white
    }
    
    private func updateBorderWidth() {
        borderWidth = editing || showError || showMessage ? 2.0 : 1.0
    }
    
    private func updatePlaceholder() {
        updatePlaceholderBackground()
        updatePlaceholderFontSize()
        updatePlaceholderPosition()
    }
    
    private func updatePlaceholderBackground() {
        if editing || !text.isEmpty || showMessage || showError  {
            placeholderBackgroundOpacity = 1.0
        } else {
            placeholderBackgroundOpacity = 0.0
        }
    }
    
    private func updatePlaceholderFontSize() {
        if  editing || !text.isEmpty {
            placeholderFontSize = 12.0
        } else {
            placeholderFontSize = 16.0
        }
    }
    
    private func updatePlaceholderPosition() {
        if  editing && !text.isEmpty {
            placeholderBottomPadding = 58.0
            placeholderLeadingPadding = 10.0
        } else {
            placeholderBottomPadding = 0.0
            placeholderLeadingPadding = 8.0
        }
    }
    
    private enum Field {
        case textField
    }
}
