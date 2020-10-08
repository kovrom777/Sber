//
//  AboutNewsViewController.swift
//  SberTask
//
//  Created by Роман Ковайкин on 06.10.2020.
//

import UIKit

class AboutNewsViewController: UIViewController {

    let titleLable: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 0
        return lbl
    }()

    let publicationDateLable: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textColor = .gray
        return lbl
    }()

    let textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(title: String, description: String, publicationDate: String) {
        textView.text = description
        titleLable.text = title
        publicationDateLable.text = publicationDate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        [titleLable, publicationDateLable, textView].forEach {view.addSubview($0)}
        setConstraints()
    }

    private func setConstraints() {

        titleLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        titleLable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        titleLable.heightAnchor.constraint(equalToConstant: 50).isActive = true

        publicationDateLable.topAnchor.constraint(equalTo: titleLable.bottomAnchor).isActive = true
        publicationDateLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        publicationDateLable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        publicationDateLable.heightAnchor.constraint(equalToConstant: 30).isActive = true

        textView.topAnchor.constraint(equalTo: publicationDateLable.bottomAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

}
