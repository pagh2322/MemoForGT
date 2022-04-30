//
//  AddMemoView.swift
//  MemoForGT
//
//  Created by peo on 2022/04/30.
//

import SwiftUI

struct AddMemoView: View {
    @EnvironmentObject var allData: AllData
    @Binding var isAddingMemo: Bool
    @State var isSecret = false
    @State var memoContent = ""
    @State var numberOfContentTexts = 0
    @State var password = ""
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
                    
                    Image(systemName: self.isVisible ? "eye.fill.slash" : "eye.fill")
                        .opacity(self.isSecret ? 1 : 0)
                        .onTapGesture {
                            self.isVisible.toggle()
                        }
                }
                
                if self.isSecretDivier {
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
            .navigationTitle("새 메모 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        self.isAddingMemo = false
                    }) {
                        Text("취소")
                            .bold()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        self.isAddingMemo = false
                        self.allData.addMemo(Memo(id: self.allData.memoListCount, content: self.memoContent, isSecret: self.isSecret, password: self.password.isEmpty ? nil : self.password))
                    }) {
                        Text("완료")
                            .bold()
                    }
                    .foregroundColor(self.isAbleToAdd ? .accentColor : .secondary)
                }
            }
        }
    }
}
