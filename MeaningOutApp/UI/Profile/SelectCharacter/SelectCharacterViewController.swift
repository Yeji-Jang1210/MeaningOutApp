//
//  SelectCharacterViewController.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/13/24.
//

import UIKit
import SnapKit

class SelectCharacterViewController: BaseVC {
    //MARK: - object
    let characterView: CharacterView = {
        let object = CharacterView(style: .setting)
        return object
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    //MARK: - properties
    var selectNumber: Int = 0 {
        didSet {
            characterView.image = Character.getImage(num: selectNumber)
            collectionView.reloadData()
        }
    }
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    //MARK: - configure function
    private func configureHierarchy(){
        view.addSubview(characterView)
        view.addSubview(collectionView)
    }
    
    private func configureLayout(){
        characterView.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(120)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
        }
        
        collectionView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.top.equalTo(characterView.snp.bottom).offset(40)
        }
    }
    
    private func configureUI(){ 
        configureCollectionView()
    }
    
    private func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: CharacterCollectionViewCell.identifier)
    }
    //MARK: - function
    
}

extension SelectCharacterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 30
        return CGSize(width: width/4, height: width/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Character.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.identifier, for: indexPath) as! CharacterCollectionViewCell
        
        if selectNumber == indexPath.row {
            cell.characterView.style = .select
        } else {
            cell.characterView.style = .unselect
        }
        cell.setData(Character.list[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectNumber = indexPath.row
    }
}
