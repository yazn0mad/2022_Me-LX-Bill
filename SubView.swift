//
//  SubView.swift
//  Me LX Bill
//
//  Created by Yazz Tanaka on 31/12/2022.
//

import SwiftUI

struct Subview: View {
    var imageTitle: String
    var body: some View {
        Image(imageTitle)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipped()
    }
}

struct Subview_Previews: PreviewProvider {
    static var previews: some View {
        Subview(imageTitle: "welcome")
    }
}

