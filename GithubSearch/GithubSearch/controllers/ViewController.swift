

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
    
    private var users: [User] = []
    
    
    private var newUsers: [newUser] = []
    
    
    private var fetchingMore = false
    
    private var lastID = 0
    
    private let searchBar = UISearchBar().then {
        $0.placeholder = "Please enter text..."
    }
    private let debouncer = Debouncer(timeInterval: 0.5)

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.initTableView()
//        self.initData()
        
        
        searchBar.delegate = self
        
    }
    
}


extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        

        debouncer.renewInterval()

        
               debouncer.handler = {
                   // Send the debounced network request here
                   print("Send network request")
                
                API.searchUsers(searchText, 1).responseData { (response) in
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
                                                self.newUsers.append(newUser(profileImageURL: profileURL,
                                                                        reposNumber: reposNumber,
                                                                        userName: userName))
                                                self.tableView.reloadData()
                                                self.fetchingMore = false

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

               func textDidChangeDelegateMethod() {
                   // When the user performs a repeating action, such as entering text, invoke the `renewInterval` method
               }
        

        
        self.newUsers = []

        
        

    }
}


extension ViewController {
    
    
    private func initData(){
        
       
        
        
        
//
//        let debouncedFunction = Debouncer(delay: 0.50) {
//            print("delayed printing")
//
//
//            API.allUsers(self.lastID).responseData { response in
//                switch response.result{
//                case .success(let data):
//                    do{
//                        let json = try JSON(data: data)
//                        _ = json.map { str, json in
//                            self.users.append(User(profileImageURL: json["avatar_url"].string,
//                                                   userID: json["id"].int,
//                                                   userName: json["login"].string))
//                            self.lastID = json["id"].int ?? 0
//                            self.tableView.reloadData()
//                            self.fetchingMore = false
//                        }
//                    }catch{
//                        print(error.localizedDescription)
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        }
        
        
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
        self.tableView.rowHeight = 110
        self.tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseIdentifier)
    }
    
    
    
 
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseIdentifier, for: indexPath) as! UserCell
        cell.bind(model: self.newUsers[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "data count : \(newUsers.count)..."
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        tableView.deselectRow(at: indexPath, animated: true)
        //        let vc = DetailViewController()
        //        vc.selectedUserName = users[indexPath.row].userName
        //        navigationController?.pushViewController(vc, animated: true)
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
        tableView.reloadSections(IndexSet(integer: 0), with: .bottom)
        DispatchQueue.main.async {
            self.initData()
        }
    }
    
}








