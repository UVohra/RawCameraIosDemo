//
//  CustomCameraView.swift
//  AVCamera
//
//  Created by Alex Nagy on 13.08.2021.
//

import SwiftUI

@available(iOS 14.0, *)
struct CustomCameraView: View {
    
    let cameraService = CameraSevice()
    @Binding var capturedImage: UIImage?
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        ZStack {
            CameraView(cameraService: cameraService) { result in
                switch result {
                case .success(let photo):
                    if let data = photo.fileDataRepresentation() {
                        print("I am here")
                        print("capturedImage: ", capturedImage)
                        capturedImage = UIImage(data: data)
                        if let image = capturedImage {
                            let saveImage = SaveImageDNG()
                            saveImage.writeToPhotoAlbum(image: image)
                        }
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        print("Error: no image data found")
                    }
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }
            
            VStack {
                Spacer()
                Button(action: {
                    cameraService.capturePhoto()
                }, label: {
                    Image(systemName: "circle")
                        .font(.system(size: 72))
                        .foregroundColor(.white)
                })
                .padding(.bottom)
            }
        }
    }
}
