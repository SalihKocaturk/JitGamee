//
//  GameViewController.swift
//  JitGame
//
//  Created by salih kocatürk on 23.08.2023.
//

import UIKit
import SpriteKit
import GameplayKit
import Firebase
import FirebaseFirestore
import FirebaseCore
class GameViewController: UIViewController {
    //Variables
    
    @IBOutlet weak var restartButton: UIButton!
    var documentidarray = [String]()
    var enemyScore = 0
    var OkbuttonPressed = 0
        var score = 0
        var gameStarted = 0
        var timer = Timer()
        var counter = 0
        var kennyArray = [UIImageView]()
        var hideTimer = Timer()
        var highScore = 0
       var onlineIsActivated = 0
    
    @IBOutlet weak var enemyScoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func viewDidLoad() {
        restartButton.isHidden = true
        
        enemyScoreLabel.isHidden = true
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        counter = 10
       
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = false
                    view.showsNodeCount = false
                }
            }
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func RestartButtonTabbed(_ sender: Any) {
        self.gameStarted = 1
        let firestoreDatabase = Firestore.firestore()//firstore databesee erişiyoruz
        var firestorereferenc: DocumentReference? = nil
        let firestorepost = ["gameStarted": self.gameStarted] as [String : Int]
        firestorereferenc = firestoreDatabase.collection("GS").addDocument(data: firestorepost, completion: {(error) in//referansa değerleri koyuyoruz
            if error != nil{
                print("error", error?.localizedDescription ?? "error")
                
            }else{
                
                
                
            }
            
        })
        
        self.counter = 10
        self.timeLabel.text = String(self.counter)
        
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)

        restartButton.isHidden = true
        
        
    }
    @objc func countDown() {
             
             counter -= 1
             timeLabel.text = "Time:\(String(counter))"
             
             if counter == 0 {
                 timer.invalidate()
                 hideTimer.invalidate()
                 
                 for kenny in kennyArray {
                     kenny.isHidden = true
                 }
                 
                 //HighScore
                 
                 if self.score > self.highScore {
                     self.highScore = self.score
                     
                     UserDefaults.standard.set(self.highScore, forKey: "highscore")
                 }
                 
                 
                 //Alert
                 
                 let alert = UIAlertController(title: "Time's Up", message: "Do you want to play again?", preferredStyle: UIAlertController.Style.alert)
                 let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel ){(UIAlertAction) in
                     self.OkbuttonPressed = 1
                     self.restartButton.isHidden = false
                     let firestoreDatabase = Firestore.firestore()//firstore databesee erişiyoruz
                     var firestorereferenc: DocumentReference? = nil
                     let firestorepost = ["okBut": self.OkbuttonPressed] as [String : Int]
                     firestorereferenc = firestoreDatabase.collection("OS").addDocument(data: firestorepost, completion: {(error) in//referansa değerleri koyuyoruz
                         if error != nil{
                             print("error", error?.localizedDescription ?? "error")
                             
                         }else{
                             self.restartButton.isHidden = false
                             
                             
                         }
                         
                     })
                     
                     self.counter = 10
                     self.timeLabel.text = String(self.counter)
                     
                     
                     
                     
                 }
                 
                 let replayButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) { (UIAlertAction) in
                     //replay function
                     self.restartButton.isHidden = true
                     self.gameStarted = 1
                     let firestoreDatabase = Firestore.firestore()//firstore databesee erişiyoruz
                     var firestorereferenc: DocumentReference? = nil
                     let firestorepost = ["gameStarted": self.gameStarted] as [String : Int]
                     firestorereferenc = firestoreDatabase.collection("GS").addDocument(data: firestorepost, completion: {(error) in//referansa değerleri koyuyoruz
                         if error != nil{
                             print("error", error?.localizedDescription ?? "error")
                             
                         }else{
                             
                             
                             
                         }
                         
                     })
                     
                     self.counter = 10
                     self.timeLabel.text = String(self.counter)
                     
                     
                     self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
                  
                 }
                 
                 alert.addAction(okButton)
                 alert.addAction(replayButton)
                 self.present(alert, animated: true, completion: nil)
                 
                 
                 
             }
             
         }
    @IBAction func goBackButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toChooseSc", sender: nil)
        
    }
    

}
