//
//  ProfileViewController.swift
//  MatchingGenerations
//
//  Created by Oscar Blanco Castan on 26/2/16.
//  Copyright © 2016 AlcaponeTeam. All rights reserved.
//

import UIKit
import JDSwiftAvatarProgress
import TextFieldEffects
import Alamofire

class ProfileViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var profileImage: JDAvatarProgress!
    
    @IBOutlet weak var nameField: KaedeTextField!
    @IBOutlet weak var surnameField: KaedeTextField!
    @IBOutlet weak var birthDateField: KaedeTextField!
    @IBOutlet weak var genreField: KaedeTextField!
    
    var genreOptions = ["home", "dona"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Perfil"
        
        Alamofire.request(.GET, "http://54.201.234.52/estudiant/get/"+userId).responseJSON { response in
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: NSJSONReadingOptions.AllowFragments)
                print(json.valueForKey("foto"))
                let foto = json.valueForKey("foto")![0] as! String
                self.profileImage.setImageWithURL(NSURL(string: "http://54.201.234.52/uploads/"+foto)!)
                
                self.nameField.text = json.valueForKey("nom")![0] as? String
                self.surnameField.text = json.valueForKey("cognoms")![0] as? String
                self.birthDateField.text = json.valueForKey("dataNaixement")![0] as? String
                self.genreField.text = json.valueForKey("genere")![0] as? String
            } catch {}
    
        }

        // MARK Imatge
        self.imagePicker.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imagePickerTapped:"))
        profileImage.userInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
      let footerView = UIView.init(frame: CGRectZero)
        footerView.backgroundColor = UIColor(red:0.1, green:0.69, blue:0.36, alpha:1)
        self.tableView.tableFooterView = footerView
        
        // MARK Toolbar Select
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.Black
        
        toolBar.tintColor = UIColor.whiteColor()
        
        toolBar.barTintColor = UIColor(red:0.1, green:0.69, blue:0.36, alpha:1)
        
        let okBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action:"buttonDone:")
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
        
        toolBar.setItems([flexSpace,okBarBtn], animated: true)
        
        birthDateField.inputAccessoryView = toolBar
        genreField.inputAccessoryView = toolBar

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Date
    @IBAction func birthDateField(sender: AnyObject) {
        let datePickerView:UIDatePicker = UIDatePicker()
        let input = sender as! UITextField
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        input.inputView = datePickerView
        
        datePickerView.addTarget(self, action: Selector("birthDateValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    func birthDateValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
   
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        birthDateField.text = dateFormatter.stringFromDate(sender.date)
        
        
    }
    
    // MARK: Gender
    
    @IBAction func genderField(sender: AnyObject){
        let genderPickerView:UIPickerView = UIPickerView()
        genderPickerView.delegate = self
        genreField.inputView = genderPickerView
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genreOptions.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genreOptions[row].capitalizedString
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genreField.text = genreOptions[row].capitalizedString
    }
    
    func buttonDone(sender: UIBarButtonItem) {
        self.birthDateField.resignFirstResponder()
        self.genreField.resignFirstResponder()
    }
    
    // MARK: Image Picker
    func imagePickerTapped(img: AnyObject){
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            print("Button capture")
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        
        profileImage.image = image
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
        
    }

    @IBAction func saveAction(sender: AnyObject) {
        let parameters: [String : String] = [
            "_id": userId,
            "nom": nameField.text!,
            "cognoms": surnameField.text!,
            "genere": genreField.text!,
            "dataNaixement": birthDateField.text!
        ]
        
        Alamofire.request(.POST, "http://54.201.234.52/estudiant/update", parameters: parameters, encoding: .JSON)
    }
}
