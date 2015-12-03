//
//  NovaReceitaViewController.swift
//  CaderninhoDaVovo
//
//  Created by Diego on 02/12/15.
//  Copyright © 2015 7MOB. All rights reserved.
//

import UIKit
import Parse

class NovaReceitaViewController: UIViewController, UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    var imagePicker: UIImagePickerController!
    
    var codigo:String = "0"
    var receita:Receita?
    
    @IBOutlet weak var tirarFoto: UIButton!
    @IBOutlet weak var carregarFoto: UIButton!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    @IBOutlet weak var imgLoad: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgReceita: UIImageView!
    @IBOutlet weak var txtIngredientes: UITextView!
    @IBOutlet weak var btnEditImagem: UIBarButtonItem!
    @IBOutlet weak var txtNome: UITextField!
    @IBOutlet weak var txtModoPreparo: UITextView!
    @IBOutlet weak var tbImagem: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgLoad.startAnimating()
        imgReceita.image = UIImage(named: "noImage")
        Receita.carregaReceita("http://syskf.institutobfh.com.br//modulos/appCaderninho/selectReceita.ashx?receitaID=" + codigo, callback: carregaView)
        
        scrollView.contentSize.height = 600
        
        self.navigationItem.rightBarButtonItem!.enabled = false
        txtNome.layer.borderColor = UIColor.lightGrayColor().CGColor
        txtIngredientes.layer.cornerRadius = 9.0
        txtIngredientes.layer.borderWidth = 1
        txtIngredientes.layer.borderColor = UIColor.lightGrayColor().CGColor
        txtModoPreparo.layer.cornerRadius = 9.0
        txtModoPreparo.layer.borderWidth = 1
        txtModoPreparo.layer.borderColor = UIColor.lightGrayColor().CGColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func carregaView(receitas:[Receita]){
        if(receitas.count==0){ receita = Receita(codigo: 0, nomeUsuario: "", imagem: "", nome: "", ingredientes: "", modoPreparo: "", qtdLike: 0, marcadolike: false) } else {
            receita = receitas[0]
        }
        
        if(receita?.imagem != ""){
            self.imgReceita.image = Utils.downloadImage((receita?.imagem)!)
            imgLoad.stopAnimating()
        }
        
        txtNome.text = receita!.nome!
        txtIngredientes.text = receita!.ingredientes!
        txtModoPreparo.text = receita!.modoPreparo!
        self.navigationItem.rightBarButtonItem!.enabled = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField == txtNome){
            txtIngredientes.becomeFirstResponder()
        }else if(textField == txtIngredientes){
            txtModoPreparo.becomeFirstResponder()
        }else{
            txtModoPreparo.resignFirstResponder()
        }
        return false
    }
    
    @IBAction func salvaReceita(sender: AnyObject) {
        if(txtNome.text == "") {
            Utils.alert("Inválido", msg: "Digite o nome da Receita")
            txtNome.becomeFirstResponder()
            return
        } else if(txtIngredientes.text == "") {
            Utils.alert("Inválido", msg: "Digite os ingredientes da Receita")
            txtIngredientes.becomeFirstResponder()
            return
        } else if(txtModoPreparo.text == "") {
            Utils.alert("Inválido", msg: "Digite o modo de preparo da Receita")
            txtModoPreparo.becomeFirstResponder()
            return
        }
        self.navigationItem.rightBarButtonItem!.enabled = false
        receita?.nome = txtNome.text
        receita?.ingredientes = txtIngredientes.text
        receita?.modoPreparo = txtModoPreparo.text
        
        var dados:[String] = [String]()
        dados.append("nome=\(receita!.nome!)")
        dados.append("&ingredientes=\(receita!.ingredientes!)")
        dados.append("&modoPreparo=\(receita!.modoPreparo!)")
        dados.append("&usuarioID=\(PFUser.currentUser()!.objectId!)")
        if(codigo != "" && codigo != "0"){ dados.append("&receitaID=\(codigo)") }
        
        Utils.salvaDados("http://syskf.institutobfh.com.br//modulos/appCaderninho/saveReceita.ashx", params: dados, alerta: true, callback: retornaDados)
    }
    
    func retornaDados(status: Bool){
        self.navigationItem.rightBarButtonItem!.enabled = true
        if(!status) {
            txtNome.becomeFirstResponder()
        }
    }
    @IBAction func CarregarFoto(sender: AnyObject) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    @IBAction func TirarFoto(sender: AnyObject) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func salvarFoto(sender: AnyObject) {
        var quality:CGFloat = 1
        var imageData = UIImageJPEGRepresentation(imgReceita.image!, quality)
        var base64String = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        var tam:Int = base64String.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        
        while(tam > 1048576){
            quality -= 0.1
            imageData = UIImageJPEGRepresentation(imgReceita.image!, quality)
            base64String = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
            tam = base64String.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
        }
        
        tbImagem.items![0].enabled = false
        var dados:[String] = [String]()
        dados.append("imagem=\(base64String)")
        dados.append("&receitaID=\(receita!.codigo!)")
        dados.append("&usuarioID=\(PFUser.currentUser()!.objectId!)")
        
        Utils.salvaDados("http://syskf.institutobfh.com.br//modulos/appCaderninho/saveImagem.ashx", params: dados, alerta: true, callback: retornaUploadImg)
    }
    
    func retornaUploadImg(status: Bool){
        tbImagem.items![0].enabled = true
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let img:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imgReceita.image = img
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
