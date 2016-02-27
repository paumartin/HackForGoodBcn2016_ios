//
//  FlatTableViewController.swift
//  MatchingGenerations
//
//  Created by Oscar Blanco Castan on 27/2/16.
//  Copyright © 2016 AlcaponeTeam. All rights reserved.
//

import UIKit
import Agrume
import Alamofire
import AlamofireImage

class FlatTableViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    var pis:NSDictionary =  [String: AnyObject]()
    var imatges:NSArray = []
    var necessito:NSArray = []
    var ofereixo:NSArray = []
//    var images:NSArray = []
    var images: [UIImage] = []
    
    @IBOutlet weak var descripcioTextView: UITextView!
    @IBOutlet weak var ofereixoTextView: UITextView!
    @IBOutlet weak var necesitoTextView: UITextView!
    @IBOutlet weak var collectionViewImatges: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        descripcioTextView.text = pis.valueForKey("descripcio") as? String
        var ofereixo = ""
        var necessito = ""
        for str in self.ofereixo {
            ofereixo += str as! String
            ofereixo += "\n"
        }
        for str in self.necessito {
            necessito += str as! String
            necessito += "\n"
        }
        ofereixoTextView.text = ofereixo
        necesitoTextView.text = necessito
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        for str in self.imatges {
            let url = NSURL(string: "http://54.201.234.52/uploads/"+(str as! String))

            let URLRequest = NSURLRequest(URL: url!)
            
            Alamofire.request(.GET, URLRequest)
                .responseImage { response in
                    debugPrint(response)
                    
                    print(response.request)
                    print(response.response)
                    debugPrint(response.result)
                    
                    if let image = response.result.value {
                        self.images.append(image)
                    }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 && indexPath.section == 3 {
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let height = Int(ceil(Double(self.imatges.count)/4.0))*(Int(screenSize.width)/4)
            return CGFloat(height)
        }
        return 80
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let agrume = Agrume(images: self.images, startIndex: indexPath.row, backgroundBlurStyle: .Light)
        agrume.showFrom(self)
    }
    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if(section == 1){
//            return self.ofereixo.count
//        }else if(section == 2){
//            return self.necessito.count 
//        }
//        return 1
//    }
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("textCell", forIndexPath: indexPath)
//        if(indexPath.section == 1){
//            cell.textLabel?.text = self.ofereixo[indexPath.row] as? String
//        }else if(indexPath.section == 2){
//            cell.textLabel?.text = self.necessito[indexPath.row] as? String
//        }else if(indexPath.section == 3){
//            cell as!
//        }
//        
//
//        return cell
//    }


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
    
    // MARK: - Collection View
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imatges.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pisImatgeCell", forIndexPath: indexPath) as! PisImatgeCollectionViewCell
        
        print(NSURL(string: "http://54.201.234.52/uploads/"+(self.imatges[indexPath.item] as! String))!)
        
        cell.imageView.af_setImageWithURL(NSURL(string: "http://54.201.234.52/uploads/"+(self.imatges[indexPath.item] as! String))!)
//        let url =  "http://54.201.234.52/uploads/"+(self.imatges[indexPath.item] as! String)
        
        let url = NSURL(string: "http://54.201.234.52/uploads/"+(self.imatges[indexPath.item] as! String))!
//        Alamofire.request(.GET,url).response { request, response, data, error in
//            self.images.addObject(UIImage(data: data, scale:1))
//        }
        

        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        return CGSize(width: (screenSize.width/4-1), height: (screenSize.width/4-1));
        
    }


}
