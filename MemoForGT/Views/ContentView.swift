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
    @State var isPasswordRight = false
    
    private func alert() {
        let alert = UIAlertController(title: "비밀 메모입니다", message: nil, preferredStyle: .alert)
        alert.addTextField() { textField in
            textField.placeholder = "비밀번호를 입력하세요"
        }
        alert.textFields![0].isSecureTextEntry = true
        alert.addAction(UIAlertAction(title: "취소", style: .cancel) { _ in })
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            if let currentInputPassword = alert.textFields![0].text {
                if self.allData.currentMemo.password == currentInputPassword {
                    self.goToDetail = true
                } else {
                    self.isPasswordRight = true
                }
            }
        })
        showAlert(alert: alert)
    }

    func showAlert(alert: UIAlertController) {
        if let controller = topMostViewController() {
            controller.present(alert, animated: true)
        }
    }

    private func keyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
        .filter {$0.activationState == .foregroundActive}
        .compactMap {$0 as? UIWindowScene}
        .first?.windows.filter {$0.isKeyWindow}.first
    }

    private func topMostViewController() -> UIViewController? {
        guard let rootController = keyWindow()?.rootViewController else {
            return nil
        }
        return topMostViewController(for: rootController)
    }

    private func topMostViewController(for controller: UIViewController) -> UIViewController {
        if let presentedController = controller.presentedViewController {
            return topMostViewController(for: presentedController)
        } else if let navigationController = controller as? UINavigationController {
            guard let topController = navigationController.topViewController else {
                return navigationController
            }
            return topMostViewController(for: topController)
        } else if let tabController = controller as? UITabBarController {
            guard let topController = tabController.selectedViewController else {
                return tabController
            }
            return topMostViewController(for: topController)
        }
        return controller
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVGrid(columns: self.colums) {
                        ForEach(self.allData.memoList) { memo in
                            Button(action: {
                                self.allData.currentMemo = memo
                                if memo.isSecret {
                                    alert()
                                } else {
                                    self.goToDetail = true
                                }
                            }) {
                                SummaryMemo(memo: memo)
                            }
                            .foregroundColor(.primary)
                            .padding(.bottom, 5)
                            .alert(isPresented: self.$isPasswordRight) {
                                Alert(title: Text("비밀번호가 틀렸습니다"),
                                      message: nil,
                                      dismissButton: .default(Text("확인"))
                                )
                            }
                        }
                    }
                    .background(NavigationLink(destination: MemoDetailView(), isActive: self.$goToDetail) { EmptyView()
                    })
                    .padding(.horizontal, 25)
                    .padding(.top, 10)
                    .navigationBarTitleDisplayMode(.inline)
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
                Button(action: {
                    self.isDeleteAll.toggle()
                }) {
                    Text("모두 삭제")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(.red)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                        .padding(.horizontal, 25)
                        .padding(.bottom, 5)
                }
                .alert(isPresented: self.$isDeleteAll) {
                    Alert(title: Text("메모를 전부 삭제할까요?"),
                          message: nil,
                          primaryButton: .destructive(
                            Text("삭제"), action: {
                            self.allData.deleteAll()
                            }),
                          secondaryButton: .cancel(Text("취소"))
                    )
                }
            }
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
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}
