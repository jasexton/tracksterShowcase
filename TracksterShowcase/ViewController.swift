//
//  ViewController.swift
//  TracksterShowcase
//
//  Created by Jack Sexton on 4/29/18.
//  Copyright © 2018 Jack Sexton. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI

class ViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    var authUI: FUIAuth!
    var coaches: Coaches!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        coaches = Coaches()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        signIn()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        coaches.loadData
        {
            self.tableView.reloadData()
        }
    }
    // Pass data to coachtableview
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let destination = segue.destination as! CoachTableViewController
            let selectedIndex = tableView.indexPathForSelectedRow!
            destination.coach = coaches.coachArray[selectedIndex.row]
        }
    }

    
    @IBAction func signOutPressed(_ sender: UIBarButtonItem)
    {
        do
        {
            try authUI!.signOut()
            print("^^^ Successfully signed out!")
            tableView.isHidden = true
            signIn()
        }
        catch
        {
            tableView.isHidden = true
            print("*** ERROR: Couldn't sign out")
        }

        
    }
    
//    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
//    {
        
 //   }
    
}

extension ViewController: FUIAuthDelegate
{
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool
    {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication:
            sourceApplication) ?? false {
            return true
        }
        return false
    }
    
    func signIn()
    {
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            ]
        if authUI.auth?.currentUser == nil
        {
            self.authUI?.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        }
        else
        {
            tableView.isHidden = false
        }
    }

    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?)
    {
        if let user = user
        {
            tableView.isHidden = false
            print("^^^ We signed in with the user \(user.email ?? "unknown e-mail")")
        }
    }
    
    //Customized sign in with Trackster Logo
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController
    {
        
        // Create an instance of the FirebaseAuth login view controller
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        
        // Set background color to white
        loginViewController.view.backgroundColor = UIColor.white
        
        
        let marginInsets: CGFloat = 16
        let imageHeight: CGFloat = 225
        let imageHeight2: CGFloat = 100
        
        let imageY = self.view.center.y - imageHeight
        let imageY2 = self.view.center.y
        
        let logoFrame = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY, width:
            self.view.frame.width - (marginInsets*2), height: imageHeight)
     
        
        let logoFrame2 = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY2, width:
            self.view.frame.width - (marginInsets*2), height: imageHeight2)
        
        // Create the UIImageView using the frame created above & add the "logo" image for logo
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "antelope-gradient")
        logoImageView.contentMode = .scaleAspectFit // Set imageView to Aspect Fit
      //  loginViewController.view.addSubview(logoImageView) // Add ImageView to the login controller's main view
        
        let logoImageView2 = UIImageView(frame: logoFrame2)
        logoImageView2.image = UIImage(named: "trackster-text-gradient")
        logoImageView2.contentMode = .scaleAspectFit // Set imageView to Aspect Fit
        
        loginViewController.view.addSubview(logoImageView2)// Add ImageView to the login controller's main view
        loginViewController.view.addSubview(logoImageView)
        
        
        return loginViewController
    }
}

// Simple view controller for all of the coaches in the database
extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // change zero below to appropriate datasource.count
        return coaches.coachArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell" , for: indexPath)
        let coach = coaches.coachArray[indexPath.row]
        cell.textLabel?.text = "\(coach.firstName) \(coach.lastName)"
        cell.detailTextLabel?.text = coach.email
        return cell
    }

}
