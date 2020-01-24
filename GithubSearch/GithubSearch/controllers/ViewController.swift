

import UIKit
import SnapKit
import Kingfisher
import SwiftyJSON
import Then


class ViewController: UIViewController {
    
    private var didSetupConstraints = false
    
    private let tableView = UITableView().then {
        $0.separatorStyle = .none
    }
    
    private let searchBar = UISearchBar().then {
        $0.placeholder = "Please enter text..."
    }
    
    private var users: [User] = []
    
    private var totalUsers:JSON = JSON(arrayLiteral: "")
    
    private var fetchingMore = false
    
    private let debouncer = Debouncer(timeInterval: 0.5)
    
    private let numberOfDataShowing = 20
    
    private var numberOfPageRequest = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.initTableView()
        self.initSearchBar()
    }
    
}


extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debouncer.renewInterval()
        debouncer.handler = {
            self.requestSearch(searchText)
        }
        self.users = []
        self.numberOfPageRequest = 1
    }
}


extension ViewController {
    
    private func requestSearch(_ searchText:String){
        API.searchUsers(searchText, numberOfPageRequest).responseData { (response) in
            switch response.result{
            case .success(let data):
                do{
                    let json = try JSON(data: data)
                    guard let arr = json["items"].array else {return}
                    _ = arr.map { json in
                        
                        let userName = json["login"].string ?? ""
                        let profileURL = json["avatar_url"].string ?? ""
                        
                        API.detailUserInfos(userName).responseData { (response) in
                            switch response.result{
                            case .success(let data):
                                do{
                                    let json = try JSON(data: data)
                                    let reposNumber = json["public_repos"].int ?? 0
                                    
                                    if(self.users.count < self.numberOfDataShowing){
                                        self.users.append(User(profileImageURL: profileURL,
                                                               reposNumber: reposNumber,
                                                               userName: userName))
                                        self.tableView.reloadData()
                                        self.fetchingMore = false
                                    }else{
                                        self.users.append(User(profileImageURL: profileURL,
                                                               reposNumber: reposNumber,
                                                               userName: userName))
                                        //                                        self.tableView.reloadData()
                                        self.fetchingMore = false
                                    }
                                }catch{
                                    print(error.localizedDescription)
                                }
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    }
                }catch{
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
}

extension ViewController {
    
    private func initUI(){
        //        self.navigationController?.isNavigationBarHidden = true
        [tableView, searchBar].forEach { self.view.addSubview($0) }
        title = "GithubSearch"
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if(!didSetupConstraints){
            
            searchBar.snp.makeConstraints { make in
                make.leading.right.equalTo(0)
                make.top.equalTo(topbarHeight)
            }
            
            tableView.snp.makeConstraints { make in
                make.top.equalTo(self.searchBar.snp.bottom)
                make.leading.right.bottom.equalTo(0)
            }
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    private func initTableView(){
        self.tableView.dataSource = self
        self.tableView.delegate = self
        //        self.tableView.rowHeight = 110
        self.tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseIdentifier)
        self.tableView.register(LoadingCell.self, forCellReuseIdentifier: LoadingCell.reuseIdentifier)
        
    }
    
    private func initSearchBar(){
        self.searchBar.delegate = self
    }
}



extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return users.count
        
        if section == 0 {
            return users.count
        }else if section == 1 && fetchingMore {
            return 1
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseIdentifier, for: indexPath) as! UserCell
            guard self.users.count != 0 else {return cell}
            cell.bind(model: self.users[indexPath.row])
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.reuseIdentifier, for: indexPath) as! LoadingCell
            if(self.users.count == 0){
                cell.indicatorView.isHidden = true
            }else{
                cell.indicatorView.startAnimating()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "data count : \(users.count)..."
        }else{
            return ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 110
        }else{
            return 80
        }
    }
}

extension ViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height * 2 {
            if !fetchingMore {
                beginBatchFetch()
            }
        }
    }
    
    private func beginBatchFetch() {
        fetchingMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.numberOfPageRequest += 1
            self.requestSearch(self.searchBar.text ?? "")
            self.tableView.reloadData()
            self.fetchingMore = false
        })
    }
    
}








