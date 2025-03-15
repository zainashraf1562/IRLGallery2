//
//  IRLFeedCellViewModel.swift
//  IRLGallery
//
//  Created by Zain Ashraf on 6/22/24.
//

import Foundation

@Observable
class IRLFeedCellViewModel{
    let post:PostModel
    var profileURL: URL?
    init(post: PostModel) {
        self.post = post
        print(post.imageURL)
        Task{
            await getProfileImageURL()
        }
    }
    func getProfileImageURL() async{
        do {
            profileURL = try await StorageManager.base.getURL(for:"messageImages/\(post.email)")
        } catch{
            print(error.localizedDescription)
        }
    }
}
