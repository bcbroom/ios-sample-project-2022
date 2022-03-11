//
//  AppDelegate.swift
//  SampleApp
//
//  Created by Struzinski, Mark - Mark on 9/17/20.
//  Copyright © 2020 Lowe's Home Improvement. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // also see https://developer.apple.com/documentation/technotes/tn3105-customizing-uistatusbar-syle for status bar
    // see technote https://developer.apple.com/documentation/technotes/tn3106-customizing-uinavigationbar-appearance
    // also note that the .tintColor for the chevron color is on UINavigationBar.appearance() and *not* a UINavigationBarAppearance object
    // further ref here - https://sarunw.com/posts/uinavigationbar-changes-in-ios13/
    
    let standard = UINavigationBarAppearance()
    standard.configureWithOpaqueBackground()
    standard.backgroundColor = .systemBlue

    standard.titleTextAttributes = [.foregroundColor: UIColor.white]
    standard.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

    let button = UIBarButtonItemAppearance(style: .plain)
    button.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
    button.disabled.titleTextAttributes = [.foregroundColor: UIColor.lightText]
    button.highlighted.titleTextAttributes = [.foregroundColor: UIColor.label]
    button.focused.titleTextAttributes = [.foregroundColor: UIColor.white]

    standard.buttonAppearance = button
    standard.backButtonAppearance = button
    standard.doneButtonAppearance = button

    UINavigationBar.appearance().standardAppearance = standard
    UINavigationBar.appearance().scrollEdgeAppearance = standard
    UINavigationBar.appearance().tintColor = UIColor.white
    
    return true
  }
}
