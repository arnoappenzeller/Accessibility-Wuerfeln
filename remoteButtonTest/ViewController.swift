//
//  ViewController.swift
//  remoteButtonTest
//
//  Created by Arno Appenzeller on 24.12.18.
//  Copyright © 2018 APPenzeller. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    @IBOutlet weak var diceEffectView: UIVisualEffectView!
    @IBOutlet weak var diceView: JAQDiceView!
    @IBOutlet weak var diceResultLabel: UILabel!
    
    @IBOutlet weak var ownDiceButton: UIButton!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ownDiceButton.layer.cornerRadius = 9
        ownDiceButton.alpha = 0.7
        
        diceView.delegate = self
        
        try! AVAudioSession.sharedInstance().setActive(true, options: [])
        try! AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [])
        NotificationCenter.default.addObserver(self, selector: #selector(volumeChanged(notification:)),
                                               name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"),
                                               object: nil)
        
        //try AVAudioSession.sharedInstance().setActive(true)
        
        diceEffectView.layer.cornerRadius = 9
        diceEffectView.layer.masksToBounds = true
        //audioPlayer.numberOfLoops = -1
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        
        //diceView.repositionDices()
        
        let frame = CGRect(x: -1000, y: -1000, width: 100, height: 100)
        let volumeView = MPVolumeView(frame: frame)
        volumeView.sizeToFit()
        self.view.addSubview(volumeView)
        //UIApplication.shared.beginReceivingRemoteControlEvents()
        //audioPlayer.play()
    }
    
    /*@IBAction func showOwnDiceView(_ sender: Any) {
    }*/
    
    @objc func volumeChanged(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            if let volumeChangeType = userInfo["AVSystemController_AudioVolumeChangeReasonNotificationParameter"] as? String {
                if volumeChangeType == "ExplicitVolumeChange" {
                    if self.isViewLoaded && (self.view.window != nil) {
                        // viewController is visible
                        diceView.rollTheDice(self)
                        print("roll the dice")
                    }
                }
            }
        }
    }    

}

extension ViewController:JAQDiceProtocol{
    func diceView(_ view: JAQDiceView!, rolledWithFirstValue firstValue: Int, secondValue: Int) {
        diceResultLabel.text = "Würfel 1: \(firstValue)     Würfel 2: \(secondValue)"
    }
    
}

