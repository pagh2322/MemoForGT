//
//  AllData.swift
//  MemoForGT
//
//  Created by peo on 2022/04/30.
//

import Foundation

final class AllData: ObservableObject {
    @Published var memoList: [Memo] = load("memoData.json")
    @Published var memoListCount = (load("memoData.json") as [Memo]).count
    @Published var searchText = "" {
        didSet {
            self.filteredMemoList = memoList.filter { memo in
                return memo.content.contains(self.searchText)
            }
        }
    }
    @Published var filteredMemoList: [Memo] = load("memoData.json")
    
    func addMemo(_ memo: Memo) {
        self.memoList.insert(memo, at: 0)
        self.memoListCount += 1
    }

    func deleteMemo(index: Int) {
        self.memoList.remove(at: index)
    }

    func editMemo(_ memo: Memo, id: Int) {
        var index = 0
        for tempMemo in self.memoList {
            if tempMemo.id == id {
                break
            } else {
                index += 1
            }
        }
        self.memoList.remove(at: index)
        self.memoList.insert(memo, at: 0)
        self.memoListCount += 1
    }
}
