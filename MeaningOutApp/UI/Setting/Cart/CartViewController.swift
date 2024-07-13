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
    
    var repository = CartRepository()
    var list: Results<CartItem>?
    lazy var filteredList = list
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.text = ""        
        collectionView.reloadData()
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
        if let item = list?[sender.tag] {
            repository.deleteItem(item: item)
            
            view.makeToast("장바구니에서 삭제되었습니다.")
            collectionView.reloadData()
        }
    }
}

extension CartViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 40
        return CGSize(width: width / 2, height: (width / 2) * 1.6)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MeaningOutItemCell.identifier, for: indexPath) as! MeaningOutItemCell
        
        if let item = filteredList?[indexPath.row] {
            cell.setData(data: item, isSelected: repository.findProductId(productId: item.productId))
            
            cell.cartButton.tag = indexPath.row
            cell.cartButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        }
        
        return cell
    }
}

extension CartViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(#function)
        let filtered = list?.where {
            $0.title.contains(searchText, options: .caseInsensitive)
        }
        
        filteredList = searchText.isEmpty ? list : filtered
        collectionView.reloadData()
    }
}
