//
//  SaveImageDNG.swift
//  AVCamera
//
//  Created by INNOIL007M on 25/08/22.
//

import Foundation
import SwiftUI
import Photos

class SaveImageDNG: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}

//dng
