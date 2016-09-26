//
//  Say.swift
//  Say
//
//  Created by Seungwon Kim on 2016. 9. 24..
//  Copyright © 2016년 youknowone.org. All rights reserved.
//

import Cocoa

/**
    Easy-to-use interface for `say` command in OS X.
*/
class SayAPI: NSObject {
    let speechSynthesizer: NSSpeechSynthesizer
    var text: String
    var voice: VoiceAPI?
    
    var outputFile: String? = nil
    
    override var description: String {
        get {
            return "<Say: '\(self.text)'>"
        }
    }

    /**
        Construct a say interface with given text and voice.
     
        - Parameters:
        - text: A text string to composite speech.
        - voice: A voice to composite speech. If given voice is nil, default voice is used.
     */
    init(text: String, voice: VoiceAPI?) {
        self.speechSynthesizer = NSSpeechSynthesizer.init()
        self.text = text
        self.voice = voice
        super.init()
    }
    
    /**
        Construct a say interface with given text and default voice.
     
        - Parameter text: A text string to composite speech.
     */
    public convenience init(text: String) {
        self.init(text: text, voice: nil)
    }
    
    /**
        Construct a say interface with given text and voice with given voice name.
     
        - Parameter text: A text string to composite speech.
        - Parameter voiceIdentifier: A voice identifier to composite speech. If given voice name is invalid, nil is returned.
    */
    public convenience init?(text: String, voiceIdentifier: String) {
        self.init(text: text, voice: VoiceAPI.init(dictionary: NSSpeechSynthesizer.attributes(forVoice: voiceIdentifier)))
    }

    /**
        Composite and play speech.
     
        - Parameter waitUntilDone: Currently ignored.
     */
    func play(_ waitUntilDone: Bool) {
        self.speechSynthesizer.setVoice(self.voice?.identifier)
        self.speechSynthesizer.startSpeaking(text)
    }
    
    func pause(){
        
        self.speechSynthesizer.stopSpeaking()
    }
    
    func isplaying()-> Bool{
        
        return self.speechSynthesizer.isSpeaking
        
    }
    
    /**
        Composite and write speech to URL.
     
        File format is .aiff.
     
        - Parameters:
        - URL: File URL to write speech.
        - atomically: Currently ignored.
     */
    func writeToURL(_ URL: Foundation.URL, atomically: Bool) {
        self.speechSynthesizer.setVoice(self.voice?.identifier)
        self.speechSynthesizer.startSpeaking(text, to: URL)
    }
}
