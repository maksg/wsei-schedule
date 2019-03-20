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
    case addEventToTable
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
            if(typeSelect.selectedIndex != 1) {
                typeSelect.selectedIndex = 1;
                typeSelect.onchange();
            }
            else {
                { isSame: true }
            }
            """
        case .selectSearch:
            return """
            var searchSelect = document.getElementById('ctl00_PlaceRight_FCDesktop_Field_83');
            if(searchSelect.selectedIndex != 1) {
                searchSelect.selectedIndex = 1;
                searchSelect.onchange();
            }
            else {
                { isSame: true }
            }
            """
        case .selectAlbumNumber(let number):
            return """
            var numberField = document.getElementById('ctl00_PlaceRight_FCDesktop_Field_82');
            if(numberField.value != '\(number)') {
                numberField.value = '\(number)';
                numberField.onchange();
            }
            else {
                { isSame: true }
            }
            """
        case .addEventToTable:
            return """
            var MutationObserver = window.MutationObserver || window.WebKitMutationObserver
            var progressTarget = document.querySelector('#ctl00_Progress1');
            
            var config = { attributes: true };
            var callback = function(mutations, observer) {
                window.webkit.messageHandlers.iosListener.postMessage('reloaded');
            };
            
            var observer = new MutationObserver(callback);
            observer.observe(progressTarget, config);
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
