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
    case setLoginData(login: String, password: String)
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
            const captcha = document.getElementById('captchaImg');
            if(captcha != null) {
                captcha.style.zoom = 2.0;
            }
            """
        case .setLoginData(let login, let password):
            return """
            const loginForm = document.getElementById('form_logowanie');
            const trs = [].filter.call(loginForm.getElementsByTagName('tr'), el => el.getAttribute('style') == '');
            const loginField = trs[0].getElementsByTagName('input')[0];
            loginField.value = '\(login)';
            const passwordField = trs[1].getElementsByTagName('input')[0];
            passwordField.value = '\(password)';
            """
        case .setCaptcha(let captcha):
            return """
            const captchaField = document.getElementById('captcha');
            captchaField.value = '\(captcha)';
            """
        case .login:
            return """
            observer.disconnect();
            const loginButton = document.getElementById('subButton');
            loginButton.click();
            """
        case .refreshSchedule:
            return """
            const currentDate = new Date();
            const dataOd = (currentDate.getFullYear()-1) + ',' + currentDate.getMonth() + ',' + currentDate.getDate();
            const dataDo = (currentDate.getFullYear()+1) + ',' + currentDate.getMonth() + ',' + currentDate.getDate();
            const dataValue = dataOd + '\\\\' + dataDo + '\\\\3';
            const wholeScheduleButton = document.getElementById('RadioList_Termin3');
            wholeScheduleButton.value = dataValue;
            wholeScheduleButton.click();
            FiltrujDane(gridViewPlanyStudentow);
            observer.observe(target, config);
            """
        case .observeContentChange:
            return """
            const MutationObserver = window.MutationObserver || window.WebKitMutationObserver;
            const target = document.getElementById('gridViewPlanyStudentow');
            
            const config = { childList: true, subtree: true };
            const callback = function(mutations, observer) {
                if(document.getElementById('RadioList_Termin3').checked) {
                    window.webkit.messageHandlers.iosListener.postMessage('reloaded');
                }
            };
            
            const observer = new MutationObserver(callback);
            """
        case .getScheduleContent:
            return """
            const tableBody = document.querySelector('#gridViewPlanyStudentow_DXMainTable tbody');
            const columnHeader = Array.prototype.map.call(tableBody.querySelectorAll(".dxgvHeader_Aqua"), header => {
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
            const error = document.querySelector('.validation-summary-errors ul li');
            if (error != null) {
                error.innerText;
            } else {
                "";
            }
            """
        case .getStudentInfo:
            return """
            const info = document.querySelector('#td_naglowek p').innerText.split('\\n');
            const imageUrl = document.querySelector('#zdjecie_glowne').src;
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
