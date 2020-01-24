//
//  Debouncer.swift
//  GithubSearch
//
//  Created by Jaycee on 2020/01/24.
//  Copyright © 2020 Jaycee. All rights reserved.
//

import Foundation

class Debouncer {
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }

    typealias Handler = () -> Void

    var handler: Handler?

    private let timeInterval: TimeInterval

    private var timer: Timer?

    func renewInterval() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { [weak self] timer in
            self?.handleTimer(timer)
        })
    }

    private func handleTimer(_ timer: Timer) {
        guard timer.isValid else {
            return
        }
        handler?()
        handler = nil
    }

}
