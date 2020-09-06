//
//  AppDelegate.swift
//  Eitor
//
//  Created by Mert Ozkaya on 21.08.2020.
//  Copyright © 2020 Eitor. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        openVC()
        setupSVProgressHUD()
        return true
    }
    
    func openVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let newRoot = storyboard.instantiateInitialViewController() else {
            return
        }
        self.window?.rootViewController = newRoot
    }
    
    func setupSVProgressHUD(){
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setBackgroundColor(.clear)
        SVProgressHUD.setForegroundColor(.gray)
        SVProgressHUD.setRingThickness(6)
        SVProgressHUD.setFadeInAnimationDuration(0.3)
        SVProgressHUD.setFadeOutAnimationDuration(0.3)
        SVProgressHUD.setMinimumSize(CGSize(width: 100, height: 100))
        SVProgressHUD.setRingNoTextRadius(30)
        SVProgressHUD.setCornerRadius(16)
    }
}

