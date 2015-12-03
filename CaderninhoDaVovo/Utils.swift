//
//  Utils.swift
//  CaderninhoDaVovo
//
//  Created by Diego on 02/12/15.
//  Copyright © 2015 7MOB. All rights reserved.
//

import UIKit

class Utils: UIViewController {

    class func salvaDados(url: String, params: [String]){
        salvaDados(url, params: params, alerta: false, callback: nil)
    }
    
    class func salvaDados(url: String, params: [String], alerta: Bool, callback: ((Bool) -> Void)?){
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let nsurl = NSURL(string: url)!
        let request = NSMutableURLRequest(URL: nsurl)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        var paramString = ""
        for(var a:Int = 0 ; a < params.count ; a++) {
            paramString += ((a > 0) ? "&" : "") + params[a]
        }
        
        request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                let result = resultado(data, alerta: alerta)
                callback?(result)
            })
        })
        task.resume()
    }
    
    class func resultado(data:NSData?, alerta: Bool) -> Bool {
        var status: Bool = false
        do{
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
            if let result = json["msg"] as? String {
                status = ((json["status"] as! String == "OK") ? true : false)
                if(alerta){ alert((status) ? "Sucesso" : "Erro", msg: result) }
            }
        }catch{
            print("ERRO")
            return false
        }
        return status
    }
    
    class func alert(title:String, msg:String){
        if var topController = UIApplication.sharedApplication().keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            let actionAlert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
            actionAlert.addAction(UIAlertAction(title: "OK", style:.Default, handler: nil))
            topController.presentViewController(actionAlert, animated: true, completion: nil)
        }
    }
    
    class func downloadImage(img: String) -> UIImage {
        
        let decodedData = NSData(base64EncodedString: img, options: [])
        if(decodedData == nil) { return UIImage(named: "noImage")! }
        var decodedimage = UIImage(data: decodedData!)
        
        return decodedimage! as! UIImage
    }
    
}
