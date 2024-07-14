//
//  CartViewController.swift
//  MeaningOutApp
//
//  Created by 장예지 on 7/5/24.
//

import UIKit
import SnapKit
import RealmSwift


final class CartViewController: BaseVC {
    
    lazy var searchBar: UISearchBar = {
        let object = UISearchBar()
        object.placeholder = Localized.search_cartItem_placeholder.text
        object.delegate = self
        return object
    }()
    
    lazy var collectionView: UICollectionView = {
        let layer = UICollectionViewFlowLayout()
        layer.minimumInteritemSpacing = 16
        layer.minimumLineSpacing = 20
        layer.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        
        let object = UICollectionView(frame: .zero, collectionViewLayout: layer)
        object.backgroundColor = Color.white
        object.delegate = self
        object.dataSource = self
        object.register(MeaningOutListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, 
                                                        withReuseIdentifier: MeaningOutListHeaderView.identifier)
        object.register(MeaningOutItemCell.self, forCellWithReuseIdentifier: MeaningOutItemCell.identifier)
        return object
    }()
    
    private var viewModel: CartViewModel
    
    init(title: String = "", isChild: Bool = false, list: Results<CartItem>) {
        self.viewModel = CartViewModel(list: list)
        super.init(title: title, isChild: isChild)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.text = ""        
        collectionView.reloadData()
    }
    
    private func bind(){
        viewModel.outputCartItemIsDeleted.bind { isDeleted in
            guard isDeleted != nil else { return }
            
            DispatchQueue.main.async {
                self.view.makeToast("장바구니에서 삭제되었습니다.")
                self.collectionView.reloadData()
            }
        }
        
        viewModel.outputCartItemFilteredList.bind { filtered in
            guard filtered != nil else { return }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        view.addSubview(collectionView)
        view.addSubview(searchBar)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc
    func likeButtonTapped(_ sender: UIButton){
        viewModel.inputPassLikeButtonSenderTag.value = sender.tag
    }
}

extension CartViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 40
        return CGSize(width: width / 2, height: (width / 2) * 1.6)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputCartItemFilteredList.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MeaningOutItemCell.identifier, for: indexPath) as! MeaningOutItemCell
        
        if let item = viewModel.outputCartItemFilteredList.value?[indexPath.row]{
            cell.setData(data: item, isSelected: viewModel.findProductId(item.productId))
            
            cell.cartButton.tag = indexPath.row
            cell.cartButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        }
        
        return cell
    }
}

extension CartViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.inputSearchText.value = searchText
    }
}
