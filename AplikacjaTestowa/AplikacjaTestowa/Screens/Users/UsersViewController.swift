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
    
    var dataSource: [[String: [User]]] = []
    
    var filteredDataSource: [[String: [User]]] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var lastVisibleCellIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchTextField()
        fetchUsers()
     
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            if let tabBarHeight = (self.navigationController?.viewControllers.first as? TabBarViewController)?.tabBar.frame.height {
                tableView.contentInset.bottom = keyboardFrame.size.height - tabBarHeight
                tableView.scrollIndicatorInsets.bottom = keyboardFrame.size.height - tabBarHeight
                if let cell = tableView.visibleCells.last,
                    let lastVisibleCellIndexPath = tableView.indexPath(for: cell) {
                    self.lastVisibleCellIndexPath = lastVisibleCellIndexPath
                    self.tableView.scrollToRow(at:lastVisibleCellIndexPath, at: .bottom, animated: true)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        if let userInfo = notification.userInfo {
            let _ = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            tableView.contentInset.bottom = 0
            if let lastVisibleCellIndexPath = lastVisibleCellIndexPath {
                tableView.scrollToRow(at: lastVisibleCellIndexPath, at: .bottom, animated: true)
            }
        }
    }
    
    
    private func setupSearchTextField() {
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.systemGray.cgColor
        searchTextField.layer.cornerRadius = 5.0
        searchTextField.setLeftPadding(CGFloat(16))
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
        
        filteredDataSource = dataSource
    }
    
    @IBAction func textFieldEditingChanges(_ sender: UITextField) {
        guard let text = sender.text, !text.isEmpty else {
            filteredDataSource = dataSource
            return
        }
        
        filteredDataSource = []
        for dictionary in dataSource {
            for dictionaryElement in dictionary {
                let users = dictionaryElement.value.filter { (user) -> Bool in
                    return user.name.lowercased().contains(text.lowercased()) || user.surname.lowercased().contains(text.lowercased())
                }
                if !users.isEmpty {
                    filteredDataSource.append([dictionaryElement.key: users])
                }
            }
        }
    }
}

extension UsersViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDataSource[section].first?.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UserTableViewCell else {
            fatalError()
        }
        if let data = filteredDataSource[indexPath.section].first?.value {
            cell.setupCell(data[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let usersFirstLetter = filteredDataSource[section].first?.key else { return "" }
        return "Użytkownicy których na \(usersFirstLetter)"
    }
}

extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchTextField.resignFirstResponder()
        if let user = filteredDataSource[indexPath.section].first?.value[indexPath.row] {
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
