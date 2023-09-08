//
//  SinglePlayerViewController.swift
//  JitGame
//
//  Created by salih kocatürk on 27.08.2023.
//

import UIKit

class SinglePlayerViewController: UIViewController {

    @IBOutlet weak var showRankings: UIButton!
    @IBOutlet weak var play: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func playButton(_ sender: Any) {
        performSegue(withIdentifier: "togm2", sender: nil)
    }
    
    @IBAction func showRankingsButton(_ sender: Any) {
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "togm2"{
            let destinationVC = segue.destination as? GameViewController
            destinationVC?.onlineIsActivated = 0
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
