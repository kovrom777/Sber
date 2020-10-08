//
//  SettingsViewController.swift
//  SberTask
//
//  Created by Роман Ковайкин on 07.10.2020.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func updateFeed(URL: String)
}

class SettingsViewController: UIViewController {

    var urlsArray: [String] = []
    var delegate: SettingsViewControllerDelegate?

    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        return table
    }()

    let inputTextField: UITextField = {
        let txt = UITextField()
        txt.placeholder = "Enter URL"
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.keyboardType = .URL
        txt.layer.borderWidth = 1
        return txt
    }()

    let saveButton: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 20
        btn.setTitle("Save", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .orange
        btn.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return btn

    }()

    override func viewWillAppear(_ animated: Bool) {
        guard let additionalUrlsArray = UserDefaults.standard.stringArray(forKey: "SettingsArray") else {
            return
        }
        urlsArray = additionalUrlsArray
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingCell")
        [tableView, inputTextField, saveButton].forEach {view.addSubview($0)}
        setConstraints()
        view.dismissKey()
    }

    private func setConstraints() {
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true

        inputTextField.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20).isActive = true
        inputTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        inputTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        inputTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true

        saveButton.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 10).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    @objc private func didTapSaveButton() {

        guard let url = inputTextField.text else {
            return
        }

        urlsArray.append(url)
        UserDefaults.standard.setValue(urlsArray, forKey: "SettingsArray")
        UserDefaults.standard.synchronize()
        inputTextField.text = ""
        tableView.reloadData()

    }

}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urlsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        cell.textLabel?.text = urlsArray[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.updateFeed(URL: urlsArray[indexPath.row])
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            urlsArray.remove(at: indexPath.row)
            UserDefaults.standard.setValue(urlsArray, forKeyPath: "SettingsArray")
            UserDefaults.standard.synchronize()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}

extension SettingsViewController: UITableViewDelegate {

}
