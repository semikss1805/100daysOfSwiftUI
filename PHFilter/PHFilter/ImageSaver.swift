//
//  ImageSaver.swift
//  PHFilter
//
//  Created by SemikSS on 20.01.2023.
//

import UIKit

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error, contextInfo: UnsafeRawPointer) {
        debugPrint("Save finished")
    }
}
