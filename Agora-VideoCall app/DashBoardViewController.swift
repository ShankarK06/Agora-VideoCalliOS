//
//  DashBoardViewController.swift
//  Agora-VideoCall app
//
//  Created by Shankar K on 16/08/21.
//

import UIKit

class DashBoardViewController: UIViewController {
    
//    @IBOutlet weak var videogroupCall: Neumorphic!
    @IBOutlet weak var videoCallOnetoone: Neumorphic!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // call one to one call
    @IBAction func VideoCall(sender: UIButton) {
        let VideoVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(VideoVC, animated: true)

    }
    
    @IBAction func groupCall(sender: UIButton) {
        //coming soon
    }
    
}
