//
//  TradersViewController.swift
//  Follow
//
//  Created by Anton Grigorev on 05/02/2019.
//  Copyright © 2019 Follow. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TradersViewController: UIViewController, ReactiveDisposable {
    
    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    fileprivate var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    
    // MARK: - Properties
    
    fileprivate let viewModel: TradersViewModel
    fileprivate let router: Router
    fileprivate(set) var selectedCell: TraderTableViewCell?
    let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Lazy properties
    
    lazy private var tradersTableViewManager = {
        return TradersTableViewManager(traders: viewModel.tradersTask)
    }()
    
    // MARK: - Initializer
    
    init(viewModel: TradersViewModel, router: Router) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
        tabBarItem = router.tabBarItem(for: .traders)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: - UIViewController life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Analytics.track(viewContent: "Traders", ofType: "View")
    }
    
    // MARK: - Reactive bindings setup
    
    fileprivate func setupBindings() {
        
        filmsCollectionViewManager.collectionView = collectionView
        
        filmsCollectionViewManager
            .itemSelected
            .drive(onNext: { [unowned self] (film, cell) in
                self.selectedCell = cell
                self.router.showFilmDetails(for: film, from: self)
            }).disposed(by: disposeBag)
        
        searchBar
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.textSearchTrigger)
            .disposed(by: disposeBag)
        
        collectionView.rx
            .reachedBottom
            .bind(to: viewModel.nextPageTrigger)
            .disposed(by: disposeBag)
        
        collectionView.rx
            .startedDragging
            .withLatestFrom(viewModel.films)
            .asDriver(onErrorDriveWith: Driver.empty())
            .filter { (films) -> Bool in
                return films.count > 0
            }.drive(onNext: { [unowned self] _ in
                self.searchBar.endEditing(true)
            }).disposed(by: disposeBag)
        
        collectionView.rx
            .bounds
            .map { $0.size }
            .distinctUntilChanged()
            .bind(to: sizeObserver)
            .disposed(by: disposeBag)
        
        viewModel
            .films
            .withLatestFrom(searchBar.rx.text.asDriver()) { (films, searchQuery) -> String? in
                guard films.count == 0 else { return nil }
                guard let query = searchQuery, query.count > 0 else { return "Search thousands of films, old or new on TMDb..." }
                return "No results found for '\(query)'"
            }.drive(onNext: { [unowned self] (placeholderString) in
                self.placeholderLabel.text = placeholderString
                UIView.animate(withDuration: 0.2) {
                    self.placeholderView.alpha = placeholderString == nil ? 0.0 : 1.0
                    self.collectionView.alpha = placeholderString == nil ? 1.0 : 0.0
                }
            }).disposed(by: disposeBag)
        
        UIResponder
            .keyboardWillShow
            .subscribe(onNext: { [unowned self] (keyboardInfo) in
                self.setupScrollViewViewInset(forBottom: keyboardInfo.frameEnd.height, animationDuration: keyboardInfo.animationDuration)
            }).disposed(by: disposeBag)
        
        UIResponder
            .keyboardWillHide
            .subscribe(onNext: { [unowned self] (keyboardInfo) in
                self.setupScrollViewViewInset(forBottom: 0, animationDuration: keyboardInfo.animationDuration)
            }).disposed(by: disposeBag)
    }

}
