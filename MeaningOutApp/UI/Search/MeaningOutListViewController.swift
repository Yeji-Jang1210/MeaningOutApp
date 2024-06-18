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

class MeaningOutListViewController: BaseVC {
    
    enum LottieAnimationType {
        case none
        case adding
        case loading
    }
    
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
    var content: ShoppingItemList?
    
    var text: String = ""
    var filter: FilterType = .similarity {
        didSet {
            start = 1
            let param = APIParameters(query: text, sort: filter, start: start)
            dump(param)
            callAPI(param)
        }
    }
    var selectIndex: Int?
    
    var start = 1
    var isEnd: Bool {
        if let total = content?.total {
            if start > total - 30 || start > 1000 {
                return true
            }
        }
        return false
    }

    var animationType: LottieAnimationType = .none {
        didSet {
            switch animationType {
            case .none:
                container.isHidden = true
                cartAnimation.stop()
                cartAnimation.isHidden = true
                loadAnimation.stop()
                loadAnimation.isHidden = true
            case .adding:
                container.isHidden = false
                loadAnimation.isHidden = true
                cartAnimation.isHidden = false
                cartAnimation.play()
            case .loading:
                container.isHidden = false
                cartAnimation.isHidden = true
                loadAnimation.isHidden = false
                loadAnimation.play()
            }
        }
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let index = selectIndex {
            collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
    }
    
    //MARK: - configure function
    private func configureHierarchy(){
        view.addSubview(header)
        view.addSubview(collectionView)
        view.addSubview(container)
        
        container.addSubview(cartAnimation)
        container.addSubview(loadAnimation)
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
        animationType = .loading
        APIService.networking(params: param) { networkResult in
            switch networkResult {
            case .success(let data):
                
                if self.start == 1 {
                    self.content = data
                } else {
                    self.content?.items.append(contentsOf: data.items)
                }
                
                self.header.resultCountLabel.text = Localized.result_count_text(count: data.total).text
                self.collectionView.reloadData()
                
                self.animationType = .none
                
                if self.start == 1 && !data.items.isEmpty {
                    self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
            case .error(let error):
                self.handlingError(error)
            }
        }
    }
    
    @objc func filterButtonTapped(_ sender: FilterButton){
        guard let content else { return }
        if !content.items.isEmpty {
            for button in header.buttonCollecction {
                if button.tag == sender.tag {
                    button.isSelected = true
                } else {
                    button.isSelected = false
                }
            }
            filter = FilterType(rawValue: sender.tag)!
        }
    }
    
    @objc func likeButtonTapped(_ sender: UIButton){
        guard let productId = content?.items[sender.tag].productId else { return }
        
        sender.isSelected.toggle()
        
        if sender.isSelected {
            print("append")
            animationType = .adding
            User.cartList.append(productId)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                self.animationType = .none
            }
            
        } else {
            print("delete")
            User.cartList.removeAll { $0 == productId }
        }
        
        view.makeToast(sender.isSelected ? Localized.like_select_message.message : Localized.like_unselect_message.message)
    }
    
    func handlingError(_ error: AFError){
        var errorMessage = ""
        
        if let underlyingError = error.underlyingError as NSError? {
            if underlyingError.domain == NSURLErrorDomain {
                switch underlyingError.code {
                case NSURLErrorNotConnectedToInternet:
                    errorMessage = Localized.NSURLErrorNotConnectedToInternet.message
                case NSURLErrorTimedOut:
                    errorMessage = Localized.NSURLErrorTimedOut.message
                default:
                    errorMessage = Localized.unownedError.message
                }
            }
        }
        
        // 메인 스레드에서 토스트 메시지 표시
        view.makeToast(errorMessage)
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
            cell.searchText = text
            cell.setData(item)
        }
        
        cell.cartButton.tag = indexPath.row
        cell.cartButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = content?.items[indexPath.row] {
            selectIndex = indexPath.row
            let vc = DetailViewController(title: item.removedHTMLTagTitle, isChild: true)
            vc.setData(url: item.link, id: item.productId)
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
