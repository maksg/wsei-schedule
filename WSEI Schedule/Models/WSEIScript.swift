//
//  WSEIScript.swift
//  WSEI Schedule
//
//  Created by Maksymilian Galas on 19/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import Foundation

enum WSEIScript {
    
    case showHistory
    case selectType
    case selectSearch
    case selectAlbumNumber(number: String)
    case getScheduleContent
    
    var content: String {
        switch self {
        case .showHistory:
            return """
            var historyCheckbox = document.getElementById('ctl00_PlaceRight_FCDesktop_Field_210_0');
            historyCheckbox.checked = false;
            historyCheckbox.onclick();
            """
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
            var columnHeader = Array.prototype.map.call(tableBody.querySelectorAll("th"), th => {
            return th.innerText;
            });
            Object.values(tableBody.querySelectorAll('tr.grid-row, tr.grid-row-alternating')).map(tr => {
            const tableRow = Object.values(tr.querySelectorAll("td")).reduce( (accum, curr, i) => {
            const obj = { ...accum };
            if(columnHeader[i] != "" && columnHeader[i] != undefined) {
            obj[i] = columnHeader[i] + ': ' + curr.innerText;
            } else {
            obj[i] = curr.innerText;
            }
            return obj;
            }, {} );
            return tableRow;
            });
            """
        }
    }
    
}
