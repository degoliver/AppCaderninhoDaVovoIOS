//
//  detalheReceitaViewController.swift
//  CaderninhoDaVovo
//
//  Created by Diego on 29/11/15.
//  Copyright © 2015 7MOB. All rights reserved.
//

import UIKit
import Parse
import Social

class DetalheReceitaViewController: UIViewController, UIScrollViewDelegate {
    
    var codigo:String?
    var receita:Receita?
    var ignfc: String = ""
    var modfc: String = ""
    @IBOutlet weak var imgLike: UIImageView!
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var imgReceita: UIImageView!
    @IBOutlet weak var loadImg: UIActivityIndicatorView!
    @IBOutlet weak var lblNome: UILabel!
    @IBOutlet weak var lblUsuario: UILabel!
    @IBOutlet weak var scroolView: UIScrollView!
    @IBOutlet weak var loadLike: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgLike.hidden = true
       
        Receita.carregaReceita("http://syskf.institutobfh.com.br//modulos/appCaderninho/selectReceita.ashx?receitaID=" + codigo! + "&usuarioID="+PFUser.currentUser()!.objectId!, callback: carregaView)
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func retornaImagem(img: UIImage?) {
        if(img != nil){
            self.loadImg.stopAnimating()
            self.imgReceita.image = img
        }
    }
    
    func carregaView(receitas:[Receita]){
        if(receitas.count==0){
            Utils.alert("Erro", msg: "Não foi possível carregar a receita")
            return
        }
        receita = receitas[0]
        
        imgLike.hidden = false
        
        if(receita?.imagem != ""){
            loadImg.startAnimating()
            Utils.downloadImage((receita?.imagem)!, callback: retornaImagem)
        }
        
        lblUsuario.text = "Por: \(receita!.nomeUsuario!)"
        lblNome.text = receita?.nome
        
        imgLike.image = UIImage(named: (receita!.marcadolike!) ? "heart" : "heartWhite")
        
        if(receita!.qtdLike! == 0){
            lblLike.text = "Ninguém favoritou esta receita ainda"
        }else {
            lblLike.text = "\(receita!.qtdLike!)" + ((receita!.qtdLike! > 1) ? " gostaram " : " gostou ") + "desta receita"
        }
        
        
        //Cria view INGREDIENTES
        let lblIng:UILabel = UILabel(frame: CGRectMake(10, 25, 288, 20))
        lblIng.text = receita!.ingredientes!
        ignfc = receita!.ingredientes!
        lblIng.numberOfLines = 0
        lblIng.lineBreakMode = NSLineBreakMode.ByWordWrapping
        lblIng.font = UIFont(name: ".SFUIText-Regular", size: 12)
        lblIng.sizeToFit()
        let view1:UIView = UIView(frame: CGRectMake(10,260,300,lblIng.frame.height+40))
        view1.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.2)
        view1.layer.cornerRadius = 9.0
        let label:UILabel = UILabel(frame: CGRectMake(5, 5, 288, 20))
        label.text = "-- INGREDIENTES --"
        label.font = UIFont(name: "Copperplate", size: 14)
        label.textAlignment = NSTextAlignment.Center
        view1.addSubview(label)
        view1.addSubview(lblIng)
        self.scroolView.addSubview(view1)
        
        //Cria view MODO DE PREPARO
        let lblModPre:UILabel = UILabel(frame: CGRectMake(10, 25, 288, 20))
        lblModPre.text = receita!.modoPreparo!
        modfc = receita!.modoPreparo!
        lblModPre.numberOfLines = 0
        lblModPre.lineBreakMode = NSLineBreakMode.ByWordWrapping
        lblModPre.font = UIFont(name: ".SFUIText-Regular", size: 12)
        lblModPre.sizeToFit()
        let view2:UIView = UIView(frame: CGRectMake(10,270 + view1.frame.height,300,lblModPre.frame.height+40))
        view2.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.2)
        view2.layer.cornerRadius = 9.0
        let lbl:UILabel = UILabel(frame: CGRectMake(5, 5, 288, 20))
        lbl.text = "-- MODO DE PREPARO --"
        lbl.font = UIFont(name: "Copperplate", size: 14)
        lbl.textAlignment = NSTextAlignment.Center
        view2.addSubview(lbl)
        view2.addSubview(lblModPre)
        self.scroolView.addSubview(view2)
        
        scroolView.contentSize.height = 230 + view1.frame.height + view2.frame.height
    }
    
    @IBAction func compartilharButton(sender: AnyObject) {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            
            var fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            self.presentViewController(fbShare, animated: true, completion: nil)
            
            var TextoFace: String = ""
            
            TextoFace = lblNome.text! + "\n" + lblUsuario.text! + "\n" + "-------Ingredientes--------\n" + ignfc + "\n" + "------Modo de Preparo-------\n" + modfc
            fbShare.setInitialText(TextoFace)
            fbShare.addImage(imgReceita.image)
            
            
        }else{
            var alert = UIAlertController(title: "Conta", message: "Entre com seu login", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func imageTapped()
    {
        imgLike.hidden = true
        loadLike.startAnimating()
        
        var dados:[String] = [String]()
        dados.append("like=\((receita!.marcadolike!) ? 0 : 1)")
        dados.append("&usuarioID=\(PFUser.currentUser()!.objectId!)")
        dados.append("&receitaID=\(receita!.codigo!)")

        Utils.salvaDados("http://syskf.institutobfh.com.br//modulos/appCaderninho/saveLike.ashx", params: dados, alerta: true, callback: retornaDados)
    }
    
    func retornaDados(status: Bool, id: String){
        loadLike.stopAnimating()
        if(status) {
            if(receita!.marcadolike!){
                imgLike.image = UIImage(named: "heartWhite")
            }else{
                imgLike.image = UIImage(named: "heart")
            }
            receita?.marcadolike = !receita!.marcadolike!
        }
        imgLike.hidden = false
    }
    
}