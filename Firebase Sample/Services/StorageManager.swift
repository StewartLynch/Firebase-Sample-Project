//
//  StorageManager.swift
//  Firebase Sample
//
//  Created by Stewart Lynch on 2021-10-20.
//


import SwiftUI
import Firebase

class StorageManager: ObservableObject {
    let storage = Storage.storage()
    func upload(image: UIImage, for uid: String, named name: String) {
        let storageRef = storage.reference().child("\(uid)//\(name).jpg")
        let resizedImage = image.aspectFittedToHeight(200)
        let data = resizedImage.jpegData(compressionQuality: 0.2)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        if let data = data {
            storageRef.putData(data, metadata: metadata) { (metadata, error) in
                if let error = error {
                    print("Error while uploading file: ", error)
                } else {
                    storageRef.downloadURL { url, error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            if let url = url {
                                print(url.absoluteString)
                            }
                        }
                    }
                }

            }
        }
    }
    
    func deleteProfileImage(for uid: String) {
        //        if let storageReference = storageReference {
        let storageReference = storage.reference().child("Profiles//\(uid).jpg")
        storageReference.delete { error in
            if let error = error {
                print("\(String(describing: error.localizedDescription))")
            } else {
                print("Successfully deleted image")
            }
        }
        //        }
    }
    
    func getImage(for uid: String, named name: String, completion: @escaping (Result<URL, Error>) -> Void)  {
        let storageRef = storage.reference().child("\(uid)//\(name).jpg")
        storageRef.downloadURL { url, err in
            if err != nil {
                print((err?.localizedDescription)!)
                completion(.failure(err!))
            }
            if let url = url {
                completion(.success(url))
            }
        }
    }
}


extension UIImage {
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)

        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
