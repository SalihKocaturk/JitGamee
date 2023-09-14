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
class searchingMailId{
    var searchingValue = 0//0 is not searchin 1 means searching
    var userEmail = ""
    init(scvalue: Int = 0, userEmail: String = "") {
        self.searchingValue = scvalue
        self.userEmail = userEmail
    }
    init(){
        
        
    }
}
class multiPlayerViewController: UIViewController {
    var searching = 0
    var userEmail = ""
    var userEmailArray = [String]()
    var userEmailArrayLength = 0
    var idOfSearch = 0
    var idOfSearchArray = [Int]()
    var postId = 0
    var idOfSearchDone = 0
    var documentidarray = [String]()
    var searchingArray = [Int]()
    var searchMailArray = [searchingMailId]()
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
                                    self.userEmailArray.append(userEmail0)
                                    //ilk başta hepsini arraye ekle sonra yap
                                    if var searching0 = document.get("searching") as? Int{
                                        self.searchingArray.append(searching0)
                                        if var idOfSearch0 = document.get("idOfSearch") as? Int{
                                            self.idOfSearchArray.append(idOfSearch0)
                                            let ss = searchingMailId(scvalue: idOfSearch0,userEmail: userEmail0)
                                            self.searchMailArray.append(ss)
                                        }
                                    }
                                }
                            }
                            
                            
                        }
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                }
                else {
                    firestoredb.collection("PlayOnline").addSnapshotListener { snapshot, error in
                        if error != nil {
                            print(error?.localizedDescription ?? "error")
                        }else{
                            if snapshot?.isEmpty == false{
                                for document in snapshot!.documents{
                                    let documentID = document.documentID
                                    self.documentidarray.append(documentID)
                                    if var idOfSearch0 = document.get("idOfSearch") as? Int {
                                        
                                        
                                        
                                    }
                                    
                                }
                                
                                
                            }
                            
                            
                        }
                        //setting datas
                        var firestorereferenc: DocumentReference? = nil
                        self.searching = 1
                        let firestorepost = ["userEmail": self.userEmail, "searching": self.searching,"idOfSearch": self.idOfSearch] as [String : Any]
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
}
