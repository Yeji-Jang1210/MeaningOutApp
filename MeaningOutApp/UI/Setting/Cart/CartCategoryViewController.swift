//
//  CartCategoryViewController.swift
//  MeaningOutApp
//
//  Created by 장예지 on 7/9/24.
//

import UIKit
import SnapKit
import RealmSwift

class CartCategoryViewController: BaseVC {
    //MARK: - object
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        
        let object = UICollectionView(frame: .zero, collectionViewLayout: layout)
        object.backgroundColor = .clear
        object.delegate = self
        object.dataSource = self
        object.register(CategoryListCollectionViewCell.self, forCellWithReuseIdentifier: CategoryListCollectionViewCell.identifier)
        return object
    }()
    
    //MARK: - properties
    let repository = CartRepository()
    lazy var list = repository.fetchCategory()
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    //MARK: - configure function
    override func configureHierarchy(){
        super.configureHierarchy()
        //view.addSubview(tableView)
        view.addSubview(collectionView)
    }
    
    override func configureLayout(){
        super.configureLayout()
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI(){
        super.configureUI()
        let barItem = UIBarButtonItem(image: ImageAssets.plus, style: .done, target: self, action: #selector(addCategoryButtonTapped))
        barItem.tintColor = .primaryOrange
        navigationItem.rightBarButtonItem = barItem
    }
    
    @objc
    func addCategoryButtonTapped(){
        let vc = AddCategoryViewController()
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        vc.saveCategory = {
            self.collectionView.reloadData()
        }
        self.present(vc, animated: true)
    }
}


extension CartCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 10) / 2
        let height = width + 6 + 16 + 4 + 14
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryListCollectionViewCell.identifier, for: indexPath) as! CategoryListCollectionViewCell
        cell.setData(list[indexPath.row])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CartViewController(title: list[indexPath.row].name, isChild: true)
        vc.list = repository.fetch().where {
            $0.category.name == list[indexPath.row].name
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
