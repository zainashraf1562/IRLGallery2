//
//  CommentCellViewModel.swift
//  IRLGallery
//
//  Created by Zain Ashraf on 8/4/24.
//

import Foundation

@Observable
class CommentCellViewModel{
    let comment: CommentModel
    var profileURL: URL?
    init(comment: CommentModel) {
        self.comment = comment
        Task{
            await getProfileImageURL()
        }
    }
    func getProfileImageURL() async{
        do {
            profileURL = try await StorageManager.base.getURL(for:"messageImages/\(comment.email)")
        } catch{
            print(error.localizedDescription)
        }
    }
}
