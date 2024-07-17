//
//  MeaningOutListViewController.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/14/24.
//

import UIKit
import SnapKit
import Alamofire
import Lottie
import SwiftyUserDefaults
import Toast

final class MeaningOutListViewController: BaseVC {
    //MARK: - object
    let collectionView: UICollectionView = {
        let layer = UICollectionViewFlowLayout()
        layer.minimumInteritemSpacing = 16
        layer.minimumLineSpacing = 20
        layer.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        let object = UICollectionView(frame: .zero, collectionViewLayout: layer)
        
        object.backgroundColor = Color.white
        return object
    }()
    
    let header: MeaningOutListHeaderView = {
        let object = MeaningOutListHeaderView()
        return object
    }()
    
    let container: UIView = {
        let object = UIView()
        object.backgroundColor = Color.white.withAlphaComponent(0.4)
        object.isHidden = true
        return object
    }()
    
    let cartAnimation: LottieAnimationView = {
        let object = LottieAnimationView(name: "cart")
        object.animationSpeed = 1.5
        object.loopMode = .playOnce
        return object
    }()
    
    let loadAnimation: LottieAnimationView = {
        let object = LottieAnimationView(name: "loading")
        object.loopMode = .loop
        return object
    }()
    
    //MARK: - properties
    private var viewModel: MeaningOutListViewModel!
    
    //MARK: - life cycle
    override init(title: String = "", isChild: Bool = false) {
        super.init(title: title, isChild: isChild)
        viewModel = MeaningOutListViewModel(text: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    //MARK: - configure function
    override func configureHierarchy(){
        view.addSubview(header)
        view.addSubview(collectionView)
        view.addSubview(container)
        
        container.addSubview(cartAnimation)
        container.addSubview(loadAnimation)
    }
    
    override func configureLayout(){
        header.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(80)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        loadAnimation.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(loadAnimation.snp.width)
        }
        
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cartAnimation.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(cartAnimation.snp.width)
        }
    }
    
    override func configureUI(){
        configureCollectionView()
        
        for button in header.buttonCollecction {
            button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        }
    }
    
    private func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(MeaningOutListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MeaningOutListHeaderView.identifier)
        collectionView.register(MeaningOutItemCell.self, forCellWithReuseIdentifier: MeaningOutItemCell.identifier)
    }
    
    //MARK: - function
    override func bind(){
        viewModel.outputProducts.bind { [weak self] products in
            guard let self else { return }
            if viewModel.start == 1 && !products.isEmpty {
                collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        }
        
        viewModel.outputTotal.bind { [weak self] total in
            guard let self else { return }
            header.resultCountLabel.text = Localized.result_count_text(count: total).text
            collectionView.reloadData()
        }
        
        viewModel.outputCallAPIError.bind { [weak self] error in
            guard let self = self, let error = error else { return }
            
            handlingError(error)
            navigationController?.popViewController(animated: true)
        }
        
        viewModel.outputFilter.bind { [weak self] type in
            guard let self else { return }
            header.buttonCollecction[type.rawValue].isSelected = true
            for button in header.buttonCollecction {
                if button.tag == type.rawValue {
                    button.isSelected = true
                } else {
                    button.isSelected = false
                }
            }
        }
        
        viewModel.outputCallAnimation.bind { [weak self] type in
            guard let self = self, let type = type else { return }
            
            DispatchQueue.main.async {
                switch type {
                case .none:
                    self.container.isHidden = true
                    self.cartAnimation.stop()
                    self.cartAnimation.isHidden = true
                    self.loadAnimation.stop()
                    self.loadAnimation.isHidden = true
                case .adding:
                    self.container.isHidden = false
                    self.loadAnimation.isHidden = true
                    self.cartAnimation.isHidden = false
                    self.cartAnimation.play()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                        self.viewModel.outputCallAnimation.value = LottieAnimationType.none
                    }
                case .loading:
                    self.container.isHidden = false
                    self.cartAnimation.isHidden = true
                    self.loadAnimation.isHidden = false
                    self.loadAnimation.play()
                }
            }
        }
        
        viewModel.outputPresentCategoryVC.bind { [weak self] trigger in
            guard let self = self, trigger != nil else { return }
            
            let vc = AddProductViewController()
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium()]
            }
            
            vc.passIndex = { [weak self] category in
                guard let self else { return }
                viewModel.inputAddProductTrigger.value = category
            }
            present(vc, animated: true)
        }
        
        viewModel.outputCallSelectedProductToast.bind { [weak self] isSelected in
            guard let self = self, let isSelected = isSelected else { return }
    
                self.collectionView.reloadData()
                self.view.makeToast(isSelected ? Localized.like_select_message.message : Localized.like_unselect_message.message)
        }
    }
    
    @objc func filterButtonTapped(_ sender: FilterButton){
        if !viewModel.outputProducts.value.isEmpty {
            viewModel.inputFilter.value = FilterType(rawValue: sender.tag)!
        }
    }
    
    @objc func likeButtonTapped(_ sender: UIButton){
        viewModel.inputIsLikeButtonSelected.value = (!sender.isSelected, sender.tag)
    }
    
    func handlingError(_ error: NetworkingError){
        // 메인 스레드에서 토스트 메시지 표시
        DispatchQueue.main.async {
            self.view.makeToast(error.message)
        }
        
    }
}

extension MeaningOutListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 40
        return CGSize(width: width / 2, height: (width / 2) * 1.6)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputProducts.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MeaningOutItemCell.identifier, for: indexPath) as! MeaningOutItemCell
        
        let item = self.viewModel.outputProducts.value[indexPath.row]
        cell.setData(item, searchText: self.viewModel.text, isSelected: self.viewModel.productIsAddedCart(item))
        
        cell.cartButton.tag = indexPath.row
        cell.cartButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.outputProducts.value[indexPath.row]
        let vc = ProductWebViewController(title: item.removedHTMLTagTitle, isChild: true, url: item.link, product: item)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MeaningOutListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if self.viewModel.outputProducts.value.count - 2 == indexPath.row && !viewModel.isEnd {
                viewModel.inputNextPageTrigger.value = ()
            }
        }
    }
}
