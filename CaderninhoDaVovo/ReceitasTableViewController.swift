//
//  ReceitasTableViewController.swift
//  CaderninoDaVovo
//
//  Created by Usuário Convidado on 25/11/15.
//  Copyright © 2015 Usuário Convidado. All rights reserved.
//

import UIKit
import Parse

class ReceitasTableViewController: UITableViewController {
    
    var busca:String = ""
    var propria:Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    var receitas:[Receita] = [Receita]()

    func updateRaceita(){
        Receita.carregaReceita("http://syskf.institutobfh.com.br//modulos/appCaderninho/selectReceitaList.ashx?busca=\(busca)" + ((propria) ? "&favoritos=1&usuarioID=" + PFUser.currentUser()!.objectId! : ""), callback: carregaTable)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.scopeButtonTitles = ["Todas", "Favoritas"]
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewDidAppear(animated: Bool) {
        updateRaceita()
    }

    func carregaTable(receitas:[Receita]){
        self.receitas = receitas
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return receitas.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ReceitaTableViewCell
        
        cell.lblReceita.text = self.receitas[indexPath.row].nome
        cell.lblLike.text = (self.receitas[indexPath.row].qtdLike! == 0) ? "Ninguém favoritou ainda" : String(self.receitas[indexPath.row].qtdLike!) + ((self.receitas[indexPath.row].qtdLike! == 1) ? " gostou" : " gostaram")
        if(self.receitas[indexPath.row].imagem != ""){
            cell.loadImg.startAnimating()
            Utils.downloadImage(self.receitas[indexPath.row].imagem!, callback: retornaImagem, sender: cell)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("receitaToDetalheSegue", sender: self.receitas[indexPath.row].codigo)
    }
   
    @IBAction func LogoutAction(sender: UIButton) {
        PFUser.logOut()
        NSUserDefaults.standardUserDefaults().setValue(nil  , forKey:"Usuario")
        NSUserDefaults.standardUserDefaults().setValue( nil, forKey:"senha")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
       
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="receitaToDetalheSegue"){
            let vc:DetalheReceitaViewController = segue.destinationViewController as!DetalheReceitaViewController
            vc.codigo = "\(sender!)"
        }
    }
    
    func retornaImagem(img: UIImage?, sender: AnyObject?){
        let cell = sender as? ReceitaTableViewCell
        if(img != nil){
            cell?.imgReceita.image = img
        }
        cell?.loadImg.stopAnimating()
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "Todas") {
        busca = searchText
        propria = ((scope == "Todas") ? false : true)
        updateRaceita()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ReceitasTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension ReceitasTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}
