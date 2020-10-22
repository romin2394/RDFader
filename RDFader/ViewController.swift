//
//  ViewController.swift
//  RDFader
//
//  Created by Romin Dhameliya on 9/8/20.
//  Copyright © 2020 Romin Dhameliya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var slider: RDFader!
    @IBOutlet weak var minimumLabel: UILabel!
    @IBOutlet weak var maximumLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = Int(slider.value)
        self.slider.setValue(Float(value), animated: true)
        
        self.minimumLabel.text = "\(slider.minimum)cm"
        self.maximumLabel.text = "\(slider.maximum)cm"
        // Do any additional setup after loading the view.
    }

    @IBAction func faderValueChange(_ sender: RDFader) {
        print(String(format: "%.1fcm", sender.value))
    }
}

