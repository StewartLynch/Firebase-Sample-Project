//
//  ViewModel.swift
//  Firebase Sample
//
//  Created by Stewart Lynch on 2021-10-20.
//

import SwiftUI
import FirebaseStorage
import FirebaseAuth

class ViewModel: ObservableObject {
    public enum AuthState {
        case undefined, signedOut, signedIn
    }
    @Published var user: User?
    @Published var isUserAuthenticated: AuthState
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var fullname: String = ""
    @Published var image:UIImage?
    @Published var showSheet = false
    @Published var newAccount = false
    @Published var showDeletion = false
//    @Published var userID: String?  /
    
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    public init(isUserAuthenticated: Published<AuthState>
                = Published<AuthState>.init(wrappedValue: .undefined)) {
        self._isUserAuthenticated  = isUserAuthenticated
    }
    /// Handles the change of authentication state
    func configureFirebaseStateDidChange() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener({ (_, user) in
            guard user != nil else {
                self.isUserAuthenticated = .signedOut
                self.user = nil
                self.image = nil
                self.email = ""
                self.password = ""
                return
            }
            self.isUserAuthenticated = .signedIn
            FirestoreManager().retrieveFBUser(uid: user!.uid) { (result) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let user):
                    self.user = user
                    self.getProfileImage()
                }
            }
           
        })
    }
    
    func login() {
        AuthManager().signIn(withEmail: email, password: password) { result in
            switch result {
            case .success:
                print("Logged in")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func logOut() {
        AuthManager().logout { result in
            print("Logged Out")
        }
    }
    
    func getProfileImage() {
        let storageManager = StorageManager()
        if let userID = user?.uid {
            storageManager.getImage(for: "Profiles", named: userID, completion: { result in
                switch result {
                case .success(let url):
                    let data = try? Data(contentsOf: url)
                    if let imageData = data {
                        self.image = UIImage(data: imageData)!
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
    }
    
    func saveProfileImage() {
        let storageManager = StorageManager()
        if let userID = user?.uid {
            if let image = image {
                storageManager.upload(image: image, for: "Profiles", named: userID)
            }
        }
    }
}
