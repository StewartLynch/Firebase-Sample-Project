//
//  ReAuthenticateView.swift
//  Firebase Login
//
//  Created by Stewart Lynch on 2021-07-05.
//  Copyright © 2021 CreaTECH Solutions. All rights reserved.
//

import SwiftUI

struct ReAuthenticateView: View {
    @Binding var canDelete: Bool
    @Binding var showAuth: Bool
    @State private var password = ""
    @State private var errorText = ""
    var body: some View {
            VStack {
                VStack {
                    SecureField("Enter your password", text: $password)
                        .textFieldStyle(.roundedBorder)
                    Button("Authenticate") {
                        AuthManager().reauthenticateWithPassword(password: password) { result in
                            handleResult(result: result)
                        }
                    }
                    .padding(.vertical, 15)
                    .buttonStyle(.borderedProminent)
                    .opacity(password.isEmpty ? 0.6 : 1)
                    .disabled(password.isEmpty)
                }
                .padding()
                Text(errorText)
                    .foregroundColor(.red)
                    .fixedSize(horizontal: false, vertical: true)
                Button("Cancel") {
                    withAnimation {
                        showAuth = false
                    }
                }
                .padding(8)
                .buttonStyle(.bordered)
                Spacer()
            }
            .padding()
    }
    func handleResult(result: Result<Bool, Error>) {
        switch result {
        case .success:
            // Reauthenticated now so you can delete
            canDelete = true
            showAuth = false
        case .failure(let error):
            errorText = error.localizedDescription
        }
    }
}

struct ReAuthenticateView_Previews: PreviewProvider {
    static var previews: some View {
        ReAuthenticateView(canDelete: .constant(false), showAuth: .constant(true))
    }
}
