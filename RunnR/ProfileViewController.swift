//
//  ProfileViewController.swift
//  RunnR
//
//  Created by MaKayla Day on 11/27/20.
//  Copyright © 2020 Codepath. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var numRunsLabel: UILabel!
    @IBOutlet weak var numMilesLabel: UILabel!
    @IBOutlet weak var numHrsLabel: UILabel!
    
    var runs = [PFObject]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadProfile()
    }
    func loadProfile(){
        self.userNameLabel.text = PFUser.current()?.username
        
        let query = PFQuery(className: "Runs")
        query.includeKey("author")
        query.whereKey("username", equalTo: PFUser.current()?.username)
        
        query.findObjectsInBackground { (runs, error) in
            if runs != nil {
                self.runs = runs!
                self.numRunsLabel.text = String(self.runs.count)
                
                var numMiles:Double = 0
                var numHours:Double = 0
                for run in self.runs{
                    numMiles += run["miles"] as! Double
                    numHours += run["finishedAt"] as! Double
                }
                self.numMilesLabel.text = String(format: "%.2f Mi", numMiles)
                self.numHrsLabel.text = String(format: "%.2f Hours", numHours)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
