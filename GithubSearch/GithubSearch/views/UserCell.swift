

import UIKit
import SnapKit
import Kingfisher
import Then

class UserCell: UITableViewCell {
    
    static let reuseIdentifier = "UserCell"
    
    let baseView = UIView().then {
        $0.layer.borderWidth = 2.0
        $0.layer.borderColor = UIColor.black.cgColor
    }
    
    let userProfileImage = UIImageView()
    
    var userID = UILabel().then {
        $0.font = .systemFont(ofSize: 20)
        $0.textColor = .black
    }
    
    var userName = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .black
    }
    
    var reposNumber = UILabel().then {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .lightGray
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func bind(model:User){
        self.userProfileImage.kf.setImage(with: URL(string: model.profileImageURL ?? ""))
        self.reposNumber.text = "Number of repos : \(model.reposNumber ?? 0)"
        self.userName.text = model.userName
    }
}


extension UserCell {
    func setupUI(){

        self.addSubview(self.baseView)
        [userProfileImage, reposNumber, userName].forEach { self.baseView.addSubview($0) }
    
        baseView.snp.makeConstraints { make in
            make.top.equalTo(5)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-5)
        }
        
        userProfileImage.snp.makeConstraints { make in
            make.top.left.bottom.equalTo(0)
            make.size.equalTo(100)
        }

        userName.snp.makeConstraints { make in
            make.left.equalTo(self.userProfileImage.snp.right).offset(15)
            make.right.equalTo(self.baseView.snp.right).offset(-15)
            make.centerY.equalToSuperview().offset(-15)
        }
        
        reposNumber.snp.makeConstraints { make in
            make.left.equalTo(self.userProfileImage.snp.right).offset(15)
            make.right.equalTo(self.baseView.snp.right).offset(-15)
            make.centerY.equalToSuperview().offset(15)
        }
    }
}
