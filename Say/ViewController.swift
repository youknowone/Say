//
//  ViewController.swift
//  Say
//
//  Created by Jeong YunWon on 2015. 4. 10..
//  Copyright (c) 2015년 youknowone.org. All rights reserved.
//

import Cocoa
// import SayKit

/// Main window of the application
class MainWindow: NSWindow {
    @IBOutlet var speechToolbarItem: NSToolbarItem! = nil
    @IBOutlet var pauseToolbarItem: NSToolbarItem! = nil
    @IBOutlet var exportToolbarItem: NSToolbarItem! = nil
    @IBOutlet var openToolbarItem: NSToolbarItem! = nil
    @IBOutlet var stopToolbarItem: NSToolbarItem! = nil
    
    override func awakeFromNib() {
        /** Load data from cache in NSUserDefaults or from URL.
         *
         *   Load data from cache in NSUserDefaults. If cache data doesn't exist
         *   in NSUserDefaults with given tag, download data from URL and save
         *   it to the given tag before loading.
         */
        func syncronizedData(_ tag: String, URL: Foundation.URL) -> Data? {
            let standardUserDefaults = UserDefaults.standard
            let iconData = standardUserDefaults.object(forKey: tag) as? Data
            if iconData == nil {
                if let iconData = try? Data(contentsOf: URL) {
                    standardUserDefaults.set(iconData, forKey: tag)
                    standardUserDefaults.synchronize()
                    return iconData
                } else {
                    //print("Icon is not loadable!")
                }
            }
            return iconData
        }
        super.awakeFromNib()
        
        if let imageData = syncronizedData("icon_speech", URL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/1/10/Exquisite-microphone.png")!) {
            self.speechToolbarItem.image = NSImage(data: imageData)
        }
        if let imageData = syncronizedData("icon_pause", URL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/5/57/Pause_icon_status.png")!) {
            self.pauseToolbarItem.image = NSImage(data: imageData)
        }
        if let imageData = syncronizedData("icon_export", URL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/3/38/Gnome-generic-empty.svg/500px-Gnome-generic-empty.svg.png?uselang=ko")!) {
            self.exportToolbarItem.image = NSImage(data: imageData)
        }
        if let imageData = syncronizedData("icon_open", URL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/Inkscape_icons_document_import.svg/500px-Inkscape_icons_document_import.svg.png?uselang=ko")!) {
            //assert(self.openToolbarItem != nil)
            self.openToolbarItem.image = NSImage(data: imageData)
        }
        if let imageData = syncronizedData("icon_stop", URL: URL(string: "https://commons.wikimedia.org/wiki/File%3AStop_icon_status.png")!) {
            //assert(self.openToolbarItem != nil)
            self.stopToolbarItem.image = NSImage(data: imageData)
        }
    }
    
}

/// The controller for main view in main window
class ViewController: NSViewController {
    /// Text view to speech
    @IBOutlet var textView: NSTextView! = nil
    /// Combo box for voices. Default is decided by system locale
    @IBOutlet var voiceComboBox: NSComboBox! = nil
    /// Save panel for "Export" menu
    @IBOutlet var URLField: NSTextField! = nil;
    let voiceSavePanel = NSSavePanel()
    
    /// Open panel for "Open" menu
    let textOpenPanel = NSOpenPanel()
    
    @IBOutlet var alarmButton: NSButton!
    @IBOutlet var alarmHour: NSTextField!
    @IBOutlet var alarmMinute: NSTextField!
    @IBOutlet var alarmSecond: NSTextField!
    
    var alarmTime: Date! = nil
    var alarmTimer: Timer! = nil
    
    var say:SayAPI! = SayAPI(text: "hello",voice: nil)
    var pause:Bool = false
    
    @available(OSX 10.10, *)
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(self.textView != nil)
        assert(self.voiceComboBox != nil)
        self.voiceSavePanel.allowedFileTypes = ["aiff"] // default output format is aiff. See `man say`
        self.voiceComboBox.addItems(withObjectValues: VoiceAPI.voices.map({ "\($0.name)(\($0.locale)): \($0.comment)"; }))
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    var textForSpeech: String {
        let fullText = self.textView.string ?? ""
        var selectedText = fullText

        let selectedRange = self.textView.selectedRange()
        if selectedRange.length > 0 {
            selectedText = (selectedText as NSString).substring(with: selectedRange)
        }
        return selectedText
    }
    
    var selectedVoice: VoiceAPI? {
        get {
            let index = self.voiceComboBox.indexOfSelectedItem
            if index <= 0 || index == NSNotFound {
                return nil
            } else {
                return VoiceAPI.voices[index - 1]
            }
        }
    }
 
    func dialogOK(question: String, text: String) {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = question
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlertStyle.warning
        myPopup.addButton(withTitle: "OK")
        myPopup.runModal()
    }
    
    @IBAction func selectText(_ sender: NSTextField) {
        if let url = URL(string: sender.stringValue) {
            let instapaper = "https://www.instapaper.com/text?u="
            let instapaperURL = URL(string:"\(instapaper)\(url)")!
            // if URL format is right
            if let data = NSData(contentsOf: instapaperURL) {
                let dataString = String(data:data as Data, encoding:String.Encoding.utf8)!
                if let result = findMainClass(in: dataString) {
                    //textView.string = dataString//all html
                    textView.string = result
                } else {
                    dialogOK(question:"URL fetching error", text: "URL is not accessible")
                }
            } else {
                dialogOK(question:"URL fetching error", text: "URL is not accessible")            }
        } else {
            dialogOK(question:"URL fetching error", text: "URL is not accessible")
        }
    }
    
    @IBAction func say(_ sender: NSToolbarItem) {
        
        if !say.isplaying() {
            
            if self.pause{
            
                say.continueSpeaking()
            } else {
                
                say = SayAPI(text: self.textForSpeech, voice: self.selectedVoice)
                say.play(false)
                
            }
        }
    }
    func findMainClass(in dataString: String) -> String? {
        let unlinedString = dataString.replacingOccurrences(of: "\n", with: " ").replacingOccurrences(of: "\r", with: "")
        
        let regex = try! NSRegularExpression(pattern: "<main.*</main>", options: NSRegularExpression.Options())
        let result = regex.matches(in: unlinedString as String, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: unlinedString.characters.count))
        
        if result.count > 0 {
            let range = result[0].rangeAt(0)
            let text = (unlinedString as NSString).substring(with: range)
            
            let regexTag = try! NSRegularExpression(pattern: "<[^>]*>", options: NSRegularExpression.Options())
            var realResult = regexTag.stringByReplacingMatches(in: text, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: text.characters.count), withTemplate: "")
            textView.string = realResult
            return realResult
        } else {
            return nil
        }
    }
    @IBAction func pause(_ sender: NSControl) {
        
        self.pause = true
        say.pause()
    }
    @IBAction func stop(_ sender: NSControl) {
        
        self.pause = false
        say.stop()
        
    }
    
    @IBAction func saveDocumentAs(_ sender: NSControl) {
        self.voiceSavePanel.runModal()
        if let URL = self.voiceSavePanel.url {
            SayAPI(text: self.textForSpeech, voice: self.selectedVoice).writeToURL(URL, atomically: true)
        }
    }
    @IBAction func openTextFile(_ sender: NSControl) {
        self.textOpenPanel.runModal()
        do {
            if let URL = self.textOpenPanel.url{
                let text2 = try NSString(contentsOf: URL, encoding: String.Encoding.utf8.rawValue)
                self.textView.string = text2 as String
                
            }
            
        }
        catch {/* error handling here */}
    }
    
    @IBAction func setAlarm(_ sender: NSControl) {
        if alarmButton.state == NSOnState {
            let alarmDelayTime = self.alarmHour.intValue * 3600 + alarmMinute.intValue * 60 + alarmSecond.intValue
            self.alarmTime = Date().addingTimeInterval(TimeInterval(alarmDelayTime))
            self.alarmTimer = Timer(fireAt: alarmTime, interval: 0, target: self, selector: #selector(doAlarm), userInfo: nil, repeats: false)
            RunLoop.main.add(alarmTimer, forMode: RunLoopMode.commonModes)
        } else if alarmButton.state == NSOffState {
            self.alarmTimer.invalidate()
        }
    }
    
    func doAlarm() {
        if !say.isplaying() {
            if self.pause{
                say.continueSpeaking()
            } else {
                say = SayAPI(text: self.textForSpeech, voice: self.selectedVoice)
                say.play(false)
            }
        }
        alarmButton.state = NSOffState
    }

}

