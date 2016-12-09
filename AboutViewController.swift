//
//  AboutViewController.swift
//  BoxerLuv
//
//  Created by Nick Adcock on 12/6/16.
//  Copyright © 2016 NEA. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet var messageScrollView: UITextView!
    
    override func viewDidAppear(_ animated: Bool) {
        messageScrollView.isScrollEnabled = true
        
    }
}
