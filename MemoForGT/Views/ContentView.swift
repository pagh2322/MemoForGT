//
//  ContentView.swift
//  MemoForGT
//
//  Created by peo on 2022/04/30.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var allData: AllData
    @State var isAddingMemo = false
    let colums = [GridItem(.flexible())]
    @State var isDeleteAll = false
    @State var goToDetail = false
    @State var selectedMemo = Memo(id: -1, content: "")
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVGrid(columns: self.colums) {
                        ForEach(self.allData.memoList) { memo in
                            Button(action: {
                                if memo.isSecret {
                                    
                                } else {
                                    self.allData.currentMemo = memo
                                    self.goToDetail = true
                                    
                                }
                            }) {
                                SummaryMemo(memo: memo)
                            }
                            .foregroundColor(.primary)
                            .padding(.bottom, 5)
                        }
                    }
                    .background(NavigationLink(destination: MemoDetailView(), isActive: self.$goToDetail) { EmptyView()
                    })
                    .padding(.horizontal, 25)
                    .padding(.top, 10)
                    .navigationBarTitleDisplayMode(.inline)
                    .searchable(text: self.$allData.searchText, prompt: "메모 내용을 검색하세요") {
                        ForEach(self.allData.filteredMemoList) { memo in
                            Button(action: {     
                                self.allData.currentMemo = memo
                                self.goToDetail = true
                            }) {
                                Text(memo.content)
                                    .lineLimit(1)
                            }
                            .foregroundColor(.primary)
                        }
                        .background(NavigationLink(destination: MemoDetailView(), isActive: self.$goToDetail) { EmptyView()
                        })
                    }
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button(action: {
                                self.isAddingMemo = true
                            }) {
                                Image(systemName: "plus")
                            }
                            .sheet(isPresented: self.$isAddingMemo) {
                                AddMemoView(isAddingMemo: self.$isAddingMemo)
                            }
                        }
                    }
                }
//                Button(action: {
//                    self.isDeleteAll.toggle()
//                }) {
//                    Text("모두 삭제")
//                        .bold()
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .foregroundColor(.white)
//                        .background(.red)
//                        .cornerRadius(10)
//                        .shadow(radius: 4)
//                        .padding(.horizontal, 25)
//                        .padding(.bottom, 5)
//                }
//                .alert(isPresented: self.$isDeleteAll) {
//                    Alert(title: Text("메모를 전부 삭제할까요?"),
//                          message: nil,
//                          primaryButton: .destructive(
//                            Text("삭제"), action: {
//                            self.allData.deleteAll()
//                            }),
//                          secondaryButton: .cancel(Text("취소"))
//                    )
//                }
            }
        }
    }
}
