//
//  ListViewController.swift
//  onTheMap
//
//  Created by Victor Tejada Yau on 10/11/21.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var students = [StudentInformation]()
    var currentIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        currentIndicator = UIActivityIndicatorView (style: UIActivityIndicatorView.Style.medium)
        setupIndicator(currentIndicator: currentIndicator)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchStudentList()
    }
    
    @IBAction func logout(_ sender: Any) {
        displayActivityIndicator(currentIndicator: currentIndicator)
        ServiceClient.classicLogout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                self.hideActivityIndicator(currentIndicator: self.currentIndicator)
            }
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        fetchStudentList()
    }
    
    func fetchStudentList() {
        displayActivityIndicator(currentIndicator: currentIndicator)
        ServiceClient.fetchStudentLocations() { students, error in
            self.students = students ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.hideActivityIndicator(currentIndicator: self.currentIndicator)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "list_item")!
        let student = students[indexPath.row]
        cell.textLabel?.text = student.firstName + " " + student.lastName
        cell.detailTextLabel?.text = student.mediaURL ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let student = self.students[indexPath.row]
        openLink(student.mediaURL ?? "")
    }
}
