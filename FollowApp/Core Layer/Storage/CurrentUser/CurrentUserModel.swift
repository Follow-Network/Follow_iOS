//
//  UserModel.swift
//  FollowApp
//
//  Created by Anton Grigorev on 24.11.2018.
//  Copyright © 2018 Follow. All rights reserved.
//

import Foundation

struct CurrentUserModel {
    let name: String
    let username: String
    let phone: String
    let email: String
    let country: String
    let imageUrl: String
    let birthday: String
    let regdate: String
    let address: String
    
    static func fromCoreData(crModel: CurrentUser) -> CurrentUserModel {
        let model = CurrentUserModel(name: crModel.name ?? "",
                                     username: crModel.username ?? "",
                                     phone: crModel.phone ?? "",
                                     email: crModel.email ?? "",
                                     country: crModel.country ?? "",
                                     imageUrl: crModel.imageUrl ?? "",
                                     birthday: crModel.birthday ?? "",
                                     regdate: crModel.regdate ?? "",
                                     address: crModel.address ?? "")
        return model
    }
}

extension CurrentUserModel: Equatable {
    static func ==(lhs: CurrentUserModel, rhs: CurrentUserModel) -> Bool {
        return lhs.address == rhs.address
    }
}
