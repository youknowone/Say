//
//  ViewController.swift
//  iOS
//
//  Created by Jeong YunWon on 2016. 9. 24..
//  Copyright © 2016년 youknowone.org. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SpeakerDelegate {
    
    @IBOutlet var textview: UITextView!
    let speaker = Speaker.defaultSpeaker
    
    @IBAction func playClicked(_ sender: AnyObject) {
        if let text = self.textview.text {
            self.speaker.speakText(text: text)
        }
    }
    @IBAction func changeVoiceClicked(_ sender: AnyObject) {
        print("change voice")
    }
    
    func speaker(speaker: Speaker, didFinishSpeechString: String) {
        print("didFinishSpeechString : ", didFinishSpeechString)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

