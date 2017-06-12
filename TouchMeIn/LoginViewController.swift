//
//  LoginViewController.swift
//  TouchMeIn
//
//  Created by akhil mantha on 12/06/17.
//  Copyright © 2017 iT Guy Technologies. All rights reserved.
//

import UIKit
import CoreData

struct KeychainConfiguration{
    
    static let serviceName = "TouchMeIn"
    static let accessGroup : String? = nil
    
    
}

class LoginViewController: UIViewController {
  
  var managedObjectContext: NSManagedObjectContext?
    
    var passwordItems : [KeychainPasswordItem] = []
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    //creating a reference of the touch id swift file
    let touchMe = TouchIDAuth()
    @IBOutlet weak var loginButton : UIButton!
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var createInfoLabel: UILabel!  

    @IBOutlet weak var touchIDButton: UIButton!
    
    
  override func viewDidLoad() {
    super.viewDidLoad()
    touchIDButton.isHidden = !touchMe.canEvaluatePolicy()
    
    let hasLogin = UserDefaults.standard.bool(forKey: "hasLoginKey")
    
    if hasLogin{
        loginButton.setTitle("Login", for: .normal)
        loginButton.tag = loginButtonTag
        createInfoLabel.isHidden = true
    }else {
      
       loginButton.setTitle("Create", for: .normal)
        loginButton.tag = createLoginButtonTag
        createInfoLabel.isHidden = false
    }
    
  }
    

// touch id functionality
    
    
    
    @IBAction func touchIDLoginAction(_ sender: UIButton) {
        
        
        touchMe.authenticateUser() {
            message in
            if let message = message {
                let alertView = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Darn", style: .default)
                alertView.addAction(okAction)
            } else{
                self.performSegue(withIdentifier: "dismissLogin", sender: self)
            }
        }
        }

  
  // MARK: - Action for checking username/password
  @IBAction func loginAction(_ sender: AnyObject) {
    guard
      let newAccountName = usernameTextField.text,
      let newPassword = passwordTextField.text,
        !newAccountName.isEmpty && !newPassword.isEmpty else {
            
            let alertView = UIAlertController(title: "Login Problem", message: "The login credentials are wrong", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Failed Again!", style: .default, handler: nil)
            alertView.addAction(okAction)
            present(alertView, animated: true, completion: nil)
            return
            
    }
      usernameTextField.resignFirstResponder()
      passwordTextField.resignFirstResponder()
    if sender.tag == createLoginButtonTag{
        let hasLoginKey = UserDefaults.standard.bool(forKey: "hasLoginKey")
        if !hasLoginKey{
            UserDefaults.standard.setValue(usernameTextField.text, forKey: "username")
     }
        do{ //create a new keychain item
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: newAccountName, accessGroup: KeychainConfiguration.accessGroup)
            
         try passwordItem.savePassword(newPassword)
        }catch{
            fatalError("error updating the keychain - \(error)")
        }
        UserDefaults.standard.set(true, forKey: "hasLoginKey")
        loginButton.tag = loginButtonTag
        performSegue(withIdentifier: "dismissLogin", sender: self)
    } else if sender.tag == loginButtonTag {
        if checkLogin(username: usernameTextField.text!, password: passwordTextField.text!){
            performSegue(withIdentifier: "dismissLogin", sender: self)
        }
        else{
            
            let alertView = UIAlertController(title: "Login Problem ", message: "Wrong username & password", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Failed Again!", style: .default)
            alertView.addAction(okAction)
            present(alertView, animated: true, completion: nil)
            
        }
    }
        
    }
    
    }
    func checkLogin(username: String, password : String) -> Bool {
        guard username == UserDefaults.standard.value(forKey: "username") as? String else {
            return false
        }
        do {
            let passwordItem =  KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: username, accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            return password == keychainPassword
        }catch{
           fatalError("Error reading password from keychain - \(error)")
        }
        return false
    }
  

