//
//  TodayViewController.swift
//  Today
//
//  Created by Jeong YunWon on 2015. 5. 21..
//  Copyright (c) 2015년 youknowone.org. All rights reserved.
//

import Cocoa
import NotificationCenter
//import SayKit

class TodayViewController: NSViewController, NCWidgetProviding, NSTextFieldDelegate {

    @IBOutlet var playButton: NSButton!
    @IBOutlet var pauseButton: NSButton!
    @IBOutlet var textField: NSTextField! = nil
    
    var say:SayAPI! = SayAPI(text: "", voice: nil)
    var pause:Bool = false
    
    override var nibName: String? {
        return "TodayViewController"
    }
    
    @available(OSXApplicationExtension 10.10, *)
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        completionHandler(.noData)
    }

    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(insertNewline(_:)) {
            if !say.isplaying() {
                if self.pause{
                    self.pause = false
                    say.continueSpeaking()
                } else {
                    say = SayAPI(text: self.textField.stringValue )
                    say.play(false)
                }
            }
        }
        return false
    }
    
    @IBAction func say(_ control: NSControl) {
        if !say.isplaying() {
            if self.pause {
                say.continueSpeaking()
            } else {
                say = SayAPI(text: self.textField.stringValue )
                say.play(false)
            }
        }
    }
    
    @IBAction func pause(_ sender: NSControl) {
        self.pause = true
        say.pause()
    }
    
}
