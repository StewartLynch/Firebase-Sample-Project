//
//  SignUpViewModel.swift
//  Firebase Sample
//
//  Created by Stewart Lynch on 2021-10-21.
//

import Foundation

struct signUpViewModel {
    var email = ""
    var password = ""
    var fullname = ""
    
    func createUser(completion: @escaping (Bool) -> Void) {
        AuthManager().createUser(withEmail: self.email, password: self.password, fullname: fullname) { result in
            switch result {
            case .success:
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
