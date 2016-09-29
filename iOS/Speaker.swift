//
//  Speaker.swift
//  BotTalk
//
//  Created by Jeong YunWon on 2016. 7. 7..
//  Copyright © 2016년 youknowone.org. All rights reserved.
//

import Foundation
import AVFoundation

public class Speaker: NSObject, AVSpeechSynthesizerDelegate {
    static let defaultSpeaker = Speaker()
    var volume: Float = 1.0
    var mute = false
    var voice = AVSpeechSynthesisVoice(language: "en-US")     // set default language : english (temporarily)
    var voices = AVSpeechSynthesisVoice.speechVoices()
    var delegate: SpeakerDelegate?
    var rate: Float = AVSpeechUtteranceDefaultSpeechRate
    
    let synthesizer = AVSpeechSynthesizer()

    override init() {
        super.init()
        self.synthesizer.delegate = self
    }

    public func stopSpeaking() {
        self.synthesizer.stopSpeaking(at: .word)
    }

    public func pauseSpeaking() {
        self.synthesizer.pauseSpeaking(at: .immediate)
    }

    public func continueSpeaking() {
        self.synthesizer.continueSpeaking()
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        delegate?.speaker(speaker: self, didFinishSpeechString: utterance.speechString)
    }

    public func speakText(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.volume = self.mute ? 0.0 : self.volume
        utterance.voice = self.voice
        utterance.rate = self.rate
        self.synthesizer.speak(utterance)
    }
    
    public func changeLanguage(language: String) {
        self.voice = AVSpeechSynthesisVoice(language: language)
    }
}

protocol SpeakerDelegate {
    func speaker(speaker: Speaker, didFinishSpeechString: String);
}
