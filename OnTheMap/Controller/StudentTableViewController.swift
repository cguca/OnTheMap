//
//  StudentTableViewController.swift
//  OnTheMap
//
//  Created by Cary Guca on 4/1/21.
//

import UIKit

class StudentTableViewController: UIViewController {
    
    
    @IBOutlet var tableView: UITableView!
   
    
    var studentLocations: [StudentLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Here in the StudentTableViewController")
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
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showDetail" {
//            let detailVC = segue.destination as! MovieDetailViewController
//            detailVC.movie = MovieModel.favorites[selectedIndex]
//        }
//    }
}

extension StudentTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentTableViewCell")!
        
//        let movie = MovieModel.watchlist[indexPath.row]
        
//        cell.textLabel?.text = movie.title
        cell.imageView?.image = UIImage(named: "icon_pin")
//        if let posterPath = movie.posterPath {
//            TMDBClient.downloadPosterImage(posterPath: posterPath) { (data, error) in
//                guard let data = data else {
//                    return
//                }
//                let image = UIImage(data: data)
//                cell.imageView?.image = image
//                cell.setNeedsLayout()
//            }
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Tapping on the row launches Safari and opens the link associated with the student.
//        selectedIndex = indexPath.row
//        performSegue(withIdentifier: "showDetail", sender: nil)
//        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

