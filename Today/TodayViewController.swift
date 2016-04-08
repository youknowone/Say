//
//  TodayViewController.swift
//  Today
//
//  Created by Jeong YunWon on 2015. 5. 21..
//  Copyright (c) 2015년 youknowone.org. All rights reserved.
//

import Cocoa
import NotificationCenter
import SayKit

class TodayViewController: NSViewController, NCWidgetProviding, NSTextFieldDelegate {

    override var nibName: String? {
        return "TodayViewController"
    }

    @available(OSXApplicationExtension 10.10, *)
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        completionHandler(.NoData)
    }

    func control(control: NSControl, textView: NSTextView, doCommandBySelector commandSelector: Selector) -> Bool {
        if commandSelector == "insertNewline:" {
            let say = SKSay(text: textView.string ?? "")
            say.play(false)
        }
        return false
    }
}
