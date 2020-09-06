//
//  Saver.swift
//  Eitor
//
//  Created by Mert Ozkaya on 29.08.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import Foundation
import UIKit
import Photos
import CoreGraphics

class Saver {

    private var albumName: String
    private var album: PHAssetCollection?

    init(albumName: String) {
        self.albumName = albumName

        if let album = getAlbum() {
            self.album = album
        }
    }
    
    private func getAlbum() -> PHAssetCollection? {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "title = %@", albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        return collection.firstObject ?? nil
    }

    private func createAlbum(completion: @escaping (Bool) -> ()) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: self.albumName)
        }, completionHandler: { (result, error) in
            if let error = error {
                print("PackageSaver createAlbum() error: \(error.localizedDescription)")
            } else {
                self.album = self.getAlbum()
                completion(result)
            }
        })
    }

    private func add(image: UIImage, completion: @escaping (Bool, Error?) -> ()) {
        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            if let album = self.album, let placeholder = assetChangeRequest.placeholderForCreatedAsset {
                guard let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)else { return }
                let enumeration = NSArray(object: placeholder)
                albumChangeRequest.addAssets(enumeration)
            }
        }, completionHandler: { (result, error) in
            completion(result, error)
        })
    }

    func saveImage(_ image: UIImage, completion: @escaping (Bool, Error?) -> ()) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else {
                // fail and redirect to app settings
                print("Unauthorized")
                return
            }

            if let _ = self.album {
                self.add(image: image) { (result, error) in
                    completion(result, error)
                }
                return
            }

            self.createAlbum(completion: { _ in
                print("saveImage() created album")
                self.add(image: image) { (result, error) in
                    completion(result, error)
                }
            })
        }
    }
}
