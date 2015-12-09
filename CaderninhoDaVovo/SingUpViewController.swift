//
//  SingUpViewController.swift
//  CaderninoDaVovo
//
//  Created by Usuário Convidado on 25/11/15.
//  Copyright © 2015 Usuário Convidado. All rights reserved.
//

import UIKit
import Parse

class SingUpViewController: BackgroundViewController {
   
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var signup_btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signup_btn.backgroundColor = UIColor.whiteColor()
        signup_btn.layer.cornerRadius = 5
        signup_btn.layer.borderWidth = 2
        signup_btn.layer.borderColor = UIColor.blackColor().CGColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func SingUpAction(sender: UIButton) {
        let name = self.nameField.text
        let username = self.usernameField.text
        let password = self.passwordField.text
        let email = self.emailField.text
        
        if(name?.utf16.count < 3){
            Utils.alert("Erro",msg: "Nome Inválido")
        }else if(username?.utf16.count < 4 || password?.utf16.count < 5){
            Utils.alert("Erro",msg: "Usuário ou Senha Inválida")
        }else if(email?.utf16.count < 8){
            Utils.alert("Erro",msg: "Email Inválido")
        }else{
            let newUser = PFUser()
            newUser.username = username
            newUser.password = password
            newUser.email = email
            newUser["nome"] = name
            
            newUser.signUpInBackgroundWithBlock({ (sucess, error ) -> Void in
                
                if((error) != nil){
                    Utils.alert("Erro",msg: "\(error)")
                }else{
                     Utils.alert("Sucesso",msg: "Usuário Criado!")
                    self.salvaUsuarioMySQL()
                    
                    
                }
                self.dismissViewControllerAnimated(false, completion: nil)

            })
        }
    }
    
    func salvaUsuarioMySQL(){
        var dados:[String] = [String]()
        dados.append("login=\(PFUser.currentUser()!.username!)")
        //dados.append("nome=\(PFUser.currentUser()!["nome"]!)")
        dados.append("senha=\(PFUser.currentUser()!.password!)")
        dados.append("email=\(PFUser.currentUser()!.email!)")
        dados.append("codigo=\(PFUser.currentUser()!.objectId!)")
        
        Utils.salvaDados("http://syskf.institutobfh.com.br//modulos/appCaderninho/saveUsuario.ashx", params: dados)
      
    }
    
}
