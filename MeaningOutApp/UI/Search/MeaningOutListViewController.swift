//
//  MeaningOutListViewController.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/14/24.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyUserDefaults
import Toast

class MeaningOutListViewController: BaseVC {
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
    
    //MARK: - properties
    var content: ShoppingItemList?
    
    var text: String = ""
    var filter: FilterType = .similarity {
        didSet {
            let param = APIParameters(query: text, sort: filter, start: start)
            start = 1
            callAPI(param)
        }
    }
    
    var start = 1
    var isEnd: Bool {
        if let total = content?.total {
            print(total)
            if start > total - 30 || start > 1000 {
                return true
            }
        }
        return false
    }
    
    //MARK: - life cycle
    override init(title: String = "", isChild: Bool = false) {
        super.init(title: title, isChild: isChild)
        text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        
        bindAction()
        
        header.buttonCollecction[0].isSelected = true
        filter = .similarity
    }
    
    //MARK: - configure function
    private func configureHierarchy(){
        view.addSubview(header)
        view.addSubview(collectionView)
    }
    
    private func configureLayout(){
        header.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(80)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureUI(){
        configureCollectionView()
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
    
    private func bindAction(){
        for button in header.buttonCollecction {
            button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        }
    }
    
    private func callAPI(_ param: APIParameters){
        APIService.networking(params: param) { networkResult in
            switch networkResult {
            case .success(let data):
                print(data.start)
                if self.start == 1 {
                    self.content = data
                } else {
                    self.content?.items.append(contentsOf: data.items)
                    
                }
                print(data.items.map{$0.productId})
                self.header.resultCountLabel.text = Localized.result_count_text(count: data.total).text
                self.collectionView.reloadData()
                
                if self.start == 1 {
                    self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
            case .error(let error):
                print(error)
            }
        }
    }
    
    @objc func filterButtonTapped(_ sender: FilterButton){
        for button in header.buttonCollecction {
            if button.tag == sender.tag {
                button.isSelected = true
            } else {
                button.isSelected = false
            }
        }
        filter = FilterType(rawValue: sender.tag)!
    }
    
    @objc func likeButtonTapped(_ sender: UIButton){
        print(Defaults.cartList)
        
        sender.isSelected.toggle()
        guard let productId = content?.items[sender.tag].productId else { return }

        if sender.isSelected {
            print("append")
            Defaults.cartList.append(productId)
        } else {
            print("delete")
            Defaults.cartList.removeAll { $0 == productId }
        }
        
        print("tag:\(sender.tag), id: \(content!.items[sender.tag].productId)")
    }
}

extension MeaningOutListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - 40
        return CGSize(width: width / 2, height: (width / 2) * 1.6)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MeaningOutItemCell.identifier, for: indexPath) as! MeaningOutItemCell
        
        if let item = self.content?.items[indexPath.row] {
            cell.setData(item)
        }
        
        cell.cartButton.tag = indexPath.row
        cell.cartButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = content?.items[indexPath.row] {
            let vc = DetailViewController(title: item.removedHTMLTagTitle, isChild: true)
            vc.url = item.link
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MeaningOutListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let count = content?.items.count {
                if count - 2 == indexPath.row && !isEnd {
                    start += 30
                    let params = APIParameters(query: text, sort: filter, start: start)
                    callAPI(params)
                }
            }
        }
    }
}
