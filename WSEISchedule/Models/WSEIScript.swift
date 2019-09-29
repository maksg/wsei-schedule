//
//  WSEIScript.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 19/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import Foundation

enum WSEIScript {
    
    case selectType
    case setLogin(_ login: String)
    case setPassword(_ password: String)
    case setCaptcha(_ captcha: String)
    case login
    case observeContentChange
    case getScheduleContent
    case goToNextPage
    
    var content: String {
        switch self {
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
        case .setLogin(let login):
            return """
            var loginField = document.getElementById('login');
            loginField.value = '\(login)';
            """
        case .setPassword(let password):
            return """
            var passwordField = document.getElementById('haslo');
            passwordField.value = '\(password)';
            """
        case .setCaptcha(let captcha):
            return """
            var captchaField = document.getElementById('captcha');
            captcha.value = '\(captcha)';
            """
        case .login:
            return """
            var loginButton = document.getElementById('subButton');
            loginButton.click();
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
