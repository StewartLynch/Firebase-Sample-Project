//
//  ContentView.swift
//  Firebase Sample
//
//  Created by Stewart Lynch on 2021-10-20.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject var vm = ViewModel()
    var body: some View {
        NavigationView {
            VStack {
                    if vm.isUserAuthenticated != .signedIn {
                        VStack {
                            TextField("Email", text: $vm.email)
                            SecureField("Password",text: $vm.password)
                            Button {
                                vm.login()
                            } label: {
                                Text("Log In")
                            }
                            .buttonStyle(.borderedProminent)
                            Text("OR")
                            Button {
                                vm.newAccount = true
                            } label: {
                                Text("Create Account")
                            }
                            .buttonStyle(.bordered)
                            .sheet(isPresented: $vm.newAccount) {
                                SignUpView()
                            }
                        }
                       
                        .padding()
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                    } else {
                        if let user = vm.user {
                            Text("Welcome \(user.name)")
                                .font(.title)
                        }
                    }
                if vm.isUserAuthenticated == .signedIn {
                    Button {
                        vm.showDeletion.toggle()
                    } label: {
                        Text("Delete Account")
                            .foregroundColor(.red)
                            .buttonStyle(.borderless)
                    }
                    .buttonStyle(.bordered)
                    .sheet(isPresented: $vm.showDeletion) {
//                        DeleteView(user: vm.user!)
                        DeleteView(user: vm.user!)
                    }
                }
                if let image = vm.image {
                    Image(uiImage: image)
                        .resizable()
                        .cornerRadius(50)
                        .frame(width: 200, height: 200)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .frame(width: 200, height: 200)
                        .foregroundColor(Color("AccentColor"))
                        .overlay(
                            Image("FirebaseLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                        )
                   
                }
                
                if vm.isUserAuthenticated == .signedIn {
                        Button {
                            vm.showSheet = true
                        } label: {
                            Text("Update Profile Image")
                        }
                        .buttonStyle(.borderedProminent)
                    
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .onChange(of: vm.image, perform: { image in
                vm.image = image
                vm.saveProfileImage()
            })
            .sheet(isPresented: $vm.showSheet) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$vm.image)
            }
            .navigationTitle("Firebase Sample")
            .toolbar {
               
                ToolbarItem(placement: .navigationBarTrailing) {
                    if vm.user != nil {
                        Button {
                            vm.logOut()
                        } label: {
                            Text("Log Out")
                        }
                        .buttonStyle(.bordered)
                    } else {
                        EmptyView()
                    }
                }
            }
            .onAppear {
                vm.configureFirebaseStateDidChange()
        }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
