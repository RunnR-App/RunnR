//
//  RunButton.swift
//  RunnR
//
//  Created by MaKayla Day on 11/27/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit

class RunButton: UIButton {
    
    var isRunning:Bool = false
    
    func changeStatus(){
        if (isRunning){
            // We want to finish the run
            self.backgroundColor = UIColor.green
            isRunning = false
        } else {
            // We want to start a run
            self.backgroundColor = UIColor.red
            isRunning = true;
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
        self.layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
