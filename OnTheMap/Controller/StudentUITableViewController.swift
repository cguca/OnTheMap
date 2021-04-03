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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
    }
    
    @IBAction func refreshedPressed(_ sender: Any) {
    }
    
    @IBAction func addPostPressed(_ sender: Any) {
        performSegue(withIdentifier: "postInformationSeque", sender: nil)
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

