//
//  ViewController.swift
//  iOS
//
//  Created by Jeong YunWon on 2016. 9. 24..
//  Copyright © 2016년 youknowone.org. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SpeakerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var textview: UITextView!
    var languagePicker: UIPickerView = UIPickerView()
    let speaker = Speaker.defaultSpeaker
    
    @IBAction func playClicked(_ sender: AnyObject) {
        if let text = self.textview.text {
            self.speaker.speakText(text: text)
        }
    }
    @IBAction func changeVoiceClicked(_ sender: AnyObject) {
        print("change voice")
        let alertView = UIAlertController(title: "Select Launguage", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.actionSheet);
        self.languagePicker.center.x = self.view.center.x
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertView.addAction(action)
        alertView.view.addSubview(languagePicker)
        present(alertView, animated: true, completion: nil)
    }
    
    func speaker(speaker: Speaker, didFinishSpeechString: String) {
        print("didFinishSpeechString : ", didFinishSpeechString)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languagePicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 300, height: 180))
        languagePicker.delegate = self
        languagePicker.dataSource = self
        languagePicker.showsSelectionIndicator = true
        languagePicker.tintColor = UIColor.red
        languagePicker.reloadAllComponents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "row : \(row)"
    }


}
