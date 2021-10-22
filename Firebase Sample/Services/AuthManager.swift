//
//  AuthManager.swift
//  Firebase Sample
//
//  Created by Stewart Lynch on 2021-10-20.
//

import Foundation
import FirebaseAuth

class AuthManager {
    func signIn(completion: @escaping (Result<String, Error>) -> Void ) {
        Auth.auth().signInAnonymously { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                if let user = authResult?.user {
                    print(user.uid)
                    completion(.success(user.uid))
                }
            }
        }
    }
    
    func signIn(withEmail email: String,
                            password: String,
                            completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let err = error {
                completion(.failure(err))
            } else {
                completion(.success(true))
            }
        }
    }
    
    func createUser(withEmail email: String,
                           password: String,
                           fullname: String,
                    completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let err = error {
                completion(.failure(err))
                return
            }
            guard authResult?.user != nil else {
                completion(.failure(error!))
                return
            }
            let user = User(uid: authResult!.user.uid, name: fullname, email: authResult!.user.email!)
            FirestoreManager().mergeFBUser(user: user, uid: authResult!.user.uid) { result in
                completion(result)
            }
            completion(.success(true))
        }
    }
    
    func deleteUser(completion: @escaping (Result<Bool, Error>) -> Void) {
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
            }
        }
    }
    
    func reauthenticateWithPassword(password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        if let user = Auth.auth().currentUser {
            let credential = EmailAuthProvider.credential(withEmail: user.email ?? "", password: password)
            user.reauthenticate(with: credential) { _, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
            }
        }
    }
    
    func logout(completion: @escaping (Result<Bool, Error>) -> Void) {
        let auth = Auth.auth()
        do {
            try auth.signOut()
            completion(.success(true))
        } catch let err {
            completion(.failure(err))
        }
    }
}
