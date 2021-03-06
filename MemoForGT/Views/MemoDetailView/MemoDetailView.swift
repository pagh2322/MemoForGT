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
    @State var isDeleting = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("메모 내용")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 15)
            Text(self.allData.currentMemo.content)
                .padding(.top, 15)
            
            Spacer()
            
            Button(action: {
                self.isDeleting = true
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
            .alert(isPresented: self.$isDeleting) {
                Alert(title: Text("해당 메모를 삭제할까요?"),
                      message: nil,
                      primaryButton: .destructive(
                        Text("삭제"), action: {
                        presentationMode.wrappedValue.dismiss()
                        self.allData.deleteMemo(index: self.allData.memoList.firstIndex(of: self.allData.currentMemo)!)
                        }),
                      secondaryButton: .cancel(Text("취소"))
                )
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
                    EditMemoView(isEditingMemo: self.$isEditingMemo, memo: self.allData.currentMemo, password: self.allData.currentMemo.password ?? "")
                }
            }
        }
    }
}
