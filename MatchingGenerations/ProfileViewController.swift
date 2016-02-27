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
//import GoogleWearAlert


class ProfileViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var profileImage: JDAvatarProgress!
    
    @IBOutlet weak var nameField: KaedeTextField!
    @IBOutlet weak var surnameField: KaedeTextField!
    @IBOutlet weak var birthDateField: KaedeTextField!
    @IBOutlet weak var genreField: KaedeTextField!
    @IBOutlet weak var phoneField: KaedeTextField!
    
    var genreOptions = ["hombre", "mujer"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Perfil"
        
        addToolBar(nameField)
        addToolBar(surnameField)
        addToolBar(birthDateField)
        addToolBar(genreField)
        addToolBar(phoneField)
        
        Alamofire.request(.GET, "http://54.201.234.52/estudiant/get/"+userId).responseJSON { response in
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: NSJSONReadingOptions.AllowFragments)
                
                let foto = json.valueForKey("foto")![0] as! String
                self.profileImage.setImageWithURL(NSURL(string: "http://54.201.234.52/uploads/"+foto)!)
                
                self.nameField.text = json.valueForKey("nom")![0] as? String
                self.surnameField.text = json.valueForKey("cognoms")![0] as? String
                self.birthDateField.text = json.valueForKey("dataNaixement")![0] as? String
                self.genreField.text = json.valueForKey("genere")![0] as? String
                self.phoneField.text = json.valueForKey("telefon")![0] as? String
            } catch {}
    
        }

        // MARK Imatge
        self.imagePicker.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imagePickerTapped:"))
        profileImage.userInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
        // MARK footer
        let footerView = UIView.init(frame: CGRectZero)
        footerView.backgroundColor = UIColor(red:0.1, green:0.69, blue:0.36, alpha:1)
        self.tableView.tableFooterView = footerView
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
        view.endEditing(true)
    }
    
    // MARK: Image Picker
    func imagePickerTapped(img: AnyObject){
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            
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

    @IBAction func cancelAction(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        let parameters: [String : String] = [
            "_id": userId,
            "nom": nameField.text!,
            "cognoms": surnameField.text!,
            "genere": genreField.text!,
            "dataNaixement": birthDateField.text!,
            "telefon": phoneField.text!
        ]
        
        Alamofire.request(.POST, "http://54.201.234.52/estudiant/update", parameters: parameters, encoding: .JSON)
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {
           GoogleWearAlert.showAlert(title: "Guardado", type: .Success)
        })
    }
}
