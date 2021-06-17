//
//  BaseViewModel.swift
//  ApartmentManagement
//
//  Created by Pedro Alonso on 2020/9/5.
//  Copyright © 2020 Pedro Alonso. All rights reserved.
//

import Foundation

class BaseViewModel {

    let error: Observable<String> = Observable("")
    let state: Observable<ActionState> = Observable(.none)
    
    func handleError(error: String) {
        self.state.value = ActionState.fail
        self.error.value = error
    }
    
    func handleSuccess() {
        self.state.value = ActionState.success
    }
    
    func handleWaiting() {
        self.state.value = ActionState.waiting
    }
}
