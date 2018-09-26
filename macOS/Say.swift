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
        let attributes = NSSpeechSynthesizer.attributes(forVoice: NSSpeechSynthesizer.VoiceName(rawValue: voiceIdentifier))
        self.init(text: text, voice: VoiceAPI(attributes: attributes))
    }
    /**
        Composite and play speech.
     
        - Parameter waitUntilDone: Currently ignored.
     */
    func play(_ waitUntilDone: Bool) {
        let voiceName = self.voice?.identifier
        self.speechSynthesizer.setVoice((voiceName != nil) ? NSSpeechSynthesizer.VoiceName(rawValue: voiceName!) : nil)
        self.speechSynthesizer.startSpeaking(text)
    }
    
    func continueSpeaking() {
        self.speechSynthesizer.continueSpeaking()
    }
    
    func pause() {
        self.speechSynthesizer.pauseSpeaking(at:.immediateBoundary)
    }
    func stop() {
        self.speechSynthesizer.stopSpeaking()
    }
    
    func isplaying()-> Bool {
        
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
        let voiceName = self.voice?.identifier
        self.speechSynthesizer.setVoice((voiceName != nil) ? NSSpeechSynthesizer.VoiceName(rawValue: voiceName!) : nil)
        self.speechSynthesizer.startSpeaking(text, to: URL)
    }
}
