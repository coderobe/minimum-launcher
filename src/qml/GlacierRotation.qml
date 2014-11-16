/****************************************************************************************
**
** Copyright (C) 2014 Aleksi Suomalainen <suomalainen.aleksi@gmail.com>
** All rights reserved.
**
** You may use this file under the terms of BSD license as follows:
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are met:
**     * Redistributions of source code must retain the above copyright
**       notice, this list of conditions and the following disclaimer.
**     * Redistributions in binary form must reproduce the above copyright
**       notice, this list of conditions and the following disclaimer in the
**       documentation and/or other materials provided with the distribution.
**     * Neither the name of the author nor the
**       names of its contributors may be used to endorse or promote products
**       derived from this software without specific prior written permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
** ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
** WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
** DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
** ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
** (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
** LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
** ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
** SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
****************************************************************************************/

import QtQuick 2.1
import QtQuick.Window 2.1
import org.nemomobile.lipstick 0.1

Item {

    QtObject {
        id: privateProperties
        property int nativeRotation: Screen.angleBetween(nativeOrientation, Screen.primaryOrientation)
        property bool nativeIsPortrait: ((nativeRotation === 0) || (nativeRotation === 180))
    }

    property Item rotationParent

    function rotateRotationParent(o) {
        rotateObject(rotationParent, o)
    }

    function rotateObject(obj, o) {

        var r = Screen.angleBetween(o, Screen.primaryOrientation)
        if (obj.rotation !== r) {

            var isPortrait = ((r === 0) || (r === 180))
            var correction = 0
            var isNative=((privateProperties.nativeIsPortrait || isPortrait) && !(privateProperties.nativeIsPortrait && isPortrait)) //xor
            var diff = Math.abs(r - obj.rotation)
            //xor
            if ((isNative || !privateProperties.nativeIsPortrait) && !(isNative && !privateProperties.nativeIsPortrait)) {
              correction = obj.width / 2 - obj.height / 2
              if (diff === 180)
                correction = -correction
            }
            obj.rotation = r
            if ((diff === 90) || (diff === 270)) {
                var w = obj.width
                obj.width = obj.height
                obj.height = w
            }
            obj.x = correction
            obj.y = -correction
        }
    }
}