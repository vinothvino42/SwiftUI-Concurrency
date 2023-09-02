//
//  09.GlobalActorView.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Vinoth Vino on 02/09/23.
//

import SwiftUI

@globalActor struct MyFirstGlobalActor {
    static var shared = GlobalDataManager()
}

actor GlobalDataManager {
    func getDataFromDatabase() -> [String] {
        return ["One", "Two", "Three", "Four", "Five"]
    }
}

//@MainActor - Commented because of our custom GlobalActor (MyFirstGlobalActor)
class GlobalActorViewModel: ObservableObject {
    @Published var dataArray: [String] = []
    let manager = MyFirstGlobalActor.shared
    
    @MyFirstGlobalActor func getData() async {
        let data = await manager.getDataFromDatabase()
        self.dataArray = data
    }
}

struct GlobalActorView: View {
    @StateObject private var viewModel = GlobalActorViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModel.getData()
        }
    }
}

struct GlobalActorView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalActorView()
    }
}
