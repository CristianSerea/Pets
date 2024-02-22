//
//  PetsViewController.swift
//  Pets
//
//  Created by Cristian Serea on 19.02.2024.
//

import UIKit
import RxSwift
import ProgressHUD
import SDWebImage

protocol PetsViewControllerDelegate {
    func openSettings(settingsViewModel: SettingsViewModel?)
    func didSelectPet(pet: Pet)
}

class PetsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var petsViewControllerDelegate: PetsViewControllerDelegate?
    
    private var petsWrapper: PetsWrapper?
    private var petsViewModel: PetsViewModel?
    private var settingsViewModel: SettingsViewModel?
    private let disposeBag = DisposeBag()
    
    private var isLoadingData = true
    private var isLoadingMoreData = false {
        didSet {
            updateTableFooter()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        registerTableViewCells()
        setupTableRefreshControl()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = LocalizableConstants.petsNavigationItemTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: ImageConstants.Image.slider,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(openSettings))
    }
    
    @objc private func openSettings() {
        var copySettingsViewModel: SettingsViewModel? {
            guard let value = settingsViewModel?.value else {
                return settingsViewModel
            }
            
            return SettingsViewModel(withValue: value)
        }
        
        petsViewControllerDelegate?.openSettings(settingsViewModel: copySettingsViewModel)
    }
    
    private func registerTableViewCells() {
        let nib = UINib(nibName: GlobalConstants.Identifier.petTableViewCell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: GlobalConstants.Identifier.petTableViewCell)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: GlobalConstants.Identifier.tableViewCell)
    }
    
    private func setupTableRefreshControl() {
        tableView.setupRefreshControl(target: self, action: #selector(refreshData))
    }
}

extension PetsViewController {
    func setupViewModel(withOauthManager oauthManager: OauthManager?) {
        guard petsViewModel == nil else {
            return
        }
        
        petsViewModel = PetsViewModel(withOauthManager: oauthManager)
        
        petsViewModel?.petsWrapper.asObserver()
            .skip(1)
            .bind { [weak self] petsWrapper in
                ProgressHUD.dismiss()
                self?.isLoadingData = false
                self?.isLoadingMoreData = false
                self?.petsWrapper = petsWrapper
                self?.tableView.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        petsViewModel?.error.asObserver()
            .bind { [weak self] error in
                ProgressHUD.dismiss()
                self?.isLoadingData = false
                self?.isLoadingMoreData = false
                self?.tableView.refreshControl?.endRefreshing()
                self?.showAlertController(error: error, completion: { [weak self] in
                    self?.fetchData()
                })
            }
            .disposed(by: disposeBag)
        
        fetchData()
    }
    
    private func fetchData() {
        ProgressHUD.animate(LocalizableConstants.petsFetchingDataTitle)
        petsViewModel?.fetchData()
    }
}

extension PetsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoadingData ? .zero : max(petsWrapper?.animals.count ?? .zero, 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if petsWrapper?.animals.count ?? .zero == .zero {
            let cell = tableView.dequeueReusableCell(withIdentifier: GlobalConstants.Identifier.tableViewCell, for: indexPath)
            cell.textLabel?.text = LocalizableConstants.petsNoDataTitle
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .systemGray
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: GlobalConstants.Identifier.petTableViewCell, for: indexPath) as! PetTableViewCell
            cell.setupContent(withPet: petsWrapper?.animals[indexPath.row])

            return cell
        }
    }
}

extension PetsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard petsWrapper?.animals.count ?? .zero > .zero else {
            return
        }
        
        guard let pet = petsWrapper?.animals[indexPath.row] else {
            return
        }
        
        petsViewControllerDelegate?.didSelectPet(pet: pet)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard petsWrapper?.animals.count ?? .zero > .zero else {
            return
        }
        
        guard petsWrapper?.animals.count ?? .zero > .zero else {
            return
        }
        
        let contentOffsetY = scrollView.contentOffset.y
        let contentSizeHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        guard contentOffsetY > contentSizeHeight - height else {
            return
        }
            
        fetchMoreData()
    }
}

extension PetsViewController {
    @objc private func refreshData() {
        petsViewModel?.fetchData(withQuery: settingsViewModel?.query)
    }
    
    private func fetchMoreData() {
        guard !isLoadingMoreData else {
            return
        }
        
        isLoadingMoreData = true
        petsViewModel?.fetchData(withHref: petsWrapper?.pagination.links?.next?.href)
    }
    
    private func updateTableFooter() {
        if isLoadingMoreData {
            tableView.setupTableFooterView()
        } else {
            tableView.tableFooterView = nil
        }
    }
}

extension PetsViewController {
    func reloadData(withSettingsViewModel settingsViewModel: SettingsViewModel?) {
        self.settingsViewModel = settingsViewModel
        
        tableView.setContentOffset(.zero, animated: true)
        ProgressHUD.animate(LocalizableConstants.petsFetchingDataTitle)
        petsViewModel?.fetchData(withQuery: settingsViewModel?.query)
    }
}
