//
//  AppDIContainer.swift
//  FindTown
//
//  Created by 이호영 on 2023/02/27.
//

import UIKit

final class AppDIContainer {
    
    let authUseCase: AuthUseCase
    let memberUseCase: MemberUseCase
    let townUseCase: TownUseCase
    let mapUseCase: MapUseCase
    
    init(networkDIContainer: NetwokDIContainer) {
        self.authUseCase = networkDIContainer.authUseCase()
        self.memberUseCase = networkDIContainer.memberUseCase()
        self.townUseCase = networkDIContainer.townUseCase()
        self.mapUseCase = networkDIContainer.mapUseCase()
    }
}
