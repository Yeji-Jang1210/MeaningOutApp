//
//  MeaningOutListHeaderView.swift
//  MeaningOutApp
//
//  Created by 장예지 on 6/15/24.
//

import UIKit
import SnapKit

class MeaningOutListHeaderView: UIView {
    
    static var identifier = String(describing: MeaningOutListHeaderView.self)
    
    //MARK: - object
    let resultCountLabel: UILabel = {
        let object = UILabel()
        object.text = "Test"
        object.textColor = Color.primaryOrange
        object.font = BaseFont.medium.boldFont
        return object
    }()
    
    let buttonCollecction: [FilterButton] = {
        return FilterType.allCases.map{ type in
            let object = FilterButton()
            object.setTitle(type.title, for: .normal)
            object.isSelected = false
            object.tag = type.rawValue
            object.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
            return object
        }
    }()
    
    let stackView: UIStackView = {
        let object = UIStackView()
        object.axis = .horizontal
        object.spacing = 4
        object.alignment = .leading
        object.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
        return object
    }()
    //MARK: - properties
    
    //MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configure function
    private func configureHierarchy(){
        let spacer = UIView()
        spacer.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
        addSubview(resultCountLabel)
        addSubview(stackView)
        buttonCollecction.forEach { stackView.addArrangedSubview($0)}
        stackView.addArrangedSubview(spacer)
        
    }
    
    private func configureLayout(){
        resultCountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(24)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(resultCountLabel.snp.bottom).offset(4)
            make.height.equalTo(30)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
    }
    
    private func configureUI(){
    }
    //MARK: - function

}
