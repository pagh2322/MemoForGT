//
//  SummaryMemo.swift
//  MemoForGT
//
//  Created by peo on 2022/04/30.
//

import SwiftUI

struct SummaryMemo: View {
    var memo: Memo
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                Text(self.memo.content)
                    .lineLimit(1)
                    .blur(radius: self.memo.isSecret ? 5 : 0)
                Spacer()
            }
            Text(self.memo.isSecret ? "비밀 메모입니다." : "")
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(10)
        .shadow(radius: 4)
    }
}
