//
//  ProfileView.swift
//  My Stuff
//
//  Created by Stewart Lynch on 2021-10-17.
//

import SwiftUI

struct DeleteView: View {
    @Environment(\.dismiss) var dismiss
    var user: User
    @State private var canDelete = false
    @State private var showAuth = false
    var body: some View {
            VStack {
                if !showAuth {
                Text(canDelete ?
                    "DO YOU REALLY WANT TO DELETE?" :
                    "Deleting your account will delete all content " +
                    "and remove your information from the database. " +
                    "You must first re-authenticate")
                HStack {
                    Button("Cancel") {
                        canDelete = false
                        dismiss()
                    }
                    .padding(.vertical, 15)
                    .frame(width: 100)
                    .background(Color(.systemBackground))
                    .cornerRadius(8)
                    .foregroundColor(Color(.label))
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    Button(canDelete ? "DELETE ACCOUNT" : "Authenticate") {
                        if canDelete {
                            FirestoreManager().deleteUserData(uid: user.uid) { result in
                                dismiss()
                                switch result {
                                case .success:
                                    StorageManager().deleteProfileImage(for: user.uid)
                                    AuthManager().deleteUser { result in
                                        if case let .failure(error) = result {
                                            print(error.localizedDescription)
                                        }
                                    }
                                case .failure(let error):
                                    print(error.localizedDescription)
                                }
                            }
                        } else {
                            withAnimation {
                                showAuth = true
                            }
                        }
                    }
                    .padding(.vertical, 15)
                    .frame(width: 179)
                    .background(Color.red)
                    .cornerRadius(8)
                    .foregroundColor(.white)
                }
                Spacer()
                } else {
                    ReAuthenticateView(canDelete: $canDelete, showAuth: $showAuth)
                }
            }
            .padding(.top, 40)
            .padding(.horizontal, 10)
            }
        }

struct DeleteView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteView(user: User(uid: "", name: "", email: ""))
    }
}
