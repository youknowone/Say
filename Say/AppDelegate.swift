//
//  AppDelegate.swift
//  Say
//
//  Created by Jeong YunWon on 2015. 4. 10..
//  Copyright (c) 2015년 youknowone.org. All rights reserved.
//

import Cocoa
//import Fabric
//import Crashlytics

@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // force app to be terminated after closing
        return true
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //Fabric.with([Crashlytics()])
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

