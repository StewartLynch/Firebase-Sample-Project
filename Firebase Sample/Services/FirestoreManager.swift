//
//  FirestoreManager.swift
//  Firebase Sample
//
//  Created by Stewart Lynch on 2021-10-21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift


import Foundation

// MARK: - Firstore errors
enum FireStoreError: Error {
    case noAuthDataResult
    case noCurrentUser
    case noDocumentSnapshot
    case noSnapshotData
    case noUser
    case unknownError
}

extension FireStoreError: LocalizedError {
    // This will provide me with a specific localized description for the FireStoreError
    var errorDescription: String? {
        switch self {
        case .noAuthDataResult:
            return NSLocalizedString("No Auth Data Result", comment: "")
        case .noCurrentUser:
            return NSLocalizedString("No Current User", comment: "")
        case .noDocumentSnapshot:
            return NSLocalizedString("No Document Snapshot", comment: "")
        case .noSnapshotData:
            return NSLocalizedString("No Snapshot Data", comment: "")
        case .noUser:
            return NSLocalizedString("No User", comment: "")
        case .unknownError:
            return NSLocalizedString("Unknown Firestore error", comment: "")
        }
    }
}
/// A The functions used by the package to retrieve the user information, update and delete account
class FirestoreManager {
    func retrieveFBUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        let reference = Firestore
            .firestore()
            .collection("users")
            .document(uid)
        getDocument(for: reference) { result in
            switch result {
            case .success(let document):
                do {
                    guard let user = try document.data(as: User.self) else {
                        completion(.failure(FireStoreError.noUser))
                        return
                    }
                    completion(.success(user))
                } catch {
                    completion(.failure(FireStoreError.noUser))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
   
    func mergeFBUser(user: User, uid: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        if user.name != "" {
            let reference = Firestore
                .firestore()
                .collection("users")
                .document(uid)
            do {
                _ =  try reference.setData(from: user, merge: true)
                completion(.success(true))
            } catch {
                completion(.failure(error))
            }
        } else {
            completion(.failure(FireStoreError.unknownError))
        }
        
    }
    /// retrieves the document snapshot for the user collection
    /// - Parameters:
    ///   - reference: the document reference
    ///   - completion: a completion handler providing the resulting data or an error
    func getDocument(for reference: DocumentReference,
                                        completion: @escaping (Result<DocumentSnapshot, Error>) -> Void) {
        reference.getDocument { (documentSnapshot, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            guard let documentSnapshot = documentSnapshot else {
                completion(.failure(FireStoreError.noDocumentSnapshot))
                return
            }
            completion(.success(documentSnapshot))
        }
    }
    /// Deletes the user account
    /// - Parameters:
    ///   - uid: the unique user ID
    ///   - completion: a completion result of a success or an error
   func deleteUserData(uid: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let reference = Firestore
            .firestore()
            .collection("users")
            .document(uid)
        reference.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
}
