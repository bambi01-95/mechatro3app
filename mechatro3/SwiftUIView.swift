//
//  SwiftUIView.swift
//  mechatro3
//
//  Created by Hiroto SHIKADA on 2023/07/24.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        WebView(loardUrl: URL(string: "https://ja.wikipedia.org/wiki/%E9%AD%9A%E9%A1%9E")!)
        
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
