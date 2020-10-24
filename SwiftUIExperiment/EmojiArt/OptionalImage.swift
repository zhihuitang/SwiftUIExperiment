//
//  OptinalImage.swift
//  SwiftUIExperiment
//
//  Created by Zhihui Tang on 10/24/20.
//

import SwiftUI


struct OptionalImage: View {
    var uiImage: UIImage?
    
    var body: some View {
        Group {
            if let image = uiImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}


struct OptionalImage_Previews: PreviewProvider {
    static var previews: some View {
        OptionalImage()
    }
}
