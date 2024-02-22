//
//  SettingsViewController.swift
//  Pets
//
//  Created by Cristian Serea on 21.02.2024.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

protocol SettingsViewControllerDelegate {
    func save(settingsViewModel: SettingsViewModel?)
}

class SettingsViewController: UIViewController {
    private lazy var tableView: UITableView = getTableView()
    private lazy var button: UIButton = getButton()
    
    var settingsViewControllerDelegate: SettingsViewControllerDelegate?
    
    private var sections: [SectionModel<SectionType, Option>]? {
        didSet {
            navigationItem.rightBarButtonItem = getRightBarButtonItem()
        }
    }
    
    private var settingsViewModel: SettingsViewModel?
    private let disposeBag = DisposeBag()
    
    init(withSettingsViewModel settingsViewModel: SettingsViewModel?) {
        self.settingsViewModel = settingsViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupView()
        setupNavigationBar()
        setupConstraints()
        setupTableView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        button.applyCornerRadius()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupNavigationBar() {
        navigationItem.title = LocalizableConstants.settingsNavigationItemTitle
        navigationItem.rightBarButtonItem = getRightBarButtonItem()
    }
    
    private func getRightBarButtonItem() -> UIBarButtonItem? {
        guard settingsViewModel?.canReset ?? false else {
            return nil
        }
        
        return UIBarButtonItem(title: LocalizableConstants.resetButtonTitle,
                               style: .plain,
                               target: self,
                               action: #selector(reset))
    }
}

extension SettingsViewController {
    private func getTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: GlobalConstants.Identifier.tableViewCell)
        view.addSubview(tableView)
        
        return tableView
    }
    
    private func getButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .systemBlue           
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        view.addSubview(button)
        
        return button
    }
}

extension SettingsViewController {
    private func setupConstraints() {
        setupConstraintsForTableView()
        setupConstraintsForButton()
    }
    
    private func setupConstraintsForTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    private func setupConstraintsForButton() {
        let constant = UIApplication.shared.bottomSafeAreaInsets > .zero ? .zero : GlobalConstants.Layout.marginOffset
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -constant).isActive = true
        button.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: GlobalConstants.Layout.marginOffset).isActive = true
        button.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -GlobalConstants.Layout.marginOffset).isActive = true
        button.heightAnchor.constraint(equalToConstant: GlobalConstants.Layout.defaultHeight).isActive = true
    }
}

extension SettingsViewController {
    private func setupTableView() {
        if settingsViewModel == nil {
            settingsViewModel = SettingsViewModel()
        }
        
        settingsViewModel?.sections.asObserver()
            .bind { [weak self] sections in
                self?.sections = sections
            }
            .disposed(by: disposeBag)
        
        settingsViewModel?.sections
            .bind(to: tableView.rx.items(dataSource: getDataSource()))
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.didSelect(withIndexPath: indexPath)
            })
            .disposed(by: disposeBag)
    }
}

extension SettingsViewController {
    private func getDataSource() -> RxTableViewSectionedReloadDataSource<SectionModel<SectionType, Option>> {
        return RxTableViewSectionedReloadDataSource<SectionModel<SectionType, Option>>(
            configureCell: { (_, tableView, indexPath, option) in
                let cell = tableView.dequeueReusableCell(withIdentifier: GlobalConstants.Identifier.tableViewCell)!
                cell.selectionStyle = .none
                
                let isEnabled = option.sort?.isEnabled ?? option.filter?.isEnabled ?? true
                
                var contentConfiguration = cell.defaultContentConfiguration()
                contentConfiguration.textProperties.color = isEnabled ? .white : .systemGray
                contentConfiguration.secondaryTextProperties.color = .systemGray
                contentConfiguration.text = option.title
                
                if indexPath.section == .zero {
                    contentConfiguration.secondaryText = option.hint
                    
                    cell.accessoryType = option.sort?.isSelected ?? false ? .checkmark : .none
                    cell.accessoryView = nil
                } else {
                    contentConfiguration.secondaryText = option.hint
                    
                    let accessoryLabel = UILabel()
                    accessoryLabel.text = option.filter?.placeholder
                    accessoryLabel.textColor = .systemBlue
                    accessoryLabel.sizeToFit()
                    cell.accessoryView = accessoryLabel
                }
                
                cell.contentConfiguration = contentConfiguration

                return cell
            },
            titleForHeaderInSection: { dataSource, section in
                return dataSource[section].model.rawValue
            }
        )
    }
    
    private func didSelect(withIndexPath indexPath: IndexPath) {
        if indexPath.section == .zero {
            let sort = sections?.last(where: { $0.model == .Sort })
            let option = sort?.items[indexPath.row]
            
            guard option?.isEnabled ?? true else {
                return
            }
            
            settingsViewModel?.selectSort(withIndexPath: indexPath)
        } else {
            let filter = sections?.last(where: { $0.model == .Filter })
            let option = filter?.items[indexPath.row]
            let filterType = option?.filter?.filterType
            
            guard option?.isEnabled ?? true else {
                return
            }
            
            switch filterType {
            case .PetType:
                let titles = PetType.allCases.map { $0.localizable }
                let actions = PetType.allCases.map { $0.rawValue }
                presetActions(withOption: option, withTitles: titles, withActions: actions, withIndexPath: indexPath)
            case .Gender:
                let titles = Gender.allCases.map { $0.localizable }
                let actions = Gender.allCases.map { $0.rawValue }
                presetActions(withOption: option, withTitles: titles, withActions: actions, withIndexPath: indexPath)
            case .Location:
                let titles = Location.allCases.map { $0.localizable }
                let actions = Location.allCases.map { $0.rawValue }
                presetActions(withOption: option, withTitles: titles, withActions: actions, withIndexPath: indexPath)
            case .Distance:
                let titles = Distance.allCases.map { $0.localizable }
                let actions = Distance.allCases.map { $0.rawValue }
                presetActions(withOption: option, withTitles: titles, withActions: actions, withIndexPath: indexPath)
            default:
                break
            }
        }
    }
    
    private func presetActions(withOption option: Option?,
                               withTitles titles: [String],
                               withActions actions: [String],
                               withIndexPath indexPath: IndexPath) {
        presentActionSheetController(withTitle: option?.title, withActionTitles: titles, completion: { [weak self] index in
            let placeholder = titles[index]
            let value = index == .zero && option?.filter?.filterType != .Distance ? nil : actions[index]
            self?.settingsViewModel?.selectFilter(withIndexPath: indexPath,
                                                  withPlaceholder: placeholder,
                                                  withValue: value)
        })
    }
}

extension SettingsViewController {
    @objc private func reset() {
        settingsViewModel?.reset()
    }
    
    @objc private func save() {
        let settingsViewModel = settingsViewModel?.canReset ?? false ? settingsViewModel : nil
        settingsViewControllerDelegate?.save(settingsViewModel: settingsViewModel)
    }
}
