//
//  OwnDiceViewController.swift
//  Wuerfeln
//
//  Created by Arno Appenzeller on 06.01.19.
//  Copyright © 2019 APPenzeller. All rights reserved.
//

import UIKit
import MediaPlayer

class OwnDiceViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var diceMaximumSlider: UISlider!
    @IBOutlet weak var diceMinimumSlider: UISlider!
    @IBOutlet weak var diceMaximumLabel: UILabel!
    @IBOutlet weak var diceMinimumLabel: UILabel!
    
    @IBOutlet weak var diceResultLabel: UILabel!
    
    
    var currentMinimum:Float = 1
    var currentMax:Float = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(volumeChanged(notification:)),
                                               name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"),
                                               object: nil)
        
        let volumeView = MPVolumeView(frame: CGRect(x: -300, y: -300, width: 0, height: 0))
        self.view.addSubview(volumeView)
        
        diceMinimumSlider.minimumValue = 0
        diceMinimumSlider.maximumValue = 20
        diceMinimumSlider.value = currentMinimum
        
        diceMaximumSlider.minimumValue = 0
        diceMaximumSlider.maximumValue = 20
        diceMaximumSlider.value = currentMax
        
        backButton.layer.cornerRadius = 9
       

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        try! AVAudioSession.sharedInstance().setActive(true, options: [])
        try! AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [])
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func minimumSliderChanged(_ sender: Any) {
        //get current minimum value
        currentMinimum = (sender as! UISlider).value
        diceMinimumLabel.text = "Minimum Augenzahl: \(Int(currentMinimum))"
    }
    
    
    @IBAction func maximumSliderChanged(_ sender: Any) {
        //get current maximum value
        currentMax = (sender as! UISlider).value
        diceMaximumLabel.text = "Maximum Augenzahl: \(Int(currentMax))"
    }
    
    @objc func volumeChanged(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            if let volumeChangeType = userInfo["AVSystemController_AudioVolumeChangeReasonNotificationParameter"] as? String {
                if volumeChangeType == "ExplicitVolumeChange" {
                    rollDice()
                }
            }
        }
    }
    
    func rollDice(){
        let number = Int.random(in: Int(currentMinimum) ..< Int(currentMax+1))
        diceResultLabel.text = "\(number)"
        
        
    }
}
