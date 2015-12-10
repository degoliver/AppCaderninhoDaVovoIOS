//
//  ViewController.swift
//  CaderninoDaVovo
//
//  Created by Usuário Convidado on 25/11/15.
//  Copyright © 2015 Usuário Convidado. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class LoginViewController: BackgroundViewController , PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UITextFieldDelegate  {
    @IBOutlet weak var login_btn: UIButton!
    @IBOutlet weak var signup_btn: UIButton!
    @IBOutlet weak var loadimg: UIActivityIndicatorView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var user : String!
    var pass : String!
    override func viewWillDisappear(animated: Bool) {
       self.usernameField.text = nil
        self.passwordField.text = nil
        
    }
    override func viewDidAppear(animated: Bool) {
       // if(NSUserDefaults.standardUserDefaults().objectForKey("Usuario") != nil){
        
            // user = String!( NSUserDefaults.standardUserDefaults().objectForKey("Usuario")! as! String)!
            
           // pass = String!(NSUserDefaults.standardUserDefaults().objectForKey("senha")! as! String)!
            
           // print(self.user + pass)
            
            //PFUser.logInWithUsernameInBackground(user, password: pass, block: {(user, error ) -> Void in
              //  if((user) != nil){
                    
                    //var alert = UIAlertView(title: "Success", message: "Logged In", delegate: self, cancelButtonTitle: "OK")
                    //alert.show()
                //    self.performSegueWithIdentifier("toPrincipal",sender:nil)
                //}
                
            //})
        //}

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if(NSUserDefaults.standardUserDefaults().objectForKey("Usuario") != nil){
            self.loadimg.startAnimating()
            
            user = String!( NSUserDefaults.standardUserDefaults().objectForKey("Usuario")! as! String)!
            
            pass = String!(NSUserDefaults.standardUserDefaults().objectForKey("senha")! as! String)!
            self.usernameField.text = user
                self.passwordField.text = pass
            
            PFUser.logInWithUsernameInBackground(user, password: pass, block: {(user, error ) -> Void in
                if((user) != nil){
                    
                    //var alert = UIAlertView(title: "Success", message: "Logged In", delegate: self, cancelButtonTitle: "OK")
                    //alert.show()
                    self.performSegueWithIdentifier("toPrincipal",sender:nil)
                    self.loadimg.stopAnimating()
                }
                
            })
        }

    }
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.loadimg.transform = CGAffineTransformMakeScale(2.35, 2.35)
        //if(NSUserDefaults.standardUserDefaults().objectForKey("Usuario") != nil){
            //let user = String( NSUserDefaults.standardUserDefaults().objectForKey("Usuario"))
        
            //let pass = String(NSUserDefaults.standardUserDefaults().objectForKey("senha"))
            //print(user + pass)
           // PFUser.logInWithUsernameInBackground(user, password: pass, block: {(user, error ) -> Void in
                //if((user) != nil){
                    
                    //var alert = UIAlertView(title: "Success", message: "Logged In", delegate: self, cancelButtonTitle: "OK")
                    //alert.show()
                   //self.performSegueWithIdentifier("toPrincipal",sender:nil)
                //}
    
            //})
       // }

        // Do any additional setup after loading the view, typically from a nib.
        login_btn.backgroundColor = UIColor.whiteColor()
        login_btn.layer.cornerRadius = 5
        login_btn.layer.borderWidth = 2
        login_btn.layer.borderColor = UIColor.blackColor().CGColor
        signup_btn.backgroundColor = UIColor.whiteColor()
        signup_btn.layer.cornerRadius = 5
        signup_btn.layer.borderWidth = 2
        signup_btn.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func LoginAction(sender: UIButton) {
        self.loadimg.startAnimating()
        let username = self.usernameField.text
        let password = self.passwordField.text
        
        
        if(username?.utf16.count < 4 || password?.utf16.count < 5){
            
            Utils.alert("Erro", msg: "Usuário ou senha inválida")
            self.loadimg.stopAnimating()
        }else{
            PFUser.logInWithUsernameInBackground(username!, password: password!, block: {(user, error ) -> Void in
                if((user) != nil){
                    NSUserDefaults.standardUserDefaults().setValue(username! , forKey:"Usuario")
                    NSUserDefaults.standardUserDefaults().setValue( password!, forKey:"senha")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    //print(username! + password!)
                    //var alert = UIAlertView(title: "Success", message: "Logged In", delegate: self, cancelButtonTitle: "OK")
                    //alert.show()
                  self.performSegueWithIdentifier("toPrincipal", sender: sender )
                    self.loadimg.stopAnimating()
                }else{
                    Utils.alert("Erro", msg: "Não foi possível conectar")
                    self.loadimg.stopAnimating()
                }
            })
        }
    }
    
    @IBAction func SingUpAction(sender: UIButton) {
        performSegueWithIdentifier("toSingup", sender: sender )
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField == usernameField){
            passwordField.becomeFirstResponder()
        }else{
            passwordField.resignFirstResponder()
        }
        return false
    }
}

