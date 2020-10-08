//
//  NewsTableViewCell.swift
//  SberTask
//
//  Created by Роман Ковайкин on 05.10.2020.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    let title: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 0
        lbl.lineBreakStrategy = .pushOut
        return lbl
    }()

    let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()

    var item: RSSItem! {
        didSet {
            title.text = item.title
            dateLabel.text = item.publicationDate
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [title, dateLabel].forEach {contentView.addSubview($0)}
        setConstraint()

    }

    func setConstraint() {
        dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true

        title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        title.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -5).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
