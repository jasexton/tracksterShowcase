//
//  CoachTableViewController.swift
//  TracksterShowcase
//
//  Created by Jack Sexton on 4/29/18.
//  Copyright © 2018 Jack Sexton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI




//Created unique cell  for the top one that enables you to change the number of table view
class buttons: UITableViewCell
{
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
}
//Custom View with one big text option
class notes: UITableViewCell
{
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var notesView: UITextView!
    
}
//Custom cell with multiple text options for multiple fileds
class fields: UITableViewCell
{
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var text1: UITextField!
    @IBOutlet weak var text2: UITextField!
    @IBOutlet weak var text3: UITextField!
    
}
//Custom cell with an image and a text box
class image: UITableViewCell
{
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var text1: UITextField!
    
    @IBOutlet weak var selectImage: UIButton!
    @IBOutlet weak var takeImage: UIButton!
    
}


// General Class that does everything
class CoachTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate
{
    var coach: Coach!
    var imagePicker = UIImagePickerController()
    var update = false
    
    //Text becomes blue when editing so user know they are editing
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        textField.textColor = .blue

    }
    
    // Saves data once complete to the respective field
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        
        
        if coach == nil
        {
            coach = Coach()
            
        }
        if textField.tag == 7
        {
            coach.team = textField.text!
        }
        else if textField.tag == 8
        {
            coach.firstName = textField.text!
        }
        else if textField.tag == 9
        {
            coach.lastName = textField.text!
        }
        else if textField.tag == 10
        {
            coach.email = textField.text!
        }
        else if textField.tag == 11
        {
            coach.iPhoneorAndroid = textField.text!
        }
        else if textField.tag == 12
        {
            coach.level = textField.text!
        }
        else if textField.tag == 13
        {
            coach.meet = textField.text!
        }
        
    }
    
    //Once editig is complete
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        view.endEditing(true)
        return true
    }
    
    //change text view so it also has blue text in the begining
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        textView.textColor = .blue
        textView.text = ""
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
       // tableView.reloadData()
    }
    
    //exit out of keyboard
    @objc func endkey()
    {
        view.endEditing(true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //Size cell beased off of how much you are typing
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.estimatedRowHeight = 66.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()
        
        //To get out of editing textview
        let tap = UITapGestureRecognizer(target: self, action: #selector(endkey))
        
        self.view.addGestureRecognizer(tap)
        
    }
    
    
    func saveCoach()
    {
        // Creates coach if nil
        if coach == nil
        {
            coach = Coach()
        }
       
        // Id data is already entered then all infor is added in the right cell
        if let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? image
        {
            coach.team = cell.text1.text!
        }
        if let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? notes
        {
            coach.research = cell.notesView.text
        }
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? fields
        {
            coach.firstName = cell.text1.text!
            coach.lastName = cell.text2.text!
            coach.email = cell.text3.text!
        }
        if let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as? notes
        {
            coach.currentTiming = cell.notesView.text
        }
        if let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 1)) as? notes
        {
            coach.currentLogging = cell.notesView.text
        }
        if let cell = tableView.cellForRow(at: IndexPath(row: 3, section: 1)) as? notes
        {
            coach.notes = cell.notesView.text
        }
        if let cell = tableView.cellForRow(at: IndexPath(row: 4, section: 1)) as? fields
        {
            coach.iPhoneorAndroid = cell.text1.text!
            coach.level = cell.text2.text!
            coach.meet = cell.text3.text!
        }
        //pops put if saved
        coach.saveData
        {
            success in
            if success
            {
                self.navigationController?.popViewController(animated: true)
            }
            else
            {
                print("*** ERROR: Couldn't leave this view controller because data wasn’t saved.")
            }
            
            
        }

        
        
    }
    
    
    var image1 = UIImage()

    @IBAction func saveData(_ sender: Any)
    {
        saveCoach()
    }
    
    
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if coach == nil
        {
            coach = Coach()
        }
        coach.image = selectedImage
        
        image1 = selectedImage
        
        dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
    //Cancel grabbing image
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func selectedImage()
    {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func takePicture()
    {
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    //Need to keep saved
    var research = true
    
    
    @objc func researchView()
    {
        research = true
        tableView.reloadData()
    }
    
    @objc func conversationView()
    {
        research = false
        tableView.reloadData()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem)
    {
        let isPrestingInAddMode = presentingViewController is UINavigationController
        if isPrestingInAddMode
        {
            dismiss(animated: true, completion: nil)
        }
        else
        {
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    //Created two sections becasue didn't want a couple of the rows to show when talking to coaches
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    //Creates different number of rows depending on what button is pressed
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            if research
            {
                return 3
            }
            else
            {
                return 1
            }
        }
        else
        {
            return 5
        }
    }
    //Create all of the cells with the right information. A lot of code because of multiple sections
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //Showing everything
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "buttons" , for: indexPath) as! buttons
                cell.button1.setTitle("Research", for: .normal)
                cell.button2.setTitle("Conversation", for: .normal)
                
                cell.button1.addTarget(self, action: #selector(researchView), for: .touchUpInside)
                cell.button2.addTarget(self, action: #selector(conversationView), for: .touchUpInside)
                
                return cell
            }
                
            else if indexPath.row == 1
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "image" , for: indexPath) as! image
             //   cell.imageView?.image = image1
                cell.image1.image = image1
                cell.image1.clipsToBounds = true
                cell.image1.contentMode = .scaleAspectFill
                cell.label1.text = "Team:"
                
                cell.text1.clearsOnBeginEditing = true
                
                cell.text1.text = "Enter Team Name"
                cell.text1.textColor = .lightGray
                cell.text1.delegate = self
                cell.text1.tag = 7
                
                if coach != nil
                {
                    cell.text1.text = coach.team
                    cell.image1.image = coach.image
                    cell.text1.textColor = .black
                 //   cell.text1.tag = 68
                    
                    cell.text1.clearsOnBeginEditing = false
                }
                
                cell.selectImage.addTarget(self, action: #selector(selectedImage), for: .touchUpInside)
                cell.selectImage.addTarget(self, action: #selector(takePicture), for: .touchUpInside)
                return cell
            }
                
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "notes" , for: indexPath) as! notes
                cell.infoLabel.text = "Research:"
                cell.notesView.text = ""
                cell.notesView.tag = 52
                
                
                if coach != nil { cell.notesView.text = coach.research  }
                
                cell.notesView.layer.borderColor = UIColor.black.cgColor
                cell.notesView.layer.borderWidth = 1.0
                return cell
            }
            
        }
        else
        {
            //Shows cell with multiple text fields with filler gray filler text that dissapears when start typing
            if indexPath.row == 0
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "fields" , for: indexPath) as! fields
              
                cell.label1.text = "First Name:"
                cell.label2.text = "Last Name:"
                cell.label3.text = "Email:"
                
                cell.text1.text = "John"
                cell.text1.textColor = .lightGray
                cell.text1.delegate = self
                cell.text1.tag = 8
                
                cell.text2.text = "Smith"
                cell.text2.textColor = .lightGray
                cell.text2.delegate = self
                cell.text2.tag = 9
                
                cell.text3.text = "john@example.com"
                cell.text3.textColor = .lightGray
                cell.text3.delegate = self
                cell.text3.tag = 10
                
                cell.text1.clearsOnBeginEditing = true
                cell.text2.clearsOnBeginEditing = true
                cell.text3.clearsOnBeginEditing = true

                
                if coach != nil
                {
                    cell.text1.text = coach.firstName
                    cell.text1.textColor = .black
        
                    cell.text2.text = coach.lastName
                    cell.text2.textColor = .black

           
                    cell.text3.text = coach.email
                    cell.text3.textColor = .black
                    
                    cell.text1.clearsOnBeginEditing = false
                    cell.text2.clearsOnBeginEditing = false
                    cell.text3.clearsOnBeginEditing = false
                    
                }
                return cell
            }
            //Notes section with border
            else if indexPath.row == 1
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "notes" , for: indexPath) as! notes
                cell.infoLabel.text = "Current Timing Process:"
                cell.notesView.text = ""
                
                 if coach != nil { cell.notesView.text = coach.currentTiming }
                
                cell.notesView.layer.borderColor = UIColor.black.cgColor
                cell.notesView.layer.borderWidth = 1.0
                
                cell.notesView.tag = 52
                
                return cell
            }
            //notes section with border
            else if indexPath.row == 2
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "notes" , for: indexPath) as! notes
                cell.infoLabel.text = "Current Logging Process:"
                cell.notesView.text = ""
                
                 if coach != nil { cell.notesView.text = coach.currentLogging  }
                
                cell.notesView.layer.borderColor = UIColor.black.cgColor
                cell.notesView.layer.borderWidth = 1.0
                
                cell.notesView.tag = 52
                
                return cell
            }
           //Notes section with border
            else if indexPath.row == 3
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "notes" , for: indexPath) as! notes
                cell.infoLabel.text = "Other Notes:"
                cell.notesView.text = ""
                
                if coach != nil { cell.notesView.text = coach.notes  }
                
                cell.notesView.layer.borderColor = UIColor.black.cgColor
                cell.notesView.layer.borderWidth = 1.0
                
                cell.notesView.tag = 52
                
                
                return cell
            }
            // Shows cell with multiple text fields with filler gray filler text that dissapears when start typing
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "fields" , for: indexPath) as! fields
                cell.label1.text = "iPhone:"
                cell.label2.text = "Level:"
                cell.label3.text = "Meet:"
                
                cell.text1.text = "Yes"
                cell.text1.textColor = .lightGray
                cell.text1.delegate = self
                cell.text1.tag = 11
                
                cell.text2.text = "College"
                cell.text2.textColor = .lightGray
                cell.text2.delegate = self
                cell.text2.tag = 12
                
                cell.text3.text = "Pre Classic"
                cell.text3.textColor = .lightGray
                cell.text3.delegate = self
                cell.text3.tag = 13
                
                cell.text1.clearsOnBeginEditing = true
                cell.text2.clearsOnBeginEditing = true
                cell.text3.clearsOnBeginEditing = true
                
                if coach != nil
                {
                    cell.text1.text = coach.iPhoneorAndroid
                    cell.text1.textColor = .black
                    
                    cell.text2.text = coach.level
                    cell.text2.textColor = .black

                    cell.text3.text = coach.meet
                    cell.text3.textColor = .black

                    cell.text1.clearsOnBeginEditing = false
                    cell.text2.clearsOnBeginEditing = false
                    cell.text3.clearsOnBeginEditing = false
                }
                return cell
            }
        }
    }
}




