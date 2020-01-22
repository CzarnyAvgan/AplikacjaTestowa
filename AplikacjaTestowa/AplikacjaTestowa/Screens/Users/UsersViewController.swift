//
//  UsersViewController.swift
//  AplikacjaTestowa
//
//  Created by Kacper Wysocki on 22/01/2020.
//  Copyright © 2020 Kacper Wysocki. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "UserTableViewCell"
    
    var dataSource: [[String: [User]]] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Users"
        setupTableView()
        setupSearchTextField()
        
        fetchUsers()
    }
    
    private func setupSearchTextField() {
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.black.cgColor
        searchTextField.layer.cornerRadius = 5.0
        searchTextField.setLeftPaddingPoints(CGFloat(16))
        searchTextField.delegate = self
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    private func fetchUsers() {
        if let path = Bundle.main.path(forResource: "users", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let usersJSONObjects = try! JSONDecoder().decode(Users.self, from: data)
                mapData(users: usersJSONObjects.users)
                
            } catch {
                fatalError("Can't read json file ! ")
            }
        }
    }
    
    private func mapData(users: [User]) {
        var firstNameLetter = Set<String>()
        let usersFirstNameLetters = users.map { (user) -> String in
            return String(user.name.prefix(1))
        }
        
        usersFirstNameLetters.forEach{ firstNameLetter.insert($0) }
        
        let sortedFirstLetters = firstNameLetter.sorted{ $0 < $1 }
        
        for item in sortedFirstLetters {
            dataSource.append([item: users.sorted{ $0.name < $1.name }.filter({$0.name.hasPrefix(item)})])
        }
    }
    
    @IBAction func textFieldEditingChanges(_ sender: UITextField) {
        
    }
    
}

extension UsersViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].first?.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UserTableViewCell else {
            fatalError()
        }
        if let data = dataSource[indexPath.section].first?.value {
            cell.setupCell(data[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let usersFirstLetter = dataSource[section].first?.key else { return "" }
        return "Użytkownicy których na \(usersFirstLetter)"
    }
    
    
    
}

extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = dataSource[indexPath.section].first?.value[indexPath.row] {
            let vc = UserDetailsViewController()
            vc.user = user
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension UsersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
