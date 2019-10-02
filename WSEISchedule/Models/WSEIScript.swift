//
//  WSEIScript.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 19/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import Foundation

enum WSEIScript {
    
    case setLogin(_ login: String)
    case setPassword(_ password: String)
    case setCaptcha(_ captcha: String)
    case login
    case refreshSchedule
    case observeContentChange
    case getScheduleContent
    
    var content: String {
        switch self {
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
        case .refreshSchedule:
            return """
            var wholeScheduleButton = document.getElementById('RadioList_Termin3');
            wholeScheduleButton.click();
            FiltrujDane(gridViewPlanyStudentow);
            """
        case .observeContentChange:
            return """
            var MutationObserver = window.MutationObserver || window.WebKitMutationObserver
            var target = document.getElementById('gridViewPlanyStudentow');
            
            var config = { childList: true, subtree: true };
            var callback = function(mutations, observer) {
                window.webkit.messageHandlers.iosListener.postMessage('reloaded');
            };
            
            var observer = new MutationObserver(callback);
            observer.observe(target, config);
            """
        case .getScheduleContent:
            return """
            var tableBody = document.querySelector('#gridViewPlanyStudentow_DXMainTable tbody');
            var columnHeader = Array.prototype.map.call(tableBody.querySelectorAll(".dxgvHeader_Aqua"), header => {
                return header.innerText;
            });
            var date = ""
            Object.values(tableBody.querySelectorAll('tr.dxgvGroupRow_Aqua, tr.dxgvDataRow_Aqua')).map(tr => {
                const tds = Object.values(tr.querySelectorAll("td"));
                if(tds.length == 2) {
                    date = tds[1].innerText;
                    return null;
                } else {
                    return tds.reduce( (accum, curr, i) => {
                        const obj = { ...accum };
                        if(i == 0) {
                            obj[i] = date;
                        } else if(columnHeader[i] != "" && columnHeader[i] != undefined) {
                            obj[i] = columnHeader[i] + ': ' + curr.innerText;
                        } else {
                            obj[i] = 'Unknown: ' + curr.innerText;
                        }
                        return obj;
                    }, {} );
                }
            }).filter(x => x);
            """
        }
    }
    
}
