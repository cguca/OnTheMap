//
//  StudentUITableViewController.swift
//  OnTheMap
//
//  Created by Cary Guca on 4/2/21.
//

import UIKit

class StudentUITableViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var studentLocations: [StudentLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OnTheMapClient.getStudentLocations() {students, error
            in
            self.studentLocations = students
            self.tableView.reloadData()
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false

        tableView.reloadData()
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        OnTheMapClient.deleteSession { (sucess, error) in
            if sucess {
                print("Logging out is sucessful")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                print("MapViewController:logoutPressed: Error \(error)")
            }
        }
    }
    
    @IBAction func refreshedPressed(_ sender: Any) {
        OnTheMapClient.getStudentLocations() {students, error
            in
            self.studentLocations = students
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addPostPressed(_ sender: Any) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "InformationPostingViewController") as! InformationPostingViewController
        let backItem = UIBarButtonItem()
//        let backItem = UIBarButtonItem(title: "CANCEL", style: .plain, target: nil, action: nil)
        backItem.title = "CANCEL"
        backItem.style = .done
   
        navigationItem.backBarButtonItem = backItem
        self.navigationController!.pushViewController(controller, animated: true)
        
//        let backBarButtonItem = UIBarButtonItem(title: "You back button title here", style: .plain, target: nil, action: nil)
//                navigationItem.backBarButtonItem = backBarButtonItem
        
       // performSegue(withIdentifier: "postInformationSeque", sender: nil)
    }
    
}

extension StudentUITableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell")!
        let student = studentLocations[indexPath.row]
        cell.textLabel?.text = student.name
        cell.detailTextLabel?.text = student.mediaURL
        cell.imageView?.image = UIImage(named: "icon_pin")
        
        return cell
    }
    
    // Tapping on the row launches Safari and opens the link associated with the student.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = studentLocations[indexPath.row]
        if let url = URL(string: student.mediaURL) {
            UIApplication.shared.open(url)
        }
    }
}

