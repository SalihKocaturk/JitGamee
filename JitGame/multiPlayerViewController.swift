//
//  multiPlayerViewController.swift
//  JitGame
//
//  Created by salih kocatürk on 27.08.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseStorage
class HighScore{
    var searchingValue = 0//0 is not searchin 1 means searching
    var userEmail = ""
    init(highscorevalue: Int = 0, userEmail: String = "") {
        self.searchingValue = highscorevalue
        self.userEmail = userEmail
    }
    init(){
        
        
    }
}
class multiPlayerViewController: UIViewController {
    var searching = 0
    var userEmail = ""
    var idOfSearch = 0
    var documentidarray = [String]()
    var searchingArray = [Int]()
    @IBOutlet weak var searchOpponent: UIButton!
    @IBOutlet weak var showRankings: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchOpponentButton(_ sender: Any) {
        playOnline()
        
        
        
        
        
    }
    
    @IBAction func showRankings(_ sender: Any) {
        performSegue(withIdentifier: "toRanking1", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "togm1"{
            let destinationVC = segue.destination as? GameViewController
            destinationVC?.onlineIsActivated = 1
        }
    }
    func playOnline(){
        var a = Auth.auth().currentUser
        userEmail = "\(a)"
        let firestoredb = Firestore.firestore()
        
        firestoredb.collection("PlayOnline").addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "error")
            }else{
                if snapshot?.isEmpty == false{
                    for document in snapshot!.documents{
                        let documentID = document.documentID
                        self.documentidarray.append(documentID)
                        
                        //add date
                        //getting datas
                        if var idOfSearch0 = document.get("idOfSearch") as? Int {
                            print("ilumni")
                            if var userEmail0 = document.get("userEmail") as? String{
                                if userEmail0 != self.userEmail{
                                    //classla yeni değişken tanımla ve idOfSearch ve searchingi birlikte tanımla(öyle göndermeyi dene), 
                                    //ilk başta hepsini arraye ekle sonra yap
                                    if var searching0 = document.get("searching") as? Int{
                                        if searching0 == 1 {
                                            self.idOfSearch = idOfSearch0
                                            self.performSegue(withIdentifier: "togm1", sender: nil)
                                            self.idOfSearch += 1
                                        }
                                    }
                                }
                            }
                            
                            
                         }
                         
                            
                        
                        
                    }
                   
              
                   
                  
                }
                else {
                    //setting datas
                    var firestorereferenc: DocumentReference? = nil
                    let firestorepost = ["userEmail": self.userEmail, "searching": self.searching] as [String : Any]
                }
            }
        }
    }

    /*
    // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "toDetailsVC"{
             let destinationVC = segue.destination as? SecViewController
             
             destinationVC?.chosenPainting = selectedPainting
             destinationVC?.chosenPaintingId = selectedPaintinId
         }
     }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
