//
//  SigningViewController.swift
//  JitGame
//
//  Created by salih kocatürk on 23.08.2023.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase
import FirebaseCore

class SigningViewController: UIViewController {

    
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        if userNameText.text != "" && passwordText.text != ""{ //kullanıcı oluşturma
            
            Auth.auth().signIn(withEmail: userNameText.text!, password: passwordText.text!){
                (authdata,error) in
                if error != nil{
                    self.makealert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                    
                    
                }
            }
            
        }else{
            makealert(titleInput: "Error", messageInput: "Username/ Password??")
            
            
        }
        
        performSegue(withIdentifier: "toTB", sender: nil)
    }
    
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        if userNameText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: userNameText.text!, password: passwordText.text!){(authdata, error) in
                if error != nil{
                    self.makealert(titleInput: "error", messageInput: error?.localizedDescription ?? "error")
                    
                }
                else{
                    self.performSegue(withIdentifier: "toTB", sender: nil)
                    
                }
            }
            
            
        }else{
            makealert(titleInput: "Error", messageInput: "Username/ Password??")
            
            
        }
        
        
    }
    func makealert(titleInput:String, messageInput: String ){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title:"okbutton", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(button)
        self.present(alert,animated: true, completion: nil)
        
    }
    
    
    @IBAction func gidsigninbutton(_ sender: GIDSignInButton) {
        signInWithGoogle()
    }
    
    
    @IBOutlet weak var gidsignin: GIDSignInButton!
    
    func signInWithGoogle(){
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
          guard error == nil else {
              
           return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
              
           return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential){ result, error in
                performSegue(withIdentifier: "toTB", sender: nil)
                // At this point, our user is signed in
              }
          return
            
        }
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
