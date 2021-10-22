//
//  Firebase_SampleApp.swift
//  Firebase Sample
//
//  Created by Stewart Lynch on 2021-10-20.
//

import SwiftUI
import Firebase

@main
struct Firebase_SampleApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                }
        }
    }
}
