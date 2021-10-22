//
//  User.swift
//  Firebase Sample
//
//  Created by Stewart Lynch on 2021-10-21.
//

import Foundation


/// The User object created when the user authenticates.
public struct User: Codable {
    let uid: String
    let name: String
    let email: String
}
