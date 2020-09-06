//
//  PermissionHelpers.swift
//  Eitor
//
//  Created by Mert Ozkaya on 1.07.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import Foundation
import AVKit
import Photos

class PermissionsHelpers {
    //MARK:- İzin alınıp alınmadığını kontrol etmek için
    static func cameraPermissionsRequested() -> Bool{
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .notDetermined {
            print("cameraPermissionsRequested daha önce sorulmamış")
            return false
        }else{
            print("cameraPermissionsRequested daha önce sorulmuş")
            return true
        }
    }
    
    static func microphonePermissionsRequested() -> Bool {
        if AVAudioSession.sharedInstance().recordPermission == .undetermined {
            print("microphonePermissionsRequested daha önce sorulmamış")
            return false
        }else{
            print("microphonePermissionsRequested daha önce sorulmuş")
            return true
        }
    }

    //MARK:- İzin durumunu kontrol etmek için
    static func cameraAuthorizationStatus() -> Bool{
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        switch cameraAuthorizationStatus {
        case .denied,.notDetermined:
            return false
        case .authorized, .restricted:
            return true
        @unknown default:
            fatalError()
        }
    }
    
    static func microphoneAuthorizationStatus() -> Bool {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            return true
        case AVAudioSession.RecordPermission.denied:
            return false
        case AVAudioSession.RecordPermission.undetermined:
            return false
        @unknown default:
            fatalError()
        }
    }
    
    //MARK:- İzin Almak için
    static func showCameraPermissions(completion: @escaping (_ success: Bool)-> Void)   {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
            DispatchQueue.main.async {
                if granted {
                    completion(true)
                }else{
                    completion(false)
                }
            }
        }
    }
    
    static func showMicroPhonePermission(completion: @escaping (_ success: Bool)-> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
            if granted {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    //MARK:- Galeri İzin Almak için
    static func checkPhotoLibraryPermission(completion: @escaping (_ success: Bool)-> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                completion(true)
            case .denied, .restricted:
                completion(false)
            case .notDetermined:
                completion(false)
            @unknown default:
                fatalError()
            }
        }
    }
    
}
