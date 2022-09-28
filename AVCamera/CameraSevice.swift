//
//  CameraSevice.swift
//  AVCamera
//
//  Created by Alex Nagy on 13.08.2021.
//

import Foundation
import AVFoundation
import Photos

@objc(CameraSevice)
class CameraSevice: NSObject {
    
    var session: AVCaptureSession?
    var delegate: AVCapturePhotoCaptureDelegate?
    
    let output = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    @objc
    func start(delegate: AVCapturePhotoCaptureDelegate, completion: @escaping (Error?) -> ()) {
        self.delegate = delegate
        checkPermissions(completion: completion)
    }
    
    private func checkPermissions(completion: @escaping (Error?) -> ()) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self?.setupCamera(completion: completion)
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera(completion: completion)
        @unknown default:
            break
        }
    }
    
    private func setupCamera(completion: @escaping (Error?) -> ()) {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                session.beginConfiguration()
                if session.canAddInput(input) {
                    session.addInput(input)
                }

                if session.canAddOutput(output) {
                    print("canAddOutput")
                    session.addOutput(output)
                }
                
                session.sessionPreset = .photo

                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                session.commitConfiguration()
                session.startRunning()
                self.session = session
            } catch {
                completion(error)
            }
        }
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }

            // Use PHPhotoLibrary.shared().performChanges(...) to add assets.
        }
        
    }
    
//    private func setupCamera(completion: @escaping (Error?) -> ()) {
//        let session = AVCaptureSession()
//        // Get camera device.
//        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
//            print("Unable to get camera device.")
//            return
//        }
//        // Create a capture input.
//        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else {
//            print("Unable to obtain video input for default camera.")
//            return
//        }
//
//        // Make sure inputs and output can be added to session.
//        guard session.canAddInput(videoInput) else { return }
//        guard session.canAddOutput(output) else { return }
//
//        // Configure the session.
//        session.beginConfiguration()
//        session.sessionPreset = .photo
//        session.addInput(videoInput)
//        // availableRawPhotoPixelFormatTypes is empty.
//        session.addOutput(output)
//        // availableRawPhotoPixelFormatTypes should not be empty.
//        session.commitConfiguration()
//        session.startRunning()
//        self.session = session
//    }
    
    @objc
    func capturePhoto() {

        let processedFormat = [AVVideoCodecKey: AVVideoCodecType.hevc]


        
        if #available(iOS 14.3, *) {
//            let query = output.isAppleProRAWEnabled ?
//                { AVCapturePhotoOutput.isAppleProRAWPixelFormat($0) } :
//                { AVCapturePhotoOutput.isBayerRAWPixelFormat($0) }
            let query =
                { AVCapturePhotoOutput.isBayerRAWPixelFormat($0) }

            guard let rawFormat =
                    output.availableRawPhotoPixelFormatTypes.first(where: query) else {
                fatalError("No RAW format found.")
            }

            // Capture a RAW format photo, along with a processed format photo.
            let processedFormat = [AVVideoCodecKey: AVVideoCodecType.hevc]
            let photoSettings = AVCapturePhotoSettings(rawPixelFormatType: rawFormat,
                                                       processedFormat: processedFormat)

//            let captureDelegates = AVCapturePhotoCaptureDelegate(didFinishProcessingPhoto)
//            let delegate = RAWCaptureDelegate()
//            self.delegate = delegate
            
//
//            delegate.didFinish = {
//                print("didFinish")
//            }

//            let settings: AVCapturePhotoSettings = AVCapturePhotoSettings(rawPixelFormatType: rawFormat, processedFormat: processedFormat)
            output.capturePhoto(with: photoSettings, delegate: delegate!)
//            delegate.photoOutput(output, , error: <#T##Error?#>)
            
        }


    }
    
//    func capturePhoto() {
////        let photoOutput = AVCapturePhotoOutput()
//        // Photo settings for RAW capture.
//        let rawFormatType = kCVPixelFormatType_14Bayer_RGGB
//        // At this point the array should not be empty (session has been configured).
//        print("photoOutput.availableRawPhotoPixelFormatTypes: ", output.availableRawPhotoPixelFormatTypes)
//        guard output.availableRawPhotoPixelFormatTypes.contains(NSNumber(value: rawFormatType).uint32Value) else {
//            print("No available RAW pixel formats")
//            return
//        }
//
//        let photoSettings = AVCapturePhotoSettings(rawPixelFormatType: rawFormatType)
//        output.capturePhoto(with: photoSettings, delegate: self)
//    }
//
//    // MARK: - AVCapturePhotoCaptureDelegate methods
//
//    private func output(_ output: AVCapturePhotoOutput,
//                     didFinishProcessingRawPhoto rawSampleBuffer: CMSampleBuffer?,
//                     previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
//                     resolvedSettings: AVCaptureResolvedPhotoSettings,
//                     bracketSettings: AVCaptureBracketedStillImageSettings?,
//                     error: Error?) {
//        guard error == nil, let rawSampleBuffer = rawSampleBuffer else {
//            print("Error capturing RAW photo:\(error)")
//            return
//        }
//        // Do something with the rawSampleBuffer.
//    }
    
}
