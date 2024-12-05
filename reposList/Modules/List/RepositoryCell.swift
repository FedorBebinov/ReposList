//
//  RepositoryCell.swift
//  reposList
//
//  Created by Fedor Bebinov on 01.12.2024.
//

import UIKit
import Kingfisher

class RepositoryCell: UITableViewCell{
    
    private lazy var repoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private lazy var repoTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var repoDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        addSubview(repoTitle)
        addSubview(repoImageView)
        addSubview(repoDescription)
        setImageConstraits()
        setTitleConstraits()
        setDescriptionConstraits()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(repo: StoredRepositoryInfo){
        let url = URL(string: repo.avatarUrl)
        repoImageView.kf.setImage(with:url)
        repoTitle.text = repo.name
        repoDescription.text = repo.specification
    }
    
    private func setImageConstraits(){
        repoImageView.setHeight(to: 80)
        repoImageView.setWidth(to: 80)
        repoImageView.pinTop(to: self, 16)
        repoImageView.pinLeft(to: self, 16)
    }
    
    private func setTitleConstraits(){
        repoTitle.pinLeft(to: repoImageView.trailingAnchor, 16)
        repoTitle.pinTop(to: self, 16)
        repoTitle.pinRight(to: self, 16)
    }
    
    private func setDescriptionConstraits(){
        repoDescription.pin(to: self, [.right, .bottom], 16)
        repoDescription.pinLeft(to: repoImageView.trailingAnchor, 16)
        repoDescription.pinTop(to: repoTitle.bottomAnchor, 16)
    }
}
