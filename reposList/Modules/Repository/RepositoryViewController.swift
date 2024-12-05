//
//  RepositoryViewController.swift
//  reposList
//
//  Created by Fedor Bebinov on 04.12.2024.
//

import UIKit
import Combine

final class RepositoryViewController: UIViewController {
    
    private let viewModel: RepositoryViewModel
    
    private var store: [AnyCancellable] = []
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var repoTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 32)
        return label
    }()
    
    private lazy var repoDescription: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.delegate = self
        return textView
    }()
    
    init(viewModel: RepositoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(repoTitle)
        view.addSubview(avatarImageView)
        view.addSubview(repoDescription)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveChanges))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        repoDescription.becomeFirstResponder()
        
        setImageConstraits()
        setTitleConstraits()
        setDescriptionConstraits()
        setData(repo: viewModel.repo)
        
        viewModel.$errorMessage.sink { [weak self] errorMessage in
            guard let errorMessage else {
                return
            }
            let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
            alertController.addAction(okAction)
            DispatchQueue.main.async {
                self?.present(alertController, animated: true, completion: nil)
            }
        }.store(in: &store)
    }
    
    func setData(repo: StoredRepositoryInfo){
        let url = URL(string: repo.avatarUrl)
        avatarImageView.kf.setImage(with:url)
        repoTitle.text = repo.name
        repoDescription.text = repo.specification
    }
    
    private func setImageConstraits(){
        avatarImageView.setHeight(to: 100)
        avatarImageView.setWidth(to: 100)
        avatarImageView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 32)
        avatarImageView.pinLeft(to: view.leadingAnchor, 32)
    }
    
    private func setTitleConstraits(){
        repoTitle.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 32)
        repoTitle.pinLeft(to: avatarImageView.trailingAnchor, 32)
        repoTitle.pinRight(to: view.trailingAnchor, 32)
        repoTitle.pinCenter(to: avatarImageView.centerYAnchor)
    }
    
    private func setDescriptionConstraits(){
        repoDescription.pinTop(to: avatarImageView.bottomAnchor, 32)
        repoDescription.pinLeft(to: view.leadingAnchor, 16)
        repoDescription.pinRight(to: view.trailingAnchor, 16)
        repoDescription.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 16)
    }
    
    @objc
    private func saveChanges(){
        self.title = nil
        navigationItem.rightBarButtonItem?.isEnabled = false
        viewModel.uploadData(description: repoDescription.text)
    }
}

extension RepositoryViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.title = "Unsaved*"
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
}
