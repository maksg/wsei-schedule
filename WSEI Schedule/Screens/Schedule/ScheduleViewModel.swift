//
//  ScheduleViewModel.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 18/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import Foundation

enum WSEIScript {
    
    case selectType
    case selectSearch
    case selectAlbumNumber(number: String)
    case getScheduleContent
    
    var content: String {
        switch self {
        case .selectType:
            return """
            var typeSelect = document.getElementById('ctl00_PlaceRight_FCDesktop_Field_66');
            typeSelect.selectedIndex = 1;
            typeSelect.onchange();
            """
        case .selectSearch:
            return """
            var searchSelect = document.getElementById('ctl00_PlaceRight_FCDesktop_Field_83');
            searchSelect.selectedIndex = 1;
            searchSelect.onchange();
            """
        case .selectAlbumNumber(let number):
            return """
            var numberField = document.getElementById('ctl00_PlaceRight_FCDesktop_Field_82');
            numberField.value = '\(number)';
            numberField.onchange();
            """
        case .getScheduleContent:
            return """
            var tableBody = document.querySelector('#ctl00_PlaceRight_FCDesktop_Field_85_gvGrid tbody');
            Object.values(tableBody.querySelectorAll('tr.grid-row, tr.grid-row-alternating')).map(tr => {
                const tableRow = Object.values(tr.querySelectorAll("td")).reduce( (accum, curr, i) => {
                    const obj = { ...accum };
                    obj[i] = curr.innerText;
                    return obj;
                }, {} );
                return tableRow;
            });
            """
        }
    }
    
}

class ScheduleViewModel: ViewModel {
    
    var scheduleURL: URL {
        return URL(string: "https://estudent.wsei.edu.pl/SG/PublicDesktop.aspx?fileShareToken=95-88-6B-EB-B0-75-96-FB-A9-7C-AE-D7-5C-DB-90-49")!
    }
    
    var title: String {
        return Translation.Schedule.title.localized
    }
    
    init() {
    }
    
}
