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
    private let viewModel = CartCategoryViewModel()
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func bind(){
        viewModel.outputPresentProductListForCategory.bind{ [weak self] category, cartItems in
            guard let self, let category, let cartItems else { return }
            let vc = CartViewController(title: category.name, isChild: true, list: cartItems)
            
            DispatchQueue.main.async{
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        viewModel.outputPresentAddCategoryVC.bind { [weak self] trigger in
            guard let self, trigger != nil else { return }
            
            let vc = AddCategoryViewController()
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium()]
            }
            vc.saveCategory = {
                self.collectionView.reloadData()
            }
            present(vc, animated: true)
        }
    }
    
    //MARK: - configure function
    override func configureHierarchy(){
        super.configureHierarchy()
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
        viewModel.inputAddCategoryButtonTappedTrigger.value = ()
    }
}


extension CartCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 10) / 2
        let height = width + 6 + 16 + 4 + 14
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputCategoryList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryListCollectionViewCell.identifier, for: indexPath) as! CategoryListCollectionViewCell
        cell.setData(viewModel.outputCategoryList.value[indexPath.row])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.inputDidSelectItemIndex.value = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let row = indexPaths.first?.row else { return nil }
        return configureContextMenu(row)
    }
    
    func configureContextMenu(_ index: Int) -> UIContextMenuConfiguration {
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil){ (action) -> UIMenu? in
            let updateAction = UIAction(title: Localized.edit.text, image: ImageAssets.pencil) { _ in
                self.viewModel.outputPresentAddCategoryVC.value = ()
            }
            
            let deleteAction = UIAction(title: Localized.delete.text, image: ImageAssets.trash, attributes: .destructive){ _ in
                
                let alert = UIAlertController(title: Localized.deleteCategory_dlg.title, message: Localized.deleteCategory_dlg.message, preferredStyle: .alert)
                
                let delete = UIAlertAction(title: Localized.deleteCategory_dlg.confirm, style: .destructive)
                
                let cancel = UIAlertAction(title: Localized.deleteCategory_dlg.cancel, style: .cancel)
                cancel.setValue(Color.warmGray, forKey: "titleTextColor")
                
                alert.addAction(delete)
                alert.addAction(cancel)

                self.present(alert, animated: true)
            }
            
            return UIMenu(title: "", children: [updateAction, deleteAction])
        }
        return context
    }
}
