//
//  ViewController.swift
//  reposList
//
//  Created by Fedor Bebinov on 01.12.2024.
//

import UIKit
import Combine

class ListViewController: UIViewController {
    
    private let viewModel: ListViewModel
    private var store: [AnyCancellable] = []
    
    private lazy var reposTableView: UITableView =  {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(RepositoryCell.self, forCellReuseIdentifier: "RepositoryCell")
        return tableView
    }()
    
    init(viewModel: ListViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "iOS featured repos"
        view.backgroundColor = .systemBackground
        view.addSubview(reposTableView)
        reposTableView.pin(to: view)
        
        viewModel.$repos.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.reposTableView.reloadData()
            }
        }.store(in: &store)
        
        viewModel.$isPaginating.sink { [weak self] isPaginating in
            DispatchQueue.main.async {
                if isPaginating{
                    self?.reposTableView.tableFooterView = self?.createLoadingIndicator()
                } else {
                    self?.reposTableView.tableFooterView = nil
                }
            }
        }.store(in: &store)
        
        viewModel.$errorMessage.sink { [weak self] errorMessage in
            guard let errorMessage else {
                return
            }
            let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
            alertController.addAction(okAction)
            self?.present(alertController, animated: true, completion: nil)
        }.store(in: &store)
        
        viewModel.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshRepos()
    }
    
    
    
    private func createLoadingIndicator() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = footerView.center
        footerView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        return footerView
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repos.count
        //return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell") as! RepositoryCell
        print(viewModel.repos.count)
        print(indexPath.row)
        let repo = viewModel.repos[indexPath.row]
        cell.set(repo: repo)
        return cell
    }
    
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = articles[indexPath.row].id
        navigationController?.pushViewController(ArticleVC(id: id), animated: true)
    }*/
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { _, _, completion in
            self.viewModel.deleteRepo(index: indexPath.row)
            self.viewModel.refreshRepos() 
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repositoryVC = RepositoryModule.build(reposFacade: ServiceLocator.reposFacade, repo: self.viewModel.repos[indexPath.row])
        navigationController?.pushViewController(repositoryVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > reposTableView.contentSize.height - 100 - scrollView.frame.height {
            viewModel.fetchData()
        }
    }
}

