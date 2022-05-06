//
//  CommentsView.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import SwiftUI

struct CommentsView: View {
    
    @State var submissionText:String = ""
    @State var commentArray = [CommentModel]()
    
    
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
                Image("dog1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40, alignment: .center)
                    .cornerRadius(20)
                
                TextField("Add a comment here...", text: $submissionText)
                
                Button {
                    
                    
                } label: {
                    Image(systemName: "paperplane.fill").font(.title2)
                }
                .accentColor(Color.MyTheme.purpleColor)
            }
            .padding(.all, 6)
        }
        .navigationBarTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            getComments()
        }
    }
    
    // MARK: FUNCTION
    
    func getComments() {
        print("Get comment from database")
        let comment1 = CommentModel(commentId: "", userId: "", username: "Joe Green", content: "This is first comment", dateCreated: Date())
        let comment2 = CommentModel(commentId: "", userId: "", username: "Johnson Duck", content: "This is second comment", dateCreated: Date())
        let comment3 = CommentModel(commentId: "", userId: "", username: "Alex Tan", content: "This is third comment", dateCreated: Date())
        
        commentArray.append(comment1)
        commentArray.append(comment2)
        commentArray.append(comment3)
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CommentsView()
        }        
    }
}
