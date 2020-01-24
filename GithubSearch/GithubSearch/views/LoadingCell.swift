//
//  LoadingCell.swift
//  GithubSearch
//
//  Created by Jaycee on 2020/01/21.
//  Copyright © 2020 Jaycee. All rights reserved.
//

import UIKit
import Then

class LoadingCell: UITableViewCell {
    
    static let reuseIdentifier = "LoadingCell"
    
    let indicatorView = UIActivityIndicatorView().then {
        $0.color = .gray
        $0.style = .large
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}


extension LoadingCell {
    func setupUI(){
        self.addSubview(self.indicatorView)
        indicatorView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}
