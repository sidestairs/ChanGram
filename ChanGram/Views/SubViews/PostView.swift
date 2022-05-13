//
//  PostView.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import SwiftUI

struct PostView: View {
    
    @State var post:PostModel
    var showHeaderAndFooter: Bool
    
    @State var animateLike:Bool = false
    @State var addHeartAnimationToView:Bool
    
    @State var showActionSheet:Bool = false
    @State var actionSheetType:PostActionSheetOption = .general
    
    @State var profileImage:UIImage = UIImage(named: "logo.loading")!
    @State var postImage:UIImage = UIImage(named: "logo.loading")!
    
    @AppStorage(CurrentUserDefaults.userId) var currentUserId: String?
    
    // Alerts
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    @State var showAlert: Bool = false
    
    enum PostActionSheetOption {
        case general
        case reporting
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            // MARK: HEADER
            if (showHeaderAndFooter) {
                HStack {
                    
                    NavigationLink(
                        destination: LazyView(content: {
                            ProfileView(isMyProfile: false,
                                        profileDisplayName: post.username,
                                        profileUserId: post.userId,
                                        posts: PostArrayObject(userId: post.userId))
                        })
                    ) {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30, alignment: .center)
                            .cornerRadius(15)
                        
                        Text(post.username)
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    Button {
                        showActionSheet.toggle()
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.headline)
                    }
                    .accentColor(.primary)
                    .actionSheet(isPresented: $showActionSheet) {
                        getActionSheet()
                    }
                }
                .padding(.all, 6)
            }
            
            // MARK: IMAGE
            
            ZStack {
                Image(uiImage: postImage)
                    .resizable()
                    .scaledToFit()
                    .onTapGesture(count: 2) {
                        if !post.likedByUser {
                            likePost()
                            // AnalyticsService.instance.likePostDoubleTap()
                        }
                    }
                
                if (addHeartAnimationToView) {
                    LikeAnimationView(animate: $animateLike)
                }
                
            }
            
            // MARK: FOOTER
            
            if (showHeaderAndFooter) {
                HStack(alignment: .center, spacing: 20) {
                    
                    Button {
                        if post.likedByUser {
                            // unlike the post
                            unlikePost()
                        } else {
                            // like the post
                            likePost()
                        }
                    } label: {
                        Image(systemName: post.likedByUser ? "heart.fill" : "heart")
                            .font(.title3)
                    }
                    .accentColor(post.likedByUser ? .red : .primary)
                    
                    
                    // MARK: Comment Icon
                    NavigationLink(destination: CommentsView(post: post)) {
                        Image(systemName: "bubble.middle.bottom")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                    
                    Button {
                        sharePost()
                    } label: {
                        Image(systemName: "paperplane")
                            .font(.title3)
                    }
                    .accentColor(.primary)
                    
                    Spacer()
                }
                .padding(.all, 6)
                
                if let caption = post.caption {
                    HStack {
                        Text(caption)
                        Spacer(minLength: 0)
                    }.padding(.all, 6)
                }
            }
            
        }
        .onAppear {
            getImages()
        }
        .alert(isPresented: $showAlert) { () -> Alert in
            return Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // MARK: FUNCTION
    
    func likePost() {
        
        guard let userId = currentUserId else {
            print("Cannot find userID while liking post")
            return
        }
        
        print("likePost")
        
        let updatedPost = PostModel(postId: post.postId,
                                    userId: post.userId, username: post.username,
                                    caption: post.caption, dateCreated: post.dateCreated,
                                    likeCount: post.likeCount+1, likedByUser: true)
        
        self.post = updatedPost
        
        // Animate UI
        animateLike = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            animateLike = false
        }
        
        // Update the database
        DataService.instance.likePost(postId: post.postId, currentUserId: userId)
    }
    
    func unlikePost() {
        
        guard let userId = currentUserId else {
            print("Cannot find userID while unliking post")
            return
        }
        
        print("unlikePost")
        
        let updatedPost = PostModel(postId: post.postId,
                                    userId: post.userId, username: post.username,
                                    caption: post.caption, dateCreated: post.dateCreated,
                                    likeCount: post.likeCount-1, likedByUser: false)
        self.post = updatedPost
        
        // Update the database
        DataService.instance.unlikePost(postId: post.postId, currentUserId: userId)
    }
    
    func getImages() {
        
        // Get profile image
        ImageManager.instance.downloadProfileImage(userId: post.userId) { returnedImage in
            if let image = returnedImage {
                self.profileImage = image
            }
        }
        
        // Get post image
        ImageManager.instance.downloadPostImage(postId: post.postId) { returnedPostImage in
            if let postImage = returnedPostImage {
                self.postImage = postImage
            }
        }
    }
    
    func getActionSheet() -> ActionSheet {
        
        switch self.actionSheetType {
        case .general:
            return ActionSheet(title: Text("What would you like to do?"), message: nil, buttons: [
                .destructive(Text("Report"), action: {
                    self.actionSheetType = .reporting
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.showActionSheet.toggle()
                    }
                }),
                .destructive(Text("Learn More"), action: {
                    print("learn more")
                }),
                .cancel()])
            
        case .reporting:
            return ActionSheet(title: Text("Why are you reporting this post??"), message: nil, buttons: [
                .destructive(Text("This is inappropriate"), action: {
                    reportPost(reason: "This is inappropriate")
                }),
                .destructive(Text("This is spam"), action: {
                    reportPost(reason: "This is spam")
                }),
                .destructive(Text("This makes me uncomfortable"), action: {
                    reportPost(reason: "This makes me uncomfortable")
                }),
                .cancel({
                    self.actionSheetType = .general
                })])
        }
    }
    
    func reportPost(reason:String) {
        print("REPORT POST NOW")
        
        DataService.instance.uploadReport(reason: reason, postId: post.postId) { (success) in
            if success {
                self.alertTitle = "Reported!"
                self.alertMessage = "Thanks for reporting this post. We wil review it shortly and take the appropriate action!"
                self.showAlert.toggle()
            } else {
                self.alertTitle = "Error"
                self.alertMessage = "There was an error uploading the report. Please restart the app and try again."
                self.showAlert.toggle()
            }
        }
    }
    
    func sharePost() {
        let message = "Check out this post on DogGram!"
        let image = postImage
        let link = URL(string: "https://www.google.com")!
        
        let activityViewController = UIActivityViewController(activityItems: [message, image, link], applicationActivities: nil)
        
        let viewController = UIApplication.shared.windows.first?.rootViewController
        viewController?.present(activityViewController, animated: true, completion: nil)
    }
}

struct PostView_Previews: PreviewProvider {
    static var post:PostModel = PostModel(postId: "", userId: "", username: "Paul Smith", caption: "This is a test caption", dateCreated: Date(), likeCount: 0, likedByUser: false)
    
    static var previews: some View {
        PostView(post:post, showHeaderAndFooter: true, addHeartAnimationToView: true)
            .previewLayout(.sizeThatFits)
    }
}
