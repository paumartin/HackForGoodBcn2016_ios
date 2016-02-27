//
//  FlatCollectionViewController.swift
//  MatchingGenerations
//
//  Created by Oscar Blanco Castan on 26/2/16.
//  Copyright © 2016 AlcaponeTeam. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

private let reuseIdentifier = "cell"

class FlatCollectionViewController: UICollectionViewController {
    var locationSearchText = ""
    var pisos=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.navigationController?.navigationItem.backBarButtonItem?.title = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        Alamofire.request(.GET, "http://54.201.234.52/pis/search/"+locationSearchText).responseJSON { response in
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: NSJSONReadingOptions.AllowFragments)
                print(json)
                self.pisos = json as! NSArray
                print(self.pisos)
//                let foto = json.valueForKey("foto")![0] as! String
                self.collectionView?.reloadData()
            } catch {}
            
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return pisos.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pisCell", forIndexPath: indexPath) as! FlatCollectionViewCell
        
        cell.titleLabel.text = pisos[indexPath.row].valueForKey("titol") as? String
        cell.titleLabel.sizeToFit()
        let foto = pisos[indexPath.row].valueForKey("foto")![0] as? String
        cell.imageView.af_setImageWithURL(NSURL(string: "http://54.201.234.52/uploads/"+foto!)!)
        cell.cityLabel.text = pisos[indexPath.row].valueForKey("ciutat") as? String
        cell.cityLabel.sizeToFit()
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        return CGSize(width: (screenSize.width/2-1), height: (screenSize.width/2-1));
        
    }

    // MARK: UICollectionViewDelegate

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "FlatTablePush") {
            let indexPath: NSIndexPath = self.collectionView!.indexPathsForSelectedItems()!.first!
//            let selectedRow: NSManagedObject = locationsList[indexPath] as! NSManagedObject
            
            let vc:FlatTableViewController = segue.destinationViewController as! FlatTableViewController
            vc.title = pisos[indexPath.row].valueForKey("titol") as? String
            vc.pis = pisos[indexPath.row] as! NSDictionary
            vc.imatges = (pisos[indexPath.row].valueForKey("foto")! as? NSMutableArray)!
            vc.ofereixo = (pisos[indexPath.row].valueForKey("ofereixo")! as? NSMutableArray)!
            vc.necessito = (pisos[indexPath.row].valueForKey("busco")! as? NSMutableArray)!
        }
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
