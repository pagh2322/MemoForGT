//
//  EditMemoView.swift
//  MemoForGT
//
//  Created by peo on 2022/05/01.
//

import SwiftUI

struct EditMemoView: View {
    @EnvironmentObject var allData: AllData
    @Binding var isEditingMemo: Bool
    @State var isSecret = false
    @State var memoContent = ""
    @State var numberOfContentTexts = 0
    @State var passwordTextFieldHeight: CGFloat = 0
    @State var passwordTextFieldOpacity: Double = 0
    @State var isVisible = false
    @State var isSecretDivier = false
    var isAbleToAdd: Bool {
        get {
            if self.isSecret {
                return !self.password.isEmpty && !self.memoContent.isEmpty
            } else {
                return !self.memoContent.isEmpty
            }
        }
    }
    var memo: Memo
    @State var password: String
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                Toggle(isOn: self.$isSecret) {
                    Text("비밀 메모로 설정")
                        .bold()
                }
                .onChange(of: self.isSecret) { _ in
                    withAnimation {
                        self.passwordTextFieldHeight = self.isSecret ? 44 : 0
                        self.passwordTextFieldOpacity = self.isSecret ? 1 : 0
                        self.isSecretDivier = self.isSecret
                    }
                }
                Divider()
                    .padding(.top, 25)
                    .padding(.bottom, 15)
                
                HStack {
                    Text("비밀번호")
                        .bold()
                        .opacity(self.passwordTextFieldOpacity)
                        .frame(height: self.passwordTextFieldHeight)
                    
                    if self.isVisible {
                        TextField("", text: self.$password)
                            .opacity(self.passwordTextFieldOpacity)
                            .frame(height: self.passwordTextFieldHeight)
                            .padding(.leading, 15)
                    } else {
                        SecureField("", text: self.$password)
                            .opacity(self.passwordTextFieldOpacity)
                            .frame(height: self.passwordTextFieldHeight)
                            .padding(.leading, 15)
                    }
                    
                    Image(systemName: self.isVisible ? "eye.slash.fill" : "eye.fill")
                        .opacity(self.isSecret ? 1 : 0)
                        .onTapGesture {
                            self.isVisible.toggle()
                        }
                }
                
                if self.isSecret {
                    Divider()
                        .padding(.vertical, 15)
                        .padding(.bottom, 10)
                }
                
                Text("메모 내용")
                    .bold()
                
                TextEditor(text: self.$memoContent)
                    .frame(maxHeight: 250)
                    .onChange(of: memoContent) { _ in
                        self.numberOfContentTexts = self.memoContent.count
                    }
                
                HStack {
                    Spacer()
                    Text("\(self.numberOfContentTexts)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding([.horizontal, .top], 25)
            .navigationTitle("메모 변경")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        self.isEditingMemo = false
                    }) {
                        Text("취소")
                            .bold()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        self.isEditingMemo = false
                        self.allData.editMemo(Memo(id: self.allData.memoListCount, content: self.memoContent, isSecret: self.isSecret, password: self.isSecret ? self.password : nil), id: self.memo.id)
                    }) {
                        Text("완료")
                            .bold()
                    }
                    .foregroundColor(self.isAbleToAdd ? .accentColor : .secondary)
                }
            }
            .onAppear {
                self.isSecret = self.memo.isSecret
                self.memoContent = self.memo.content
                self.numberOfContentTexts = self.memoContent.count
                self.passwordTextFieldHeight = self.isSecret ? 44 : 0
                self.passwordTextFieldOpacity = self.isSecret ? 1 : 0
                self.isSecretDivier = self.isSecret
            }
        }
    }
}
