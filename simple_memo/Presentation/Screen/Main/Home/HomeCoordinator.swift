import UIKit


class HomeCoordinator: BaseCoordinator {
    
    var rootViewController: UIViewController?
    
    var homeViewController: HomeViewController?
    var createViewController: CreateViewController?
    var reorderViewController: ReorderViewController?
    var detailViewController: DetailViewController?
    var editViewController: EditViewController?
    
    var homeViewModel: HomeViewModel?
    var createViewModel: CreateViewModel?
    var reorderViewModel: ReorderViewModel?
    var detailViewModel: DetailViewModel?
    var editViewModel: EditViewModel?
    
    init(homeViewModel: HomeViewModel, createViewModel: CreateViewModel, reorderViewModel: ReorderViewModel, detailViewModel: DetailViewModel, editViewModel: EditViewModel) {
        self.homeViewModel = homeViewModel
        self.createViewModel = createViewModel
        self.reorderViewModel = reorderViewModel
        self.detailViewModel = detailViewModel
        self.editViewModel = editViewModel
    }
    
    override func start() {
        setupBinding()
        homeViewController = HomeViewController.instantiate()
        homeViewController?.viewModel = homeViewModel
        rootViewController = homeViewController
    }
    
    func setupBinding() {
        guard let homeVM = homeViewModel, let createVM = createViewModel, let reorderVM = reorderViewModel, let detailVM = detailViewModel, let editVM = editViewModel else { return }
        
        homeVM.event.subscribe { [weak self] (event) in
            switch(event) {
            case .SHOW_CREATE: self?.showCreate()
            case .SHOW_REORDER: self?.showReorder()
            case .SHOW_DETAIL(let memoId): self?.showDetail(memoId: memoId)
            }
        } onError: { (error) in
            
        } onCompleted: {
            
        } onDisposed: {
            
        }.disposed(by: disposeBag)
        
        createVM.event.subscribe { [weak self] (event) in
            switch(event) {
            case .CLOSE: self?.closeCreate()
            case .DELETE_SUCCESS: self?.closeCreate()
            case .DELETE_FAILURE: self?.closeCreate()
            }
        } onError: { (error) in
            
        } onCompleted: {
            
        } onDisposed: {
            
        }.disposed(by: disposeBag)
        
        reorderVM.event.subscribe { [weak self] (event) in
            switch(event) {
            case .CLOSE: self?.closeReorder()
            case .UPDATE_SUCCESS: self?.closeReorder()
            case .UPDATE_FAILURE: self?.closeReorder()
            }
        } onError: { (error) in
            
        } onCompleted: {
            
        } onDisposed: {
            
        }.disposed(by: disposeBag)
        
        detailVM.event.subscribe { [weak self] (event) in
            switch(event) {
            case .CLOSE: self?.closeDetail()
            case .DELETE_SUCCESS: self?.closeDetail()
            case .DELETE_FAILURE: self?.closeDetail()
            case .SHOW_EDIT(let memoID): self?.showEdit(memoId: memoID)
            }
        } onError: { (error) in
            
        } onCompleted: {
            
        } onDisposed: {
            
        }.disposed(by: disposeBag)
        
        editVM.event.subscribe { [weak self] (event) in
            switch(event) {
            case .CLOSE: self?.closeEdit()
            case .UPDATE_SUCCESS: self?.closeEdit()
            case .UPDATE_FAILURE: self?.closeDetail()
            }
        } onError: { (error) in
            
        } onCompleted: {
            
        } onDisposed: {
            
        }.disposed(by: disposeBag)
    }
    
    func showCreate() {
        createViewController = CreateViewController.instantiate()
        createViewController?.viewModel = createViewModel
        createViewController?.modalPresentationStyle = .fullScreen
        homeViewController?.present(createViewController!, animated: true, completion: nil)
    }
    
    func closeCreate()  {
        homeViewController?.dismiss(animated: true, completion: nil)
    }
    
    func showReorder() {
        reorderViewController = ReorderViewController.instantiate()
        reorderViewController?.viewModel = reorderViewModel
        reorderViewController?.modalPresentationStyle = .fullScreen
        homeViewController?.present(reorderViewController!, animated: true, completion: nil)
    }
    
    func closeReorder() {
        homeViewController?.dismiss(animated: true, completion: nil)
    }
    
    func showDetail(memoId: Int) {
        detailViewController = DetailViewController.instantiate()
        detailViewController?.memoId = memoId
        detailViewController?.viewModel = detailViewModel
        detailViewController?.modalPresentationStyle = .fullScreen
        homeViewController?.present(detailViewController!, animated: true, completion: nil)
    }
    
    func closeDetail() {
        homeViewController?.dismiss(animated: true, completion: nil)
    }
    
    func showEdit(memoId: Int) {
        editViewController = EditViewController.instantiate()
        editViewController?.memoId = memoId
        editViewController?.viewModel = editViewModel
        editViewController?.modalPresentationStyle = .fullScreen
        detailViewController?.present(editViewController!, animated: true, completion: nil)
    }
    
    func closeEdit() {
        detailViewController?.dismiss(animated: true, completion: nil)
    }
    
}
