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
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                LazyVGrid(columns: self.colums) {
                    ForEach(self.allData.memoList) { memo in
                        NavigationLink(destination: MemoDetailView(memo: memo)) {
                            SummaryMemo(memo: memo)
                        }
                        .foregroundColor(.primary)
                        .padding(.bottom, 5)
                    }
                }
                .padding(.horizontal, 25)
                .padding(.top, 10)
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: self.$allData.searchText) {
                    ForEach(self.allData.filteredMemoList) { memo in
                        Text(memo.content)
                            .lineLimit(1)
                            .foregroundColor(.primary)
                    }
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
        }
    }
}
