//
//  11.AsyncPublisherView.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Vinoth Vino on 02/09/23.
//

import SwiftUI

actor AsyncPublisherDataManager {
    @Published var myData: [String] = []
    
    func addData() async {
        myData.append("Apple")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Banana")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Orange")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Watermelon")
    }
}

class AsyncPublisherViewModel: ObservableObject {
    @Published var dataArray: [String] = []
    let manager = AsyncPublisherDataManager()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        Task {
            for await value in await manager.$myData.values {
                await MainActor.run(body: {
                    self.dataArray = value
                })
            }
        }
    }
    
    func start() async {
        await manager.addData()
    }
}

struct AsyncPublisherView: View {
    @StateObject private var viewModel = AsyncPublisherViewModel()
    
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
            await viewModel.start()
        }
    }
}

struct AsyncPublisherView_Previews: PreviewProvider {
    static var previews: some View {
        AsyncPublisherView()
    }
}
