//
//  08.ActorView.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Vinoth Vino on 02/09/23.
//

import SwiftUI

actor Counter {
    var value: Int = 0
    
    func increment() -> Int {
        value += 1
        return value
    }
}

struct ActorView: View {
    var body: some View {
        Button("Increment") {
            let counter = Counter()
            
            DispatchQueue.concurrentPerform(iterations: 100) { _ in
                Task {
                    print(await counter.increment())
                }
            }
        }
    }
}

struct ActorView_Previews: PreviewProvider {
    static var previews: some View {
        ActorView()
    }
}
