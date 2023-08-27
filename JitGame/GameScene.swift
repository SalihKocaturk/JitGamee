//
//  GameScene.swift
//  JitGame
//
//  Created by salih kocatürk on 23.08.2023.
//
import UIKit
import SpriteKit
import GameplayKit
import FirebaseStorage
import Firebase
import FirebaseCore
import SDWebImage
class GameScene: SKScene {
    var openedNow = 0
    var timer = Timer()
    var counter = 0
    var forOkButton = 0//for assigning the value of okButton
    var documentidarray = [String]()
    var score = 0
    var hideTimer = Timer()
    var highScore = 0
    var obh = 0//for not being able to play the game while okeybutton is clicked
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var clickBox = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    var k = 0//timer starting value
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func sceneDidLoad() {
       getReplayButton()
    getOkButton()
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: 0, y: self.frame.height / 4)
        scoreLabel.zPosition = 2
        let boxtexture = SKTexture(imageNamed: "photoforapp")
        let size = CGSize(width: boxtexture.size().width / 12, height: boxtexture.size().height / 12)
         clickBox = childNode(withName: "clickToPlay") as! SKSpriteNode
        clickBox.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.lastUpdateTime = 0
        clickBox.physicsBody?.affectedByGravity = false
        // Get label node from scene and store it for use later
       
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        self.addChild(scoreLabel)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    @objc override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
           

            let touchLocation = touch.location(in:self)
            let touchNodes = nodes(at: touchLocation)//değdiğimiz lokasyondaki nodelar bird nodeuna eşitse....
            if touchNodes.isEmpty == false{
                
                counter = 10
                
                
                for node in touchNodes {
                    
                    if let sprite = node as? SKSpriteNode{
                        if forOkButton != 1 || openedNow == 0{
                            if sprite == clickBox{
                                
                                self.clickBox.texture = SKTexture(imageNamed: "photoforapp1")
                                
                                
                                k = k + 1
                                
                                for t in touches { self.touchDown(atPoint: t.location(in: self)) }
                                
                                score += 1
                                if score > 1 {
                                    score = score - 1
                                    let firestoreDatabase = Firestore.firestore()//firstore databesee erişiyoruz
                                    var firestorereferenc: DocumentReference? = nil
                                    let firestorepost = ["Score": score] as [String : Int]
                                    firestorereferenc = firestoreDatabase.collection("Posts").addDocument(data: firestorepost, completion: {(error) in//referansa değerleri koyuyoruz
                                        if error != nil{
                                            print("error", error?.localizedDescription ?? "error")
                                            
                                        }else{
                                            
                                            
                                            
                                        }
                                        
                                    })
                                    
                                }//if gameove == true
                                scoreLabel.text = "Your Score:\(String(score))"
                                
                            }
                        }
                    }
                }
                
            }
            
        }
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
   
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            
            let touchLocation = touch.location(in:self)
            let touchNodes = nodes(at: touchLocation)//değdiğimiz lokasyondaki nodelar bird nodeuna eşitse....
            if touchNodes.isEmpty == false{
                

                
                
                for node in touchNodes {
                    if let sprite = node as? SKSpriteNode{
                        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
                        if sprite == clickBox{
                            score += 1
                            print(score)
                            
                        }
                        
                    }
                }
            }
            
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            
            let touchLocation = touch.location(in:self)
            let touchNodes = nodes(at: touchLocation)//değdiğimiz lokasyondaki nodelar bird nodeuna eşitse....
            if touchNodes.isEmpty == false{
                

                
                
                for node in touchNodes {
                    if let sprite = node as? SKSpriteNode{
                        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
                        if sprite == clickBox{
                            score += 1
                            print(score)
                            
                        }
                        
                    }
                }
            }
            
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
    func getReplayButton(){
        let firestoredb = Firestore.firestore()
        firestoredb.collection("GS").addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "error")
            }else{
                if snapshot?.isEmpty == false{
                    for document in snapshot!.documents{
                        let documentID = document.documentID
                        self.documentidarray.append(documentID)
                        
                        
                        if var gameStarted = document.get("gameStarted") as? Int {
                            print("ilumni")
                            if gameStarted == 1 {
                                self.forOkButton = 0
                                self.score = 0
                                
                            }else{
                                self.clickBox.texture = SKTexture(imageNamed: "photoforapp")
                            }
                            
                            
                            
                         }
                         
                            
                        
                        
                    }
                   
              
                   
                  
                }
            }
        }
    }
    func getOkButton(){
        let firestoredb = Firestore.firestore()
        firestoredb.collection("OS").addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "error")
            }else{
                if snapshot?.isEmpty == false{
                    for document in snapshot!.documents{
                        let documentID = document.documentID
                        self.documentidarray.append(documentID)
                        
                        
                        if var okbut = document.get("okBut") as? Int {
                            print("ilumni")
                            if okbut == 1 {
                                self.openedNow == 1
                                self.forOkButton = 1
                                self.score = 0
                                self.clickBox.texture = SKTexture(imageNamed: "photoforapp")
                                
                            }
                            
                            
                            
                         }
                         
                            
                        
                        
                    }
                   
              
                   
                  
                }
            }
        }
    }
    func delete(collection: CollectionReference, batchSize: Int = 100) {
        // Limit query to avoid out-of-memory errors on large collections.
        // When deleting a collection guaranteed to fit in memory,
        // batching can be avoided entirely.
        collection.limit(to: batchSize).getDocuments { (docset, error) in
            // An error occurred.
            let docset = docset
            let batch = collection.firestore.batch()
            docset?.documents.forEach {
                batch.deleteDocument($0.reference)
            }
            batch.commit {_ in
                self.delete(collection: collection, batchSize: batchSize)
            }
        }
    }
}
