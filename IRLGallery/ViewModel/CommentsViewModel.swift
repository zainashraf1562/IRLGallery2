//
//  CommentsViewModel.swift
//  IRLGallery
//
//  Created by Zain Ashraf on 7/14/24.
//

import Foundation

@Observable
class CommentsViewModel{
    var comments: [CommentModel] = []
    let postId: UUID
    let user:UserModel
    var newCommentText: String = ""
    var isLiked: Bool = false
    var likeCount: Int = 0
    init(user: UserModel, postId: UUID) {
        self.postId = postId
        self.user=user
        Task {
              await loadComments()
              await checkLikeStatus()
        }
    }
    func loadComments() async{
        Task{
            do{
                self.comments = try await DatabaseManager.base.getComments(fromPostWithID: postId)
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func addComment(){
        Task{
            do{
                try await DatabaseManager.base.addComment(toPostWithID: postId, comment: CommentModel(username: user.userName, email: user.email, date: Date(), text: newCommentText))
                newCommentText = ""
                await loadComments()
            } catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func toggleLike() async{
        do{
            if isLiked {
                try await DatabaseManager.base.unlikePost(postID: postId, userEmail: user.email)
                isLiked = false
                likeCount -= 1 // Update likeCount if necessary
            } else {
                try await DatabaseManager.base.likePost(postID: postId, userEmail: user.email)
                isLiked = true
                likeCount += 1 // Update likeCount if necessary
            }
        } catch{
            print(error.localizedDescription)
        }
    }
    
    func checkLikeStatus() async{
        do {
            isLiked = try await DatabaseManager.base.hasUserLikedPost(postID: postId, userEmail: user.email)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getLikeCount() async {
      do {
        likeCount = try await DatabaseManager.base.countLikes(postID: postId)
      } catch {
        print(error.localizedDescription)
      }
    }
}
