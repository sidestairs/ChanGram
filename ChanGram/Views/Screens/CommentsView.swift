//
//  CommentsView.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import SwiftUI

struct CommentsView: View {
   
    @Environment(\.colorScheme) var colorScheme
    @State var submissionText: String = ""
    @State var commentArray = [CommentModel]()
    
    var post: PostModel
    
    @State var profilePicture: UIImage = UIImage(named: "logo.loading")!
    
    @AppStorage(CurrentUserDefaults.userId) var currentUserId: String?
    @AppStorage(CurrentUserDefaults.displayName) var currentUserDisplayName: String?
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(commentArray, id: \.self) { comment in
                        MessageView(comment: comment)
                    }
                }
            }
            
            HStack {
                Image(uiImage: profilePicture)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
                
                TextField("Add a comment here...", text: $submissionText)
                
                Button {
                    if textIsAppropriate() {
                        addComment()
                    }
                } label: {
                    Image(systemName: "paperplane.fill").font(.title2)
                }
                .accentColor(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
            }
            .padding(.all, 6)
        }
        .padding()
        .navigationBarTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            getComments()
            getProfilePicture()
        }
    }
    
    // MARK: FUNCTION
    
    func getProfilePicture() {
        
        guard let userId = currentUserId else { return }
        
        ImageManager.instance.downloadProfileImage(userId: userId) { (returnedImage) in
            if let image = returnedImage {
                self.profilePicture = image
            }
        }
    }
    
    func getComments() {
        guard self.commentArray.isEmpty else { return }
        print("GET COMMENTS FROM DATABASE")
        
        if let caption = post.caption, caption.count > 1 {
            let captionComment = CommentModel(commentId: "", userId: post.userId, username: post.username, content: caption, dateCreated: post.dateCreated)
            self.commentArray.append(captionComment)
        }

        DataService.instance.downloadComments(postId: post.postId) { (returnedComments) in
            self.commentArray.append(contentsOf: returnedComments)
        }
    }
    
    func textIsAppropriate() -> Bool {
        // Check if the text has curses
        // Check if the text is long enough
        // Check if the text is blank
        // Check for innapropriate things
        
        
        // Checking for bad words
        let badWordArray: [String] = ["shit", "ass"]

        let words = submissionText.components(separatedBy: " ")

        for word in words {
            if badWordArray.contains(word) {
                return false
            }
        }
        
        // Checking for minimum character count
        if submissionText.count < 3 {
            return false
        }
        
        return true
    }
    
    func addComment() {
        
        guard let userId = currentUserId, let displayName = currentUserDisplayName else { return }
        
        DataService.instance.uploadComment(postId: post.postId, content: submissionText, displayName: displayName, userId: userId) { (success, returnedCommentId) in
            if success, let commentId = returnedCommentId {
                let newComment = CommentModel(commentId: commentId, userId: userId, username: displayName, content: submissionText, dateCreated: Date())
                self.commentArray.append(newComment)
                self.submissionText = ""
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
        
    }
}

struct CommentsView_Previews: PreviewProvider {
    
    static let post = PostModel(postId: "asdf", userId: "asdf", username: "asdf", dateCreated: Date(), likeCount: 0, likedByUser: false)
    
    static var previews: some View {
        NavigationView {
            CommentsView(post: post)
        }        
    }
}
