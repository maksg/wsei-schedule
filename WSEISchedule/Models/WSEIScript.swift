//
//  WSEIScript.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 19/03/2019.
//  Copyright © 2019 Maksymilian Galas. All rights reserved.
//

import Foundation

enum WSEIScript {
    
    case zoomCaptcha
    case setLogin(_ login: String)
    case setPassword(_ password: String)
    case setCaptcha(_ captcha: String)
    case login
    case refreshSchedule
    case observeContentChange
    case getScheduleContent
    case getErrorMessage
    case getStudentInfo
    
    var content: String {
        switch self {
        case .zoomCaptcha:
            return """
            var captcha = document.getElementById('captchaImg');
            if(captcha != null) {
                captcha.style.zoom = 2.0;
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
            captchaField.value = '\(captcha)';
            """
        case .login:
            return """
            observer.disconnect();
            var loginButton = document.getElementById('subButton');
            loginButton.click();
            """
        case .refreshSchedule:
            return """
            var currentDate = new Date();
            var dataOd = (currentDate.getFullYear()-1) + ',' + currentDate.getMonth() + ',' + currentDate.getDate();
            var dataDo = (currentDate.getFullYear()+1) + ',' + currentDate.getMonth() + ',' + currentDate.getDate();
            var dataValue = dataOd + '\\\\' + dataDo + '\\\\3';
            var wholeScheduleButton = document.getElementById('RadioList_Termin3');
            wholeScheduleButton.value = dataValue;
            wholeScheduleButton.click();
            FiltrujDane(gridViewPlanyStudentow);
            observer.observe(target, config);
            """
        case .observeContentChange:
            return """
            var MutationObserver = window.MutationObserver || window.WebKitMutationObserver;
            var target = document.getElementById('gridViewPlanyStudentow');
            
            var config = { childList: true, subtree: true };
            var callback = function(mutations, observer) {
                if(document.getElementById('RadioList_Termin3').checked) {
                    window.webkit.messageHandlers.iosListener.postMessage('reloaded');
                }
            };
            
            var observer = new MutationObserver(callback);
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
        case .getErrorMessage:
            return """
            var error = document.querySelector('.validation-summary-errors ul li');
            if (error != null) {
                error.innerText;
            } else {
                "";
            }
            """
        case .getStudentInfo:
            return """
            var info = document.querySelector('#td_naglowek p').innerText.split('\\n');
            var imageUrl = document.querySelector('#zdjecie_glowne').src;
            var dict = {};
            dict['name'] = info[1];
            dict['number'] = info[2];
            dict['course_name'] = info[3];
            dict['photo_url'] = imageUrl;
            dict;
            """
        }
    }
    
}
