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
    @State var postImage:UIImage = UIImage(named: "dog1")!
    
    @State var animateLike:Bool = false
    @State var addHeartAnimationToView:Bool
    
    @State var showActionSheet:Bool = false
    @State var actionSheetType:PostActionSheetOption = .general
    
    enum PostActionSheetOption {
        case general
        case reporting
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            // MARK: HEADER
            if (showHeaderAndFooter) {
                HStack {
                    
                    NavigationLink(destination: ProfileView(isMyProfile: false, profileDisplayName: post.username, profileUserId: post.userId)) {
                        Image("dog1")
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
                
                if (addHeartAnimationToView) {
                    LikeAnimationView(animate: $animateLike)
                }
                
            }
            
            
            if (showHeaderAndFooter) {
                //MARK: FOOTER
                HStack(alignment: .center, spacing: 20) {
                    
                    Button {
                        if post.likedByUser {
                            // unlike the post
                            unlikedPost()
                        } else {
                            // like the post
                            likedPost()
                        }
                    } label: {
                        Image(systemName: post.likedByUser ? "heart.fill" : "heart")
                            .font(.title3)
                    }
                    .accentColor(post.likedByUser ? .red : .primary)
                    
                    
                    // MARK: Comment Icon
                    NavigationLink(destination: CommentsView()) {
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
    }
    
    // MARK: FUNCTION
    
    func likedPost() {
        let updatedPost = PostModel(postId: post.postId,
                                    userId: post.userId, username: post.username,
                                    caption: post.caption, dateCreated: post.dateCreated,
                                    likeCount: post.likeCount+1, likedByUser: true)
        
        self.post = updatedPost
        animateLike = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            animateLike = false
        }
    }
    
    func unlikedPost() {
        let updatedPost = PostModel(postId: post.postId,
                                    userId: post.userId, username: post.username,
                                    caption: post.caption, dateCreated: post.dateCreated,
                                    likeCount: post.likeCount-1, likedByUser: false)
        self.post = updatedPost
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
        print(reason)
    }
    
    func sharePost() {
//        let message = "Check out this post!"
//        let image = postImage
//        let link = URL(string: "http://google.com")!
//
//        let activityViewController = UIActivityViewController(activityItems: [
//            message,image,link
//        ], applicationActivities: nil)
//
//        let viewController = UIWindowScene.windows.first?.rootViewController
//        viewController?.present(activityViewController, animated: true, completion: nil)
    }
}

struct PostView_Previews: PreviewProvider {
    static var post:PostModel = PostModel(postId: "", userId: "", username: "Paul Smith", caption: "This is a test caption", dateCreated: Date(), likeCount: 0, likedByUser: false)
    
    static var previews: some View {
        PostView(post:post, showHeaderAndFooter: true, addHeartAnimationToView: true)
            .previewLayout(.sizeThatFits)
    }
}
