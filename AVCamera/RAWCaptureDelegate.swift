//
//  RAWCaptureDelegate.swift
//  AVCamera
//
//  Created by INNOIL007M on 25/08/22.
//

import Foundation
import AVFoundation
import Photos


@available(iOS 14, *)
class RAWCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    
    private var rawFileURL: URL?
    private var compressedData: Data?
    
    var didFinish: (() -> Void)?
    
    // Store the RAW file and compressed photo data until the capture finishes.
    
    // After both RAW and compressed versions are complete, add them to the Photos library.
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings,
                     error: Error?) {
        
        // Call the "finished" closure, if set.
        defer { didFinish?() }
        
        guard error == nil else {
            print("Error capturing photo: \(error!)")
            return
        }
        
        // Ensure the RAW and processed photo data exists.
        guard let rawFileURL = rawFileURL,
              let compressedData = compressedData else {
            print("The expected photo data isn't available.")
            return
        }
        
        // Request add-only access to the user's Photos library (if not already granted).
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            
            // Don't continue if not authorized.
            guard status == .authorized else { return }
            
            PHPhotoLibrary.shared().performChanges {
                let creationRequest = PHAssetCreationRequest.forAsset()
                // Save the RAW (DNG) file as the main resource for the Photos asset.
                let options = PHAssetResourceCreationOptions()
                options.shouldMoveFile = true
                creationRequest.addResource(with: .photo,
                                            fileURL: rawFileURL,
                                            options: options)

                // Add the compressed (HEIF) data as an alternative resource.
             
                creationRequest.addResource(with: .alternatePhoto,
                                            data: compressedData,
                                            options: nil)
                
            } completionHandler: { success, error in
                // Process the Photos library error.
            }
        }
    }
}
