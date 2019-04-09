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
    case selectAlbumNumber(number: String)
    case observeContentChange
    case getScheduleContent
    case goToNextPage
    
    var content: String {
        switch self {
        case .showHistory:
            return """
            var historyCheckbox = document.getElementById('ctl00_PlaceRight_FCDesktop_Field_210_0');
            historyCheckbox.checked = false;
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
        case .observeContentChange:
            return """
            var MutationObserver = window.MutationObserver || window.WebKitMutationObserver
            var target = document.querySelector('#ctl00_Center');
            
            var config = { childList: true, subtree: true };
            var callback = function(mutations, observer) {
                window.webkit.messageHandlers.iosListener.postMessage('reloaded');
            };
            
            var observer = new MutationObserver(callback);
            observer.observe(target, config);
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
        case .goToNextPage:
            return """
            var nextButton = document.querySelector('#ctl00_PlaceRight_FCDesktop_Field_85_gvGrid_ctl54_Next');
            if (nextButton == null) {
                { isLastPage: true }
            } else {
                nextButton.click();
            }
            """
        }
    }
    
}
