//
//  ViewController.swift
//  Say
//
//  Created by Jeong YunWon on 2015. 4. 10..
//  Copyright (c) 2015년 youknowone.org. All rights reserved.
//

import Cocoa
import SayKit


/// Main window of the application
class MainWindow: NSWindow {
    @IBOutlet var speechToolbarItem: NSToolbarItem! = nil;
    @IBOutlet var exportToolbarItem: NSToolbarItem! = nil;

    override func awakeFromNib() {
        /** Load data from cache in NSUserDefaults or from URL.
        *
        *   Load data from cache in NSUserDefaults. If cache data doesn't exist
        *   in NSUserDefaults with given tag, download data from URL and save
        *   it to the given tag before loading.
        */
        func syncronizedData(tag: String, URL: NSURL) -> NSData? {
            let standardUserDefaults = NSUserDefaults.standardUserDefaults()
            let iconData = standardUserDefaults.objectForKey(tag) as? NSData
            if iconData == nil {
                if let iconData = NSData(contentsOfURL: URL) {
                    standardUserDefaults.setObject(iconData, forKey: tag)
                    standardUserDefaults.synchronize()
                    return iconData
                } else {
                    //print("Icon is not loadable!")
                }
            }
            return iconData
        }

        super.awakeFromNib()
        if let imageData = syncronizedData("icon_speech", URL: NSURL(string: "https://upload.wikimedia.org/wikipedia/commons/1/10/Exquisite-microphone.png")!) {
            self.speechToolbarItem.image = NSImage(data: imageData)
        }
        if let imageData = syncronizedData("icon_export", URL: NSURL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/38/Gnome-generic-empty.svg/500px-Gnome-generic-empty.svg.png?uselang=ko")!) {
            self.exportToolbarItem.image = NSImage(data: imageData)
        }
    }
}

/// The controller for main view in main window
class ViewController: NSViewController {
    /// Text view to speech
    @IBOutlet var textView: NSTextView! = nil;
    /// Combo box for voices. Default is decided by system locale
    @IBOutlet var voiceComboBox: NSComboBox! = nil;
    /// Save panel for "Export" menu
    let voiceSavePanel = NSSavePanel()
    /// Open panel for "Open" menu
    let textOpenPanel = NSOpenPanel()

    @available(OSX 10.10, *)
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(self.textView != nil)
        assert(self.voiceComboBox != nil)
        self.voiceSavePanel.allowedFileTypes = ["aiff"] // default output format is aiff. See `man say`

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

