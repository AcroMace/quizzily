//
//  LicensesTableViewController.swift
//  Quizzily
//
//  Created by Andy Cho on 2015-03-25.
//  Copyright (c) 2015 Andy Cho. All rights reserved.
//

import UIKit

/**
    List all SDKs and their licenses
*/
class LicensesTableViewController: UITableViewController {

    static let showLicenseSegueIdentifier = "showLicense"

    /**
        A list of SDK `title`s and either their `github` URL or the `website` URL.
        The title must match the file name of the license.
    */
    fileprivate let licenses = [
        [
            "title": "Alamofire",
            "github": "https://github.com/Alamofire/Alamofire"
        ],
        [
            "title": "Font Awesome",
            "website": "http://fontawesome.io"
        ],
        [
            "title": "MDCSwipeToChoose",
            "github": "https://github.com/modocache/MDCSwipeToChoose"
        ],
        [
            "title": "SwiftyJSON",
            "github": "https://github.com/SwiftyJSON/SwiftyJSON"
        ]
    ]

    /// Store title of the license for the segue
    var selectedLicense: String?

    /// Fetch the license and temporarily store it for the segue
    var licenseText: String?

    //
    // MARK: - UITableView
    //

    /**
        Show every license in the `licenses` array
    */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return licenses.count
    }

    /**
        Every license has the title and a URL
    */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    /**
        Open the webpage or the license when a cell is tapped
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 { // tapped the GitHub cell
            guard let link = licenses[indexPath.section]["github"] ?? licenses[indexPath.section]["website"], let url = URL(string: link) else { return }
            UIApplication.shared.openURL(url)
        } else if indexPath.row == 1 { // tapped the license cell
            guard let selectedLicense = licenses[indexPath.section]["title"], let licenseText = getLicenseTextFor(selectedLicense) else { return }
            self.licenseText = licenseText
            performSegue(withIdentifier: LicensesTableViewController.showLicenseSegueIdentifier, sender: self)
        }
    }

    /**
        Fetch the license text for an SDK - return `nil` if not found
    */
    func getLicenseTextFor(_ name: String) -> String? {
        if let url = Bundle.main.path(forResource: name, ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: url, encoding: String.Encoding.utf8)
                return contents
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }

    //
    // MARK: - Navigation
    //

    /**
        Show the license when a license cell is tapped
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == LicensesTableViewController.showLicenseSegueIdentifier {
            guard let licenseViewController = segue.destination as? LicenseViewController else { return }
            licenseViewController.title = selectedLicense
            licenseViewController.licenseText = licenseText
        }
    }

}
