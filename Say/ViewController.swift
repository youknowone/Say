//
//  ViewController.swift
//  Say
//
//  Created by Jeong YunWon on 2015. 4. 10..
//  Copyright (c) 2015년 youknowone.org. All rights reserved.
//

import Cocoa
//import SayKit

func syncronizedData(tag: String, URL: NSURL) -> NSData {
    let standardUserDefaults = NSUserDefaults.standardUserDefaults()
    var iconData = standardUserDefaults.objectForKey(tag) as? NSData
    if iconData == nil {
        iconData = NSData(contentsOfURL: URL)
        standardUserDefaults.setObject(iconData!, forKey: tag)
        standardUserDefaults.synchronize()
    }
    return iconData!
}

class MainWindow: NSWindow {
    @IBOutlet var speechToolbarItem: NSToolbarItem! = nil;
    @IBOutlet var exportToolbarItem: NSToolbarItem! = nil;

    override func awakeFromNib() {
        super.awakeFromNib()
        self.speechToolbarItem.image = NSImage(data: syncronizedData("icon_speech", NSURL(string: "http://upload.wikimedia.org/wikipedia/commons/1/10/Exquisite-microphone.png")!))
        self.exportToolbarItem.image = NSImage(data: syncronizedData("icon_export", NSURL(string: "http://upload.wikimedia.org/wikipedia/commons/thumb/3/38/Gnome-generic-empty.svg/500px-Gnome-generic-empty.svg.png?uselang=ko")!))
    }
}

class MainWindowController: NSWindowController, NSWindowDelegate {
    func windowWillClose(notification: NSNotification) {

    }
}

class ViewController: NSViewController {

    @IBOutlet var textView: NSTextView! = nil;
    @IBOutlet var voiceComboBox: NSComboBox! = nil;
    let voiceSavePanel = NSSavePanel()
    let textOpenPanel = NSOpenPanel()

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(self.textView != nil)
        assert(self.voiceComboBox != nil)
        self.voiceSavePanel.allowedFileTypes = ["aiff"]

        self.voiceComboBox.addItemsWithObjectValues(SKVoice.voices.map({ "\($0.name)(\($0.locale)): \($0.comment)"; }))
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    var textForSpeech: String {
        get {
            return self.textView.string ?? ""
        }
    }

    var selectedVoice: SKVoice? {
        get {
            let index = self.voiceComboBox.indexOfSelectedItem
            if index <= 0 || index == NSNotFound {
                return nil
            } else {
                return SKVoice.voices[index - 1]
            }
        }
    }

    @IBAction func say(sender: NSControl) {
        sender.enabled = false
        SKSay(text: self.textForSpeech, voice: self.selectedVoice).play(true)
        sender.enabled = true
    }

    @IBAction func saveDocumentAs(sender: NSControl) {
        self.voiceSavePanel.runModal()
        if let URL = self.voiceSavePanel.URL {
            SKSay(text: self.textForSpeech, voice: self.selectedVoice).writeToURL(URL, atomically: true)
        }
    }

}

