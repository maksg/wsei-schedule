//
//  TextFieldRow.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 10/07/2019.
//  Copyright © 2019 Infinity Pi Ltd. All rights reserved.
//

import SwiftUI

struct TextFieldRow : View {
    
    var title: String
    var placeholder: String
    var text: Binding<String>
    
    /// Creates an instance that displays `title` verbatim.
    public init<S>(_ title: S, placeholder: S, text: Binding<String>) where S : StringProtocol {
        self.title = String(title)
        self.placeholder = String(placeholder)
        self.text = text
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            TextField(placeholder, text: text)
                .font(.callout)
        }
    }
}

struct TextFieldRow_Previews : PreviewProvider {
    static var previews: some View {
        TextFieldRow("Title", placeholder: "Placeholder", text: .constant("Text"))
            .previewLayout(.fixed(width: 300, height: 50))
    }
}
