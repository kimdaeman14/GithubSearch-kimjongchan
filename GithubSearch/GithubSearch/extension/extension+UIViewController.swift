//
//  extension+UIViewController.swift
//  GithubSearch
//
//  Created by Jaycee on 2020/01/21.
//  Copyright © 2020 Jaycee. All rights reserved.
//

import UIKit

extension UIViewController {
    var statusbarHeight: CGFloat {
        return UIApplication.shared.windows[0].windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
    }
    
    var navibarHeight: CGFloat {
        return self.navigationController?.navigationBar.frame.height ?? 0.0
    }
    
    var topbarHeight: CGFloat {
        let statusbarHeight = UIApplication.shared.windows[0].windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
        let navibarHeight = self.navigationController?.navigationBar.frame.height ?? 0.0
        return (statusbarHeight + navibarHeight)
    }
}
