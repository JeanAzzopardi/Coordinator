//
//  ProductViewController.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 17.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import UIKit

final class ProductViewController: UIViewController, StoryboardLoadable {

	//	UI Outlets

	@IBOutlet fileprivate weak var mainPhotoView: UIImageView!
	@IBOutlet fileprivate weak var titleLabel: UILabel!
	@IBOutlet fileprivate weak var cartBarItem: BadgeUIBarButtonItem!

	//	Local data model

	var product: Product? {
		didSet {
			if !self.isViewLoaded { return }
			self.populate()
		}
	}

	var color: Color?

	var numberOfCartItems: Int? {
		didSet {
			if !self.isViewLoaded { return }
			renderCartStatus()
		}
	}
}


extension ProductViewController {
	//	MARK: Actions

	@IBAction func cartTapped(_ sender: UIBarButtonItem) {
		cartToggle(sender: self)
	}

	@IBAction func addTapped(_ sender: UIButton) {
		guard let product = product, let color = color else { return }
		cartAdd(product: product, color: color.boxed, sender: sender) {
			[weak self] _, num in
			guard let `self` = self else { return }
			self.numberOfCartItems = num
		}
	}

	//	MARK: View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		populate()
		renderCartStatus()

		//	HACK: setup default color
		color = Color.c18
	}
}


fileprivate extension ProductViewController {
	func populate() {
		guard let product = product else { return }

		titleLabel.text = product.name

		if let path = product.imagePaths.first {
			mainPhotoView.image = UIImage(named: path)
		}
	}

	func renderCartStatus() {
		guard let numberOfCartItems = numberOfCartItems, numberOfCartItems > 0 else {
			self.cartBarItem.removeBadge()
			return
		}
		self.cartBarItem.addBadge(number: numberOfCartItems)
	}
}
