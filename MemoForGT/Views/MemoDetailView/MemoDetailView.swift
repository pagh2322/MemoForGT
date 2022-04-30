//
//  MemoDetailView.swift
//  MemoForGT
//
//  Created by peo on 2022/04/30.
//

import SwiftUI

struct MemoDetailView: View {
    @EnvironmentObject var allData: AllData
    @State var isEditingMemo = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var memo: Memo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("메모 내용")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 15)
            Text(self.memo.content)
                .padding(.top, 5)
            
            Spacer()
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                self.allData.deleteMemo(index: self.allData.memoList.firstIndex(of: self.memo)!)
            }) {
                Text("삭제")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(.red)
                    .cornerRadius(10)
                    .shadow(radius: 4)
            }
        }
        .padding(.horizontal, 25)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    self.isEditingMemo = true
                }) {
                    Image(systemName: "square.and.pencil")
                }
                .sheet(isPresented: self.$isEditingMemo) {
                    EditMemoView(isEditingMemo: self.$isEditingMemo, memo: self.memo, password: self.memo.password ?? "")
                }
            }
        }
    }
}
