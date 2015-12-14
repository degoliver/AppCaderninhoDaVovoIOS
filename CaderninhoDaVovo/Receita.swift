//
//  Receita.swift
//  CaderninhoDaVovo
//
//  Created by Diego on 29/11/15.
//  Copyright © 2015 7MOB. All rights reserved.
//

import UIKit

class Receita: NSObject {
    
    var codigo:Int?
    var nomeUsuario:String?
    var imagem:String?
    var nome:String?
    var ingredientes:String?
    var modoPreparo:String?
    var qtdLike:Int?
    var marcadolike:Bool?
    
    init(codigo:Int?, imagem:String?, nome:String?, qtdLike:Int?){
        self.codigo = codigo
        self.imagem = imagem
        self.nome = nome
        self.qtdLike = qtdLike
    }
    
    init(codigo:Int?, nomeUsuario:String?, imagem:String?, nome:String?, ingredientes:String?, modoPreparo:String?, qtdLike:Int?, marcadolike:Bool?){
        self.codigo = codigo
        self.nomeUsuario = nomeUsuario
        self.imagem = imagem
        self.nome = nome
        self.modoPreparo = modoPreparo
        self.qtdLike = qtdLike
        self.ingredientes = ingredientes
        self.marcadolike = marcadolike
    }
    
    class func carregaReceita(let url:String, callback: (receitas:[Receita]) -> Void){
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let nsurl = NSURL(string: url)!
        let task = session.dataTaskWithURL(nsurl, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), {
                let receitas = self.populaLista(data)
                callback(receitas: receitas)
            })
        })
        task.resume()
    }
    
    class func populaLista(data:NSData?) -> [Receita]{
        var receitas:[Receita] = [Receita]()
        do{
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
            if let dados = json["dados"] as? [AnyObject]{
                for values in dados {
                    if let nomeUsu = values["usuarioNome"] as? String {
                        receitas.append(Receita(codigo: Int(values["app_caderninho_receita_ID"] as! String), nomeUsuario: nomeUsu , imagem: values["imagem"] as? String, nome: values["nome"] as? String, ingredientes: values["ingredientes"] as? String, modoPreparo: values["modoPreparo"] as? String, qtdLike: Int(values["qtdLike"]! as! String), marcadolike: values["marcadoLike"] as! String == "1"))
                    } else{
                        receitas.append(Receita(codigo: Int(values["codigo"] as! String), imagem: values["imagem"] as? String,  nome: values["nome"] as? String, qtdLike: Int(values["qtdLike"] as! String)))
                    }
                }
            }
        }catch{
            print("ERRO")
        }
        return receitas
    }

}
