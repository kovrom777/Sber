//
//  ViewController.swift
//  SberTask
//
//  Created by Роман Ковайкин on 05.10.2020.
//

import UIKit

class NewsViewController: UIViewController {
    // MARK: Variables
    private var rssItems: [RSSItem]?
    var URL: String? = UserDefaults.standard.string(forKey: "URL")
    // MARK: Views
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Обновляем")
        refresh.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refresh
    }()

    override func viewWillAppear(_ animated: Bool) {
        if rssItems == nil || URL != UserDefaults.standard.string(forKey: "URL") {
            URL = UserDefaults.standard.string(forKey: "URL")
            fetchdata()
        }
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "News"

        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: #imageLiteral(resourceName: "settings"),
                                                                 landscapeImagePhone: .add,
                                                                 style: .plain,
                                                                 target: self, action: #selector(didTapSettingButton))

        [tableView].forEach {view.addSubview($0)}
        tableView.addSubview(refreshControl)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsCell")
        setConstraints()

    }

    private func updateData() {
        let feedParser = ParseFeed()

        //Ставлю URL по умолчанию, дабы всегда были какие-то новости
        feedParser.parseFeed(url: URL ?? "https://www.banki.ru/xml/news.rss") { (rssItems) in

            if self.rssItems == nil {
                self.rssItems = rssItems
            } else {
                // find first index of new news
                guard let index = rssItems.firstIndex(where: {$0.publicationDate == rssItems[0].publicationDate}),
                      index != 0 else {
                    return
                }
                //insert new elems into array
                let newElems = rssItems[0...index]
                self.rssItems?.insert(contentsOf: newElems, at: 0)
                self.tableView.reloadData()
            }

            OperationQueue.main.addOperation {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
            }
        }
    }

    private func fetchdata() {
        let feedParser = ParseFeed()

        //Ставлю URL по умолчанию, дабы всегда были какие-то новости
        feedParser.parseFeed(url: URL ?? "https://www.banki.ru/xml/news.rss") { (rssItems) in

            self.rssItems = rssItems

            OperationQueue.main.addOperation {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
            }
        }
    }

    private func setConstraints() {
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

    }

    @objc private func didTapSettingButton() {

    }

    @objc func handleRefresh() {

        updateData()
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }

}

extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rssItems = rssItems else {
            return 0
        }
        return rssItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as? NewsTableViewCell
        else {
            assertionFailure("Cell is not available")
            return UITableViewCell()
        }
        
        if let item = rssItems?[indexPath.item] {
            cell.item = item
            cell.selectionStyle = .none
            if item.isRead {
                cell.backgroundColor = #colorLiteral(red: 1, green: 0.8637523055, blue: 0.5971289873, alpha: 0.8678028682)
            } else {
                cell.backgroundColor = .white
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

}

extension NewsViewController: UITableViewDelegate {

}
