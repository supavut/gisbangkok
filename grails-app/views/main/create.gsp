<%--
  Created by IntelliJ IDEA.
  User: yana_yanee
  Date: 4/27/14 AD
  Time: 14:31
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Create</title>
    <meta name="layout" content="bangkokLayout"/>
    <!-- jQuery -->
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'css', file: 'custom-theme/jquery-ui-1.10.4.custom.css')}"/>
    <g:javascript src="jquery-ui-1.10.4/js/jquery-1.10.2.js"/>
    <g:javascript src="jquery-ui-1.10.4/js/jquery-ui-1.10.4.js"/>
    <!-- Openlayers -->
    <g:javascript src="OpenLayers-2.13.1/OpenLayers.js"/>
    <script src="http://maps.google.com/maps/api/js?v=3&amp;sensor=false"></script>
    <script>
        var drawControls;
        var draw_point;
        var click;
        var map;
        var vector;
        var geocoder = null;
        OpenLayers.Control.Click = OpenLayers.Class(OpenLayers.Control, {
            defaultHandlerOptions: {
                'single': true,
                'double': false,
                'pixelTolerance': 0,
                'stopSingle': false,
                'stopDouble': false
            },

            initialize: function (options) {
                this.handlerOptions = OpenLayers.Util.extend(
                        {}, this.defaultHandlerOptions
                );
                OpenLayers.Control.prototype.initialize.apply(
                        this, arguments
                );
                this.handler = new OpenLayers.Handler.Click(
                        this, {
                            'click': this.trigger
                        }, this.handlerOptions
                );
            },

            trigger: function (e) {
                var clickPosition = map.getLonLatFromPixel(e.xy);
                drawPoint(clickPosition.lat, clickPosition.lon);
                console.log("You clicked near lat: " + clickPosition.lat + " N, lon: " + +clickPosition.lon + " E");
            }

        });
        function init() {
            map = new OpenLayers.Map("map-canvas");

            //restrict to focus only bangkok area
            //map.setOptions({restrictedExtent: new OpenLayers.Bounds(8, 44.5, 19, 50)});

            //create based layer
            var gmap = new OpenLayers.Layer.Google("Google Streets", {numZoomLevels: 20});

            //create vector layer
            vector = new OpenLayers.Layer.Vector("Vectors", {
                        style: {
                            externalGraphic: "${resource(dir: 'images', file: 'marker.png')}",
                            graphicWidth: 21,
                            graphicHeight: 25,
                            graphicYOffset: -24
                        }
                    }
            );
            map.addLayers([gmap, vector]);

            //set map center
            var BangkokPosition = new OpenLayers.LonLat("11193299.296468", "1545835.5748853");
            map.setCenter(BangkokPosition, 12);

            //map.addControl(new OpenLayers.Control.LayerSwitcher());

            //add click event
            click = new OpenLayers.Control.Click();
            map.addControl(click);
            click.activate();

            createTime();

            $(function () {
                $("#datepicker").datepicker({
                    changeMonth: true,
                    changeYear: true
                });
            });

            geocoder = new google.maps.Geocoder();
        }
        function getAddress() {

            var addr = document.getElementById("address").value;
            var SearchPosition;
            //alert(addr);
            geocoder.geocode({'address': addr}, function (results, status) {
                console.log("latitude : " + results[0].geometry.location.lat());
                console.log("longitude : " + results[0].geometry.location.lng());
                var lat = results[0].geometry.location.lat();
                var lon = results[0].geometry.location.lng();
                SearchPosition = new OpenLayers.LonLat(lon, lat);
                map.setCenter(SearchPosition.transform(
                        new OpenLayers.Projection("EPSG:4326"),
                        map.getProjectionObject()
                ), 17);
            });
        }
        function drawPoint(lat, lon) {
            vector.removeAllFeatures();
            var p1 = new OpenLayers.Geometry.Point(parseFloat(lon), parseFloat(lat));
            var point = new OpenLayers.Feature.Vector(p1);
            vector.addFeatures(point);
            document.getElementById("lat").value = lat;
            document.getElementById("lon").value = lon;
        }
        function reset() {
            vector.removeAllFeatures();
            document.getElementById("lat").value = "";
            document.getElementById("lon").value = "";
        }
        function createTime() {
            var min = 00,
                    max = 55,
                    plus = 5,
                    select = document.getElementById('minute');

            for (var i = min; i <= max; i = i + plus) {
                var opt = document.createElement('option');
                opt.value = i;
                opt.innerHTML = i;
                select.appendChild(opt);
            }
            var hourMin = 00;
            var hourMax = 24;
            select = document.getElementById('hour');

            for (var i = hourMin; i <= hourMax; i++) {
                var opt = document.createElement('option');
                opt.value = i;
                opt.innerHTML = i;
                select.appendChild(opt);
            }
        }

        window.onload = init;
    </script>
    <script>
        function isNumber(e) {
            e = e || window.event;
            var charCode = e.which ? e.which : e.keyCode;
            return /\d/.test(String.fromCharCode(charCode));
        }

        function checkExtraData() {
            var isComplete = document.getElementById("isComplete").checked;
            if (!isComplete) {
                document.getElementById("sec2").style.display = 'none';
                document.getElementById("sec3").style.display = 'none';
                document.getElementById("sec4").style.display = 'none';
                document.getElementById("sec6").style.display = 'none';
                document.getElementById("sec7").style.display = 'none';
                document.getElementById("sec8").style.display = 'none';
                document.getElementById("sec8_1").style.display = 'none';
                document.getElementById("sec8_2").style.display = 'none';
                document.getElementById("sec9").style.display = 'none';
            } else {
                document.getElementById("sec2").style.display = 'block';
                document.getElementById("sec3").style.display = 'block';
                document.getElementById("sec4").style.display = 'block';
                document.getElementById("sec6").style.display = 'block';
                document.getElementById("sec7").style.display = 'block';
                document.getElementById("sec8").style.display = 'block';
                document.getElementById("sec8_1").style.display = 'block';
                document.getElementById("sec8_2").style.display = 'block';
                document.getElementById("sec9").style.display = 'block';
            }
        }
    </script>
</head>

<body onload="init();">

<g:form action="save">


<div id="sec1" style="display:block">
    <div class="extra container">
        <h2 align="middle">Section ข้อมูลพื้นฐาน</h2>

        <div class="tbox1">
            <table>

                <tr>
                    <td>
                        <h4>วันที่</h4>
                    </td>
                    <td colspan="2">
                        <g:field type="text" name="dateAccident" required="required" id="datepicker"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h4>เวลา</h4>
                    </td>
                    <td colspan="2">
                        <div id="time">
                            <g:select name="hour" class="combobox" id="hour" from=""/>
                            :&nbsp;&nbsp;&nbsp;&nbsp;
                            <g:select name="minute" class="combobox" id="minute" from=""/>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td><h4>ชื่อสถานีตำรวจนครบาล</h4></td>
                    <td colspan="2"><g:field type="text" name="policeStation" required="required"
                                             id="policeStation"/></td>
                </tr>
                <tr>
                    <td><h4>ชื่อถนน</h4></td>
                    <td colspan="2"><g:field type="text" name="roadName" required="required" id="roadName"/></td>
                </tr>
                <tr>
                    <td colspan="3"><h4>พิกัดจีพีเอส</h4></td>
                </tr>
                <tr>
                    <td colspan="3">
                        <input id="address" value="" type="text" size="30" placeholder="ค้นหาสถานที่"/>
                        <a href="" onclick="getAddress();
                        return false" class="button2">Search</a>
                    </td>
                </tr>
                <tr>
                    <td>
                        ละติจูด
                    </td>
                    <td colspan="2">
                        <g:field type="text" name="lat" id="lat" readonly="" value="" required="required"
                                 placeholder="- คลิกบนแผนที่ -"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        ลองติจูด
                    </td>
                    <td>
                        <g:field type="text" name="lon" id="lon" size="20" readonly="" value="" required="required"
                                 placeholder="- คลิกบนแผนที่ -"/>
                    </td>
                    <td>
                        <a href="" class="button2" onclick="reset();
                        return false;">Reset</a>
                    </td>
                </tr>
                <tr>
                    <td><h4>ข้อมูลเพิ่มเติม</h4></td>
                    <td colspan="2"><g:checkBox name="isComplete" id="isComplete" onclick="checkExtraData()" value="1"
                                                checked="false"/></td>
                </tr>

            </table>
        </div>

        <div class="tbox2">
            <div id="map-canvas"></div>
        </div>
    </div>
</div>

<div id="sec2" style="display:none">
    <div class="extra container">
        <h2 align="middle">Section ข้อมูลเส้นทาง</h2>

        <div class="boxA">
            <h4>บริเวณเฉพาะที่เกิดเหตุ</h4>
            <ul name="sec2">
                <g:radioGroup name="specificArea"
                              values="['ทางทั่วไป', 'ทางหลัก', 'ทางขนาน', 'ทางเข้าหรือทางออกหลัก', 'ไม่ระบุ']"
                              labels="['ทางทั่วไป', 'ทางหลัก', 'ทางขนาน', 'ทางเข้าหรือทางออกหลัก', 'ไม่ระบุ']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
            <h4>ลักษณะถนนขณะเกิดเหตุ</h4>
            <ul>
                <g:radioGroup name="roadAtCurrentTime" values="['ใช้งานปกติ', 'มีงานบำรุงรักษา', 'มีงานก่อสร้าง', '0']"
                              labels="['ใช้งานปกติ', 'มีงานบำรุงรักษา', 'มีงานก่อสร้าง', 'อื่นๆ']">
                    <li>${it.radio}<span><g:message code="${it.label}"/>
                    <g:if test="${it.label == 'อื่นๆ'}">
                        <g:field type="text" name="roadAtCurrentTimeOther" id="roadAtCurrentTimeOther"
                                 placeholder="ระบุ" maxlength="50"/>
                    </g:if>
                    </span></li>
                </g:radioGroup>
            </ul>
            <h4>จำนวนช่องจราจร</h4>
            <ul>
                <g:radioGroup name="roadLane" values="['2', '4', '6', '8 หรือมากกว่า']"
                              labels="['2', '4', '6', '8 หรือมากกว่า']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
        </div>

        <div class="boxB">
            <h4>ทิศทาง</h4>
            <ul>
                <g:radioGroup name="roadDirection" values="['มุ่งเหนือ', 'มุ่งใต้', 'มุ่งตะวันออก', 'มุ่งตะวันตก']"
                              labels="['มุ่งเหนือ', 'มุ่งใต้', 'มุ่งตะวันออก', 'มุ่งตะวันตก']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
            <h4>ประเภทเกาะกลาง</h4>
            <ul>
                <g:radioGroup name="islandType"
                              values="['ไม่มีเกาะกลาง', 'เกาะกลางแบบสี', 'เกาะกลางแบบดินถมยกขึ้น', 'เกาะกลางแบบร่อง', 'มีอุปกรณ์กั้นกลางถนน', 'ไม่ระบุ']"
                              labels="['ไม่มีเกาะกลาง', 'เกาะกลางแบบสี', 'เกาะกลางแบบดินถมยกขึ้น', 'เกาะกลางแบบร่อง', 'มีอุปกรณ์กั้นกลางถนน', 'ไม่ระบุ']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
            <h4>ชนิดผิวจราจร</h4>
            <ul>
                <g:radioGroup name="roadType" values="['คอนกรีต', 'ลาดยาง', 'ลูกรัง']"
                              labels="['คอนกรีต', 'ลาดยาง', 'ลูกรัง']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
        </div>

        <div class="boxC">

        </div>
    </div>
</div>

<div id="sec3" style="display:none">
    <div class="extra container">
        <h2 align="middle">Section ลักษณะบริเวณที่เกิดเหตุ</h2>

        <div class="boxA">
            <div>
                <h4>แนวราบ</h4>
                <ul>
                    <g:radioGroup name="horizontal" values="['ทางตรง', 'ทางโค้งปกติ', 'ทางโค้งหักศอก']"
                                  labels="['ทางตรง', 'ทางโค้งปกติ', 'ทางโค้งหักศอก']">
                        <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                    </g:radioGroup>
                </ul>
                <h4>ทางแยก</h4>
                <ul>
                    <g:radioGroup name="intersection"
                                  values="['ไม่ได้เกิดเหตุที่แยก', 'ทางแยกรูปตัว +', 'ทางแยกรูปตัว T', 'ทางแยกรูปตัว Y', 'วงเวียน', 'ทางแยกต่างระดับ/Ramps','ทางเเยกเข้าซอย/ทางเชื่อม', '0']"
                                  labels="['ไม่ได้เกิดเหตุที่แยก', 'ทางแยกรูปตัว +', 'ทางแยกรูปตัว T', 'ทางแยกรูปตัว Y', 'วงเวียน', 'ทางแยกต่างระดับ/Ramps','ทางเเยกเข้าซอย/ทางเชื่อม', 'อื่นๆ']">
                        <li>${it.radio}<span><g:message code="${it.label}"/>
                            <g:if test="${it.label == 'อื่นๆ'}">
                                <g:field type="text" name="intersectionOther" id="intersectionOther"
                                         placeholder="ระบุ" maxlength="50"/>
                            </g:if>
                        </span></li>
                    </g:radioGroup>
                </ul>
            </div>
        </div>

        <div class="boxB">
            <h4>จุดยูเทิร์น</h4>
            <ul>

                <g:radioGroup name="uTurn" values="['ไม่ได้เกิดเหตุที่จุดยูเทิร์น', 'จุดยูเทิร์นมีช่องลดความเร็ว', 'จุดยูเทิร์นไม่มีช่องลดความเร็ว']"
                              labels="['ไม่ได้เกิดเหตุที่จุดยูเทิร์น', 'จุดยูเทิร์นมีช่องลดความเร็ว', 'จุดยูเทิร์นไม่มีช่องลดความเร็ว']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>

        </div>

        <div class="boxC">
            <h4>บริเวณเฉพาะอื่นๆ</h4>
            <ul>
                <g:radioGroup name="roadTypeSpecial" values="['ทางรถจักรยานยนต์', 'ทางจักรยาน', 'ทางคนเดินเท้า',
                        'ทางม้าลาย','สะพาน','ทางลอด','ทางรถไฟตัดผ่าน','จุดกลับรถต่างระดับ','มีการเปลี่ยนความกว้างของช่องจราจร','บริเวณที่เกิดเหตุไม่มีลักษณะเฉพาะตามที่กล่าวมา']"
                              labels="['ทางรถจักรยานยนต์', 'ทางจักรยาน', 'ทางคนเดินเท้า',
                                      'ทางม้าลาย','สะพาน','ทางลอด','ทางรถไฟตัดผ่าน','จุดกลับรถต่างระดับ','มีการเปลี่ยนความกว้างของช่องจราจร','บริเวณที่เกิดเหตุไม่มีลักษณะเฉพาะตามที่กล่าวมา']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
        </div>
    </div>
</div>

<div id="sec4" style="display:none">
    <div class="extra container">
        <div class="boxA" style="height: 700px">
            <h2 align="middle">Section ลักษณะการเกิดอุบัติเหตุ</h2>
            <ul>
                <g:radioGroup name="accidentType" values="['รถจักรยานยนต์ชนรถยนต์', 'รถจักรยานยนต์ชนรถจัการยาน/รถสามล้อ', 'รถจักรยานยนต์ชนรถจักรยานพลิกคว่ำ/ตกถนน'
                        ,'รถจักรยานยนต์ชนคน','รถจักรยานยนต์ชนวัตถุ/สิ่งของ','รถยนต์ชนกัน','รถยนต์พลิกคว่ำ/ตกถนน','รถยนต์ชนรถจักรยานยนต์/รถสามล้อ','รถยนต์ชนวัตถุ/สิ่งของ','รถยนต์ชนคน'
                        ,'รถยนต์ชนรถไฟ','รถยนต์ชนสัตว์/รถลากจูงด้วยสัตว์','0']"
                              labels="['รถจักรยานยนต์ชนรถยนต์', 'รถจักรยานยนต์ชนรถจัการยาน/รถสามล้อ', 'รถจักรยานยนต์ชนรถจักรยานพลิกคว่ำ/ตกถนน'
                                      ,'รถจักรยานยนต์ชนคน','รถจักรยานยนต์ชนวัตถุ/สิ่งของ','รถยนต์ชนกัน','รถยนต์พลิกคว่ำ/ตกถนน','รถยนต์ชนรถจักรยานยนต์/รถสามล้อ','รถยนต์ชนวัตถุ/สิ่งของ','รถยนต์ชนคน'
                                      ,'รถยนต์ชนรถไฟ','รถยนต์ชนสัตว์/รถลากจูงด้วยสัตว์','อื่นๆ']">
                    <li>${it.radio}<span><g:message code="${it.label}"/>
                        <g:if test="${it.label == 'อื่นๆ'}">
                            <g:field type="text" name="accidentTypeOther" id="accidentTypeOther"
                                     placeholder="ระบุ" maxlength="50"/>
                        </g:if>
                    </span></li>
                </g:radioGroup>
            </ul>
        </div>

        <div class="boxB" style="height: 700px">
            <h2 align="middle">Section ทัศนวิสัยและสภาพแวดล้อม</h2>
            <h4>ผิวทาง</h4>
            <ul>
                <g:radioGroup name="roadHumidity" values="['เปียก', 'แห้ง']"
                              labels="['เปียก', 'แห้ง']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
            <h4>สภาพผิวทาง</h4>
            <ul>
                <g:radioGroup name="roadSurface"
                              values="['ดี', 'เป็นคลื่น/หลุม/บ่อ', 'สกปรก', 'ทางแยกรูปตัว Y', '0']"
                              labels="['ดี', 'เป็นคลื่น/หลุม/บ่อ', 'สกปรก', 'ทางแยกรูปตัว Y', 'อื่นๆ']">
                    <li>${it.radio}<span><g:message code="${it.label}"/>
                    <g:if test="${it.label == 'อื่นๆ'}">
                        <g:field type="text" name="roadSurfaceOther" id="roadSurfaceOther"
                                 placeholder="ระบุ" maxlength="50"/>
                    </g:if>
                    </span></li>
                </g:radioGroup>
            </ul>
            <h4>สภาพภูมิอากาศ</h4>
            <ul>
                <g:radioGroup name="weather"
                              values="['แจ่มใส', 'มีควันฝุ่น', 'มีหมอก', 'ฝนตก', '0']"
                              labels="['แจ่มใส', 'มีควันฝุ่น', 'มีหมอก', 'ฝนตก', 'อื่นๆ']">
                    <li>${it.radio}<span><g:message code="${it.label}"/>
                    <g:if test="${it.label == 'อื่นๆ'}">
                        <g:field type="text" name="weatherOther" id="weatherOther"
                                 placeholder="ระบุ" maxlength="50"/>
                    </g:if>
                    </span></li>
                </g:radioGroup>
            </ul>

            <h4>แสงสว่าง</h4>
            <ul>
                <g:radioGroup name="light" values="['กลางวัน', 'กลางคืน-มีเเสงสว่างเพียงพอ','กลางคืน-ไม่มีเเสงสว่างเพียงพอ']"
                              labels="['กลางวัน', 'กลางคืน-มีเเสงสว่างเพียงพอ','กลางคืน-ไม่มีเเสงสว่างเพียงพอ']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
        </div>

        <div class="boxC" style="height: 700px">


        </div>
    </div>
</div>

<div id="sec6" style="display:none">
    <div class="extra container">
        <h2 align="middle">Section ข้อมูลเกี่ยวกับผู้ขับขี่หรือผู้ใช้ถนน</h2>

        <div class="boxA" style="height: 1250px">
            <h4>ประเภทผู้ใช้ถนน คันที่ 1</h4>
            <ul>
                <g:radioGroup name="carType1" values="['ไม่มี', 'รถจักรยาน','รถจักรยานยนต์',
                        'รถสามล้อ', 'รถสามล้อเครื่อง','รถยนต์นั่ง',
                        'รถตู้', 'รถปิคอัพโดยสาร','รถปิคอัพบรรทุก 4 ล้อ',
                        'รถโดยสารขนาดใหญ่', 'รถบรรทุก 6 ล้อ','รถบรรทุกมากกว่า 6 ล้อ ไม่เกิน 10 ล้อ',
                        'รถบรรทุกมากกว่า 10 ล้อ', 'รถอีแต๋น','รถอื่นๆ','คนเดินเท้า']"
                              labels="['ไม่มี', 'รถจักรยาน','รถจักรยานยนต์',
                                      'รถสามล้อ', 'รถสามล้อเครื่อง','รถยนต์นั่ง',
                                      'รถตู้', 'รถปิคอัพโดยสาร','รถปิคอัพบรรทุก 4 ล้อ',
                                      'รถโดยสารขนาดใหญ่', 'รถบรรทุก 6 ล้อ','รถบรรทุกมากกว่า 6 ล้อ ไม่เกิน 10 ล้อ',
                                      'รถบรรทุกมากกว่า 10 ล้อ', 'รถอีแต๋น','รถอื่นๆ','คนเดินเท้า']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
            <h4>หมายเลขทะเบียนรถ</h4>
            <g:field type="text" name="carRegistrationA1" id="carRegistrationA1"  size="2" maxlength="2"/>
            <g:field type="text" name="carRegistrationB1" id="carRegistrationB1"  size="4" maxlength="4" onkeypress="return isNumber(event);"/>
            <h4>ยี่ห้อรถ</h4>
            <g:field type="text" name="carBrand1" id="carBrand1"  value="" placeholder="ระบุ" size="20" maxlength="20"/>
            <h4>ชื่อผู้ขับขี่หรือผู้ใช้ถนน</h4>
            <g:field type="text" name="name1" id="name1"  value="" maxlength="50"/>
            <h4>นามสกุลผู้ขับขี่หรือผู้ใช้ถนน</h4>
            <g:field type="text" name="lastName1" id="lastName1"  value="" maxlength="50"/>
            <h4>หมายเลขประจำตัวประชาชน</h4>
            <g:field type="text" name="identificationCard1" id="identificationCard1" value="" placeholder="ระบุ" size="20" maxlength="13"
                     onkeypress="return isNumber(event);"/>
            <h4>หมายเลขบัตรใบขับขี่</h4>
            <g:field type="text" name="drivingLicense1" id="drivingLicense1" value="" placeholder="ระบุ" size="20" maxlength="13"
                     onkeypress="return isNumber(event);"/>
            <h4>อายุผู้ขับขี่หรือผู้ใช้ถนน (ปี)</h4>
            <g:field type="text" name="age1" id="age1"  value="" placeholder="ระบุ" size="2"
                     maxlength="2" onkeypress="return isNumber(event);" />
            <h4>เพศผู้ขับขี่หรือผู้ใช้ถนน</h4>
            <g:radioGroup name="gender1" values="['ญ', 'ช']"
                          labels="['หญิง', 'ชาย']">
                ${it.radio}<span><g:message code="${it.label}"/></span>
            </g:radioGroup>
            <h4>การใช้อุปกรณ์นิรภัยของผู้ขับขี่</h4>
            <g:radioGroup name="equipment1" values="['หมวกนิรภัย', 'เข็มขัดนิรภัย','ไม่ใช้','ไม่ระบุ']"
                          labels="['หมวกนิรภัย', 'เข็มขัดนิรภัย','ไม่ใช้','ไม่ระบุ']">
                ${it.radio}<span><g:message code="${it.label}"/></span>
            </g:radioGroup>
            <h4>การเสพของมึนเมาหรือยา</h4>
            <g:radioGroup name="drug1" values="['มี', 'ไม่มี','ไม่ระบุ']"
                          labels="['มี', 'ไม่มี','ไม่ระบุ']">
                ${it.radio}<span><g:message code="${it.label}"/></span>
            </g:radioGroup>
            <h4>การบาดเจ็บ</h4>
            <ul>
                <g:radioGroup name="injury1" values="['ตายที่จุดเกิดเหตุ', 'ตายที่โรงพยาบาล','บาดเจ็บสาหัส','บาดเจ็บเล็กน้อย']"
                              labels="['ตายที่จุดเกิดเหตุ', 'ตายที่โรงพยาบาล','บาดเจ็บสาหัส','บาดเจ็บเล็กน้อย']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
        </div>

        <div class="boxB" style="height: 1250px">
            <h4>ประเภทผู้ใช้ถนน คันที่ 2</h4>
            <ul>
                <g:radioGroup name="carType2" values="['ไม่มี', 'รถจักรยาน','รถจักรยานยนต์',
                        'รถสามล้อ', 'รถสามล้อเครื่อง','รถยนต์นั่ง',
                        'รถตู้', 'รถปิคอัพโดยสาร','รถปิคอัพบรรทุก 4 ล้อ',
                        'รถโดยสารขนาดใหญ่', 'รถบรรทุก 6 ล้อ','รถบรรทุกมากกว่า 6 ล้อ ไม่เกิน 10 ล้อ',
                        'รถบรรทุกมากกว่า 10 ล้อ', 'รถอีแต๋น','รถอื่นๆ','คนเดินเท้า']"
                              labels="['ไม่มี', 'รถจักรยาน','รถจักรยานยนต์',
                                      'รถสามล้อ', 'รถสามล้อเครื่อง','รถยนต์นั่ง',
                                      'รถตู้', 'รถปิคอัพโดยสาร','รถปิคอัพบรรทุก 4 ล้อ',
                                      'รถโดยสารขนาดใหญ่', 'รถบรรทุก 6 ล้อ','รถบรรทุกมากกว่า 6 ล้อ ไม่เกิน 10 ล้อ',
                                      'รถบรรทุกมากกว่า 10 ล้อ', 'รถอีแต๋น','รถอื่นๆ','คนเดินเท้า']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
            <h4>หมายเลขทะเบียนรถ</h4>
            <g:field type="text" name="carRegistrationA2" id="carRegistrationA2"  size="2" maxlength="2"/>
            <g:field type="text" name="carRegistrationB2" id="carRegistrationB2"  size="4" maxlength="4" onkeypress="return isNumber(event);"/>
            <h4>ยี่ห้อรถ</h4>
            <g:field type="text" name="carBrand2" id="carBrand2"  value="" placeholder="ระบุ" size="20" maxlength="20"/>
            <h4>ชื่อผู้ขับขี่หรือผู้ใช้ถนน</h4>
            <g:field type="text" name="name2" id="name2"  value="" maxlength="50"/>
            <h4>นามสกุลผู้ขับขี่หรือผู้ใช้ถนน</h4>
            <g:field type="text" name="lastName2" id="lastName2"  value="" maxlength="50"/>
            <h4>หมายเลขประจำตัวประชาชน</h4>
            <g:field type="text" name="identificationCard2" id="identificationCard2" value="" placeholder="ระบุ" size="20" maxlength="13"
                     onkeypress="return isNumber(event);"/>
            <h4>หมายเลขบัตรใบขับขี่</h4>
            <g:field type="text" name="drivingLicense2" id="drivingLicense2" value="" placeholder="ระบุ" size="20" maxlength="13"
                     onkeypress="return isNumber(event);"/>
            <h4>อายุผู้ขับขี่หรือผู้ใช้ถนน (ปี)</h4>
            <g:field type="text" name="age2" id="age2"  value="" placeholder="ระบุ" size="2"
                     maxlength="2" onkeypress="return isNumber(event);" />
            <h4>เพศผู้ขับขี่หรือผู้ใช้ถนน</h4>
            <g:radioGroup name="gender2" values="['ญ', 'ช']"
                          labels="['หญิง', 'ชาย']">
                ${it.radio}<span><g:message code="${it.label}"/></span>
            </g:radioGroup>
            <h4>การใช้อุปกรณ์นิรภัยของผู้ขับขี่</h4>
            <g:radioGroup name="equipment2" values="['หมวกนิรภัย', 'เข็มขัดนิรภัย','ไม่ใช้','ไม่ระบุ']"
                          labels="['หมวกนิรภัย', 'เข็มขัดนิรภัย','ไม่ใช้','ไม่ระบุ']">
                ${it.radio}<span><g:message code="${it.label}"/></span>
            </g:radioGroup>
            <h4>การเสพของมึนเมาหรือยา</h4>
            <g:radioGroup name="drug2" values="['มี', 'ไม่มี','ไม่ระบุ']"
                          labels="['มี', 'ไม่มี','ไม่ระบุ']">
                ${it.radio}<span><g:message code="${it.label}"/></span>
            </g:radioGroup>
            <h4>การบาดเจ็บ</h4>
            <ul>
                <g:radioGroup name="injury2" values="['ตายที่จุดเกิดเหตุ', 'ตายที่โรงพยาบาล','บาดเจ็บสาหัส','บาดเจ็บเล็กน้อย']"
                              labels="['ตายที่จุดเกิดเหตุ', 'ตายที่โรงพยาบาล','บาดเจ็บสาหัส','บาดเจ็บเล็กน้อย']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
        </div>

        <div class="boxC" style="height: 1250px">
            <h4>ประเภทผู้ใช้ถนน คันที่ 3</h4>
            <ul>
                <g:radioGroup name="carType3" values="['ไม่มี', 'รถจักรยาน','รถจักรยานยนต์',
                        'รถสามล้อ', 'รถสามล้อเครื่อง','รถยนต์นั่ง',
                        'รถตู้', 'รถปิคอัพโดยสาร','รถปิคอัพบรรทุก 4 ล้อ',
                        'รถโดยสารขนาดใหญ่', 'รถบรรทุก 6 ล้อ','รถบรรทุกมากกว่า 6 ล้อ ไม่เกิน 10 ล้อ',
                        'รถบรรทุกมากกว่า 10 ล้อ', 'รถอีแต๋น','รถอื่นๆ','คนเดินเท้า']"
                              labels="['ไม่มี', 'รถจักรยาน','รถจักรยานยนต์',
                                      'รถสามล้อ', 'รถสามล้อเครื่อง','รถยนต์นั่ง',
                                      'รถตู้', 'รถปิคอัพโดยสาร','รถปิคอัพบรรทุก 4 ล้อ',
                                      'รถโดยสารขนาดใหญ่', 'รถบรรทุก 6 ล้อ','รถบรรทุกมากกว่า 6 ล้อ ไม่เกิน 10 ล้อ',
                                      'รถบรรทุกมากกว่า 10 ล้อ', 'รถอีแต๋น','รถอื่นๆ','คนเดินเท้า']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
            <h4>หมายเลขทะเบียนรถ</h4>
            <g:field type="text" name="carRegistrationA3" id="carRegistrationA3"  size="2" maxlength="2"/>
            <g:field type="text" name="carRegistrationB3" id="carRegistrationB3"  size="4" maxlength="4" onkeypress="return isNumber(event);"/>
            <h4>ยี่ห้อรถ</h4>
            <g:field type="text" name="carBrand3" id="carBrand3"  value="" placeholder="ระบุ" size="20" maxlength="20"/>
            <h4>ชื่อผู้ขับขี่หรือผู้ใช้ถนน</h4>
            <g:field type="text" name="name3" id="name3"  value="" maxlength="50"/>
            <h4>นามสกุลผู้ขับขี่หรือผู้ใช้ถนน</h4>
            <g:field type="text" name="lastName3" id="lastName3"  value="" maxlength="50"/>
            <h4>หมายเลขประจำตัวประชาชน</h4>
            <g:field type="text" name="identificationCard3" id="identificationCard3" value="" placeholder="ระบุ" size="20" maxlength="13"
                     onkeypress="return isNumber(event);"/>
            <h4>หมายเลขบัตรใบขับขี่</h4>
            <g:field type="text" name="drivingLicense3" id="drivingLicense3" value="" placeholder="ระบุ" size="20" maxlength="13"
                     onkeypress="return isNumber(event);"/>
            <h4>อายุผู้ขับขี่หรือผู้ใช้ถนน (ปี)</h4>
            <g:field type="text" name="age3" id="age3"  value="" placeholder="ระบุ" size="2"
                     maxlength="2" onkeypress="return isNumber(event);" />
            <h4>เพศผู้ขับขี่หรือผู้ใช้ถนน</h4>
            <g:radioGroup name="gender3" values="['ญ', 'ช']"
                          labels="['หญิง', 'ชาย']">
                ${it.radio}<span><g:message code="${it.label}"/></span>
            </g:radioGroup>
            <h4>การใช้อุปกรณ์นิรภัยของผู้ขับขี่</h4>
            <g:radioGroup name="equipment3" values="['หมวกนิรภัย', 'เข็มขัดนิรภัย','ไม่ใช้','ไม่ระบุ']"
                          labels="['หมวกนิรภัย', 'เข็มขัดนิรภัย','ไม่ใช้','ไม่ระบุ']">
                ${it.radio}<span><g:message code="${it.label}"/></span>
            </g:radioGroup>
            <h4>การเสพของมึนเมาหรือยา</h4>
            <g:radioGroup name="drug3" values="['มี', 'ไม่มี','ไม่ระบุ']"
                          labels="['มี', 'ไม่มี','ไม่ระบุ']">
                ${it.radio}<span><g:message code="${it.label}"/></span>
            </g:radioGroup>
            <h4>การบาดเจ็บ</h4>
            <ul>
                <g:radioGroup name="injury3" values="['ตายที่จุดเกิดเหตุ', 'ตายที่โรงพยาบาล','บาดเจ็บสาหัส','บาดเจ็บเล็กน้อย']"
                              labels="['ตายที่จุดเกิดเหตุ', 'ตายที่โรงพยาบาล','บาดเจ็บสาหัส','บาดเจ็บเล็กน้อย']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
        </div>
    </div>
</div>

<div id="sec8" style="display:none">
    <div class="extra container">
        <h2 align="middle">Section ข้อมูลเกี่ยวกับผู้โดยสาร/ตำเเหน่งที่นั่ง</h2>
        <div class="boxA" style="height: 700px">
            <h4>ผู้โดยสาร คันที่1 คนที่1</h4>
            <h4>ตำเเหน่ง ที่นั่ง</h4>
            <ul>
                <g:radioGroup name="seatPosition1_1" values="['ซ้อนท้าย จยย.', 'ด้านหน้ารถยนต์', 'ด้านหลังรถยนต์']"
                              labels="['ซ้อนท้าย จยย.', 'ด้านหน้ารถยนต์', 'ด้านหลังรถยนต์']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
            <h4>อายุผู้โดยสาร</h4>
            <ul>
                <g:field type="text" name="passengerAge1_1" id="passengerAge"
                         placeholder="ระบุ" maxlength="50"/>
            </ul>
            <h4>เพศผู้โดยสาร</h4>
            <ul>
                <g:radioGroup name="passengerGender1_1" values="['ญ', 'ช']"
                              labels="['หญิง', 'ชาย']">
                    ${it.radio}<span><g:message code="${it.label}"/></span>
                </g:radioGroup>
            </ul>
            <h4>การใช้อุปกรณ์นิรภัยของผู้ขับขี่</h4>
            <g:radioGroup name="passengerEquipment1_1" values="['หมวกนิรภัย', 'เข็มขัดนิรภัย','ไม่ใช้','ไม่ระบุ']"
                          labels="['หมวกนิรภัย', 'เข็มขัดนิรภัย','ไม่ใช้','ไม่ระบุ']">
                ${it.radio}<span><g:message code="${it.label}"/></span>
            </g:radioGroup>
            <h4>การบาดเจ็บ</h4>
            <ul>
                <g:radioGroup name="passengerInjury1_1" values="['ตายที่จุดเกิดเหตุ', 'ตายที่โรงพยาบาล','บาดเจ็บสาหัส','บาดเจ็บเล็กน้อย']"
                              labels="['ตายที่จุดเกิดเหตุ', 'ตายที่โรงพยาบาล','บาดเจ็บสาหัส','บาดเจ็บเล็กน้อย']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
        </div>

        <div class="boxB" style="height: 700px">
            <h4>ผู้โดยสาร คันที่1 คนที่2</h4>
            <h4>ตำเเหน่ง ที่นั่ง</h4>
            <ul>
                <g:radioGroup name="seatPosition1_2" values="['ซ้อนท้าย จยย.', 'ด้านหน้ารถยนต์', 'ด้านหลังรถยนต์']"
                              labels="['ซ้อนท้าย จยย.', 'ด้านหน้ารถยนต์', 'ด้านหลังรถยนต์']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
            <h4>อายุผู้โดยสาร</h4>
            <ul>
                <g:field type="text" name="passengerAge1_2" id="passengerAge"
                         placeholder="ระบุ" maxlength="50"/>
            </ul>
            <h4>เพศผู้โดยสาร</h4>
            <ul>
                <g:radioGroup name="passengerGender1_2" values="['ญ', 'ช']"
                              labels="['หญิง', 'ชาย']">
                    ${it.radio}<span><g:message code="${it.label}"/></span>
                </g:radioGroup>
            </ul>
            <h4>การใช้อุปกรณ์นิรภัยของผู้ขับขี่</h4>
            <g:radioGroup name="passengerEquipment1_2" values="['หมวกนิรภัย', 'เข็มขัดนิรภัย','ไม่ใช้','ไม่ระบุ']"
                          labels="['หมวกนิรภัย', 'เข็มขัดนิรภัย','ไม่ใช้','ไม่ระบุ']">
                ${it.radio}<span><g:message code="${it.label}"/></span>
            </g:radioGroup>
            <h4>การบาดเจ็บ</h4>
            <ul>
                <g:radioGroup name="passengerInjury1_2" values="['ตายที่จุดเกิดเหตุ', 'ตายที่โรงพยาบาล','บาดเจ็บสาหัส','บาดเจ็บเล็กน้อย']"
                              labels="['ตายที่จุดเกิดเหตุ', 'ตายที่โรงพยาบาล','บาดเจ็บสาหัส','บาดเจ็บเล็กน้อย']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
        </div>

        <div class="boxC" style="height: 700px">
            <h4>ผู้โดยสาร คันที่1 คนที่3</h4>
            <h4>ตำเเหน่ง ที่นั่ง</h4>
            <ul>
                <g:radioGroup name="seatPosition1_3" values="['ซ้อนท้าย จยย.', 'ด้านหน้ารถยนต์', 'ด้านหลังรถยนต์']"
                              labels="['ซ้อนท้าย จยย.', 'ด้านหน้ารถยนต์', 'ด้านหลังรถยนต์']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
            <h4>อายุผู้โดยสาร</h4>
            <ul>
                <g:field type="text" name="passengerAge1_3" id="passengerAge"
                         placeholder="ระบุ" maxlength="50"/>
            </ul>
            <h4>เพศผู้โดยสาร</h4>
            <ul>
                <g:radioGroup name="passengerGender1_3" values="['ญ', 'ช']"
                              labels="['หญิง', 'ชาย']">
                    ${it.radio}<span><g:message code="${it.label}"/></span>
                </g:radioGroup>
            </ul>
            <h4>การใช้อุปกรณ์นิรภัยของผู้ขับขี่</h4>
            <g:radioGroup name="passengerEquipment1_3" values="['หมวกนิรภัย', 'เข็มขัดนิรภัย','ไม่ใช้','ไม่ระบุ']"
                          labels="['หมวกนิรภัย', 'เข็มขัดนิรภัย','ไม่ใช้','ไม่ระบุ']">
                ${it.radio}<span><g:message code="${it.label}"/></span>
            </g:radioGroup>
            <h4>การบาดเจ็บ</h4>
            <ul>
                <g:radioGroup name="passengerInjury1_3" values="['ตายที่จุดเกิดเหตุ', 'ตายที่โรงพยาบาล','บาดเจ็บสาหัส','บาดเจ็บเล็กน้อย']"
                              labels="['ตายที่จุดเกิดเหตุ', 'ตายที่โรงพยาบาล','บาดเจ็บสาหัส','บาดเจ็บเล็กน้อย']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
        </div>
    </div>
</div>

<div id="sec8_1" style="display:none">
    <div class="extra container">
        <div class="boxA" style="height: 700px">
            <h4>ผู้โดยสาร คันที่2 คนที่1</h4>
            <h4>ตำเเหน่ง ที่นั่ง</h4>
            <ul>
                <g:radioGroup name="seatPosition2_1" values="['ซ้อนท้าย จยย.', 'ด้านหน้ารถยนต์', 'ด้านหลังรถยนต์']"
                              labels="['ซ้อนท้าย จยย.', 'ด้านหน้ารถยนต์', 'ด้านหลังรถยนต์']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
            <h4>อายุผู้โดยสาร</h4>
            <ul>
                <g:field type="text" name="passengerAge2_1" id="passengerAge"
                         placeholder="ระบุ" maxlength="50"/>
            </ul>
            <h4>เพศผู้โดยสาร</h4>
            <ul>
                <g:radioGroup name="passengerGender2_1" values="['ญ', 'ช']"
                              labels="['หญิง', 'ชาย']">
                    ${it.radio}<span><g:message code="${it.label}"/></span>
                </g:radioGroup>
            </ul>
            <h4>การใช้อุปกรณ์นิรภัยของผู้ขับขี่</h4>
            <g:radioGroup name="passengerEquipment2_1" values="['หมวกนิรภัย', 'เข็มขัดนิรภัย','ไม่ใช้','ไม่ระบุ']"
                          labels="['หมวกนิรภัย', 'เข็มขัดนิรภัย','ไม่ใช้','ไม่ระบุ']">
                ${it.radio}<span><g:message code="${it.label}"/></span>
            </g:radioGroup>
            <h4>การบาดเจ็บ</h4>
            <ul>
                <g:radioGroup name="passengerInjury2_1" values="['ตายที่จุดเกิดเหตุ', 'ตายที่โรงพยาบาล','บาดเจ็บสาหัส','บาดเจ็บเล็กน้อย']"
                              labels="['ตายที่จุดเกิดเหตุ', 'ตายที่โรงพยาบาล','บาดเจ็บสาหัส','บาดเจ็บเล็กน้อย']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
        </div>

        <div class="boxB" style="height: 700px">
            <h4>ผู้โดยสาร คันที่1 คนที่2</h4>
            <h4>ตำเเหน่ง ที่นั่ง</h4>
            <ul>
                <g:radioGroup name="seatPosition2_2" values="['ซ้อนท้าย จยย.', 'ด้านหน้ารถยนต์', 'ด้านหลังรถยนต์']"
                              labels="['ซ้อนท้าย จยย.', 'ด้านหน้ารถยนต์', 'ด้านหลังรถยนต์']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
            <h4>อายุผู้โดยสาร</h4>
            <ul>
                <g:field type="text" name="passengerAge2_2" id="passengerAge"
                         placeholder="ระบุ" maxlength="50"/>
            </ul>
            <h4>เพศผู้โดยสาร</h4>
            <ul>
                <g:radioGroup name="passengerGender2_2" values="['ญ', 'ช']"
                              labels="['หญิง', 'ชาย']">
                    ${it.radio}<span><g:message code="${it.label}"/></span>
                </g:radioGroup>
            </ul>
            <h4>การใช้อุปกรณ์นิรภัยของผู้ขับขี่</h4>
            <g:radioGroup name="passengerEquipment2_2" values="['หมวกนิรภัย', 'เข็มขัดนิรภัย','ไม่ใช้','ไม่ระบุ']"
                          labels="['หมวกนิรภัย', 'เข็มขัดนิรภัย','ไม่ใช้','ไม่ระบุ']">
                ${it.radio}<span><g:message code="${it.label}"/></span>
            </g:radioGroup>
            <h4>การบาดเจ็บ</h4>
            <ul>
                <g:radioGroup name="passengerInjury2_2" values="['ตายที่จุดเกิดเหตุ', 'ตายที่โรงพยาบาล','บาดเจ็บสาหัส','บาดเจ็บเล็กน้อย']"
                              labels="['ตายที่จุดเกิดเหตุ', 'ตายที่โรงพยาบาล','บาดเจ็บสาหัส','บาดเจ็บเล็กน้อย']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
        </div>

        <div class="boxC" style="height: 700px">
            <h4>ผู้โดยสาร คันที่1 คนที่3</h4>
            <h4>ตำเเหน่ง ที่นั่ง</h4>
            <ul>
                <g:radioGroup name="seatPosition2_3" values="['ซ้อนท้าย จยย.', 'ด้านหน้ารถยนต์', 'ด้านหลังรถยนต์']"
                              labels="['ซ้อนท้าย จยย.', 'ด้านหน้ารถยนต์', 'ด้านหลังรถยนต์']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
            <h4>อายุผู้โดยสาร</h4>
            <ul>
                <g:field type="text" name="passengerAge2_3" id="passengerAge"
                         placeholder="ระบุ" maxlength="50"/>
            </ul>
            <h4>เพศผู้โดยสาร</h4>
            <ul>
                <g:radioGroup name="passengerGender2_3" values="['ญ', 'ช']"
                              labels="['หญิง', 'ชาย']">
                    ${it.radio}<span><g:message code="${it.label}"/></span>
                </g:radioGroup>
            </ul>
            <h4>การใช้อุปกรณ์นิรภัยของผู้ขับขี่</h4>
            <g:radioGroup name="passengerEquipment2_3" values="['หมวกนิรภัย', 'เข็มขัดนิรภัย','ไม่ใช้','ไม่ระบุ']"
                          labels="['หมวกนิรภัย', 'เข็มขัดนิรภัย','ไม่ใช้','ไม่ระบุ']">
                ${it.radio}<span><g:message code="${it.label}"/></span>
            </g:radioGroup>
            <h4>การบาดเจ็บ</h4>
            <ul>
                <g:radioGroup name="passengerInjury2_3" values="['ตายที่จุดเกิดเหตุ', 'ตายที่โรงพยาบาล','บาดเจ็บสาหัส','บาดเจ็บเล็กน้อย']"
                              labels="['ตายที่จุดเกิดเหตุ', 'ตายที่โรงพยาบาล','บาดเจ็บสาหัส','บาดเจ็บเล็กน้อย']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
        </div>
    </div>
</div>

<div id="sec8_2" style="display:none">
    <div class="extra container">
        <div class="boxA" style="height: 700px">
            <h4>ผู้โดยสาร คันที่3 คนที่1</h4>
            <h4>ตำเเหน่ง ที่นั่ง</h4>
            <ul>
                <g:radioGroup name="seatPosition3_1" values="['ซ้อนท้าย จยย.', 'ด้านหน้ารถยนต์', 'ด้านหลังรถยนต์']"
                              labels="['ซ้อนท้าย จยย.', 'ด้านหน้ารถยนต์', 'ด้านหลังรถยนต์']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
            <h4>อายุผู้โดยสาร</h4>
            <ul>
                <g:field type="text" name="passengerAge3_1" id="passengerAge"
                         placeholder="ระบุ" maxlength="50"/>
            </ul>
            <h4>เพศผู้โดยสาร</h4>
            <ul>
                <g:radioGroup name="passengerGender3_1" values="['ญ', 'ช']"
                              labels="['หญิง', 'ชาย']">
                    ${it.radio}<span><g:message code="${it.label}"/></span>
                </g:radioGroup>
            </ul>
            <h4>การใช้อุปกรณ์นิรภัยของผู้ขับขี่</h4>
            <g:radioGroup name="passengerEquipment3_1" values="['หมวกนิรภัย', 'เข็มขัดนิรภัย','ไม่ใช้','ไม่ระบุ']"
                          labels="['หมวกนิรภัย', 'เข็มขัดนิรภัย','ไม่ใช้','ไม่ระบุ']">
                ${it.radio}<span><g:message code="${it.label}"/></span>
            </g:radioGroup>
            <h4>การบาดเจ็บ</h4>
            <ul>
                <g:radioGroup name="passengerInjury3_1" values="['ตายที่จุดเกิดเหตุ', 'ตายที่โรงพยาบาล','บาดเจ็บสาหัส','บาดเจ็บเล็กน้อย']"
                              labels="['ตายที่จุดเกิดเหตุ', 'ตายที่โรงพยาบาล','บาดเจ็บสาหัส','บาดเจ็บเล็กน้อย']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
        </div>

        <div class="boxB" style="height: 700px">
            <h4>ผู้โดยสาร คันที่3 คนที่2</h4>
            <h4>ตำเเหน่ง ที่นั่ง</h4>
            <ul>
                <g:radioGroup name="seatPosition3_2" values="['ซ้อนท้าย จยย.', 'ด้านหน้ารถยนต์', 'ด้านหลังรถยนต์']"
                              labels="['ซ้อนท้าย จยย.', 'ด้านหน้ารถยนต์', 'ด้านหลังรถยนต์']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
            <h4>อายุผู้โดยสาร</h4>
            <ul>
                <g:field type="text" name="passengerAge3_2" id="passengerAge"
                         placeholder="ระบุ" maxlength="50"/>
            </ul>
            <h4>เพศผู้โดยสาร</h4>
            <ul>
                <g:radioGroup name="passengerGender3_2" values="['ญ', 'ช']"
                              labels="['หญิง', 'ชาย']">
                    ${it.radio}<span><g:message code="${it.label}"/></span>
                </g:radioGroup>
            </ul>
            <h4>การใช้อุปกรณ์นิรภัยของผู้ขับขี่</h4>
            <g:radioGroup name="passengerEquipment3_2" values="['หมวกนิรภัย', 'เข็มขัดนิรภัย','ไม่ใช้','ไม่ระบุ']"
                          labels="['หมวกนิรภัย', 'เข็มขัดนิรภัย','ไม่ใช้','ไม่ระบุ']">
                ${it.radio}<span><g:message code="${it.label}"/></span>
            </g:radioGroup>
            <h4>การบาดเจ็บ</h4>
            <ul>
                <g:radioGroup name="passengerInjury3_2" values="['ตายที่จุดเกิดเหตุ', 'ตายที่โรงพยาบาล','บาดเจ็บสาหัส','บาดเจ็บเล็กน้อย']"
                              labels="['ตายที่จุดเกิดเหตุ', 'ตายที่โรงพยาบาล','บาดเจ็บสาหัส','บาดเจ็บเล็กน้อย']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
        </div>

        <div class="boxC" style="height: 700px">
            <h4>ผู้โดยสาร คันที่3 คนที่3</h4>
            <h4>ตำเเหน่ง ที่นั่ง</h4>
            <ul>
                <g:radioGroup name="seatPosition3_3" values="['ซ้อนท้าย จยย.', 'ด้านหน้ารถยนต์', 'ด้านหลังรถยนต์']"
                              labels="['ซ้อนท้าย จยย.', 'ด้านหน้ารถยนต์', 'ด้านหลังรถยนต์']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
            <h4>อายุผู้โดยสาร</h4>
            <ul>
                <g:field type="text" name="passengerAge3_3" id="passengerAge"
                         placeholder="ระบุ" maxlength="50"/>
            </ul>
            <h4>เพศผู้โดยสาร</h4>
            <ul>
                <g:radioGroup name="passengerGender3_3" values="['ญ', 'ช']"
                              labels="['หญิง', 'ชาย']">
                    ${it.radio}<span><g:message code="${it.label}"/></span>
                </g:radioGroup>
            </ul>
            <h4>การใช้อุปกรณ์นิรภัยของผู้ขับขี่</h4>
            <g:radioGroup name="passengerEquipment3_3" values="['หมวกนิรภัย', 'เข็มขัดนิรภัย','ไม่ใช้','ไม่ระบุ']"
                          labels="['หมวกนิรภัย', 'เข็มขัดนิรภัย','ไม่ใช้','ไม่ระบุ']">
                ${it.radio}<span><g:message code="${it.label}"/></span>
            </g:radioGroup>
            <h4>การบาดเจ็บ</h4>
            <ul>
                <g:radioGroup name="passengerInjury3_3" values="['ตายที่จุดเกิดเหตุ', 'ตายที่โรงพยาบาล','บาดเจ็บสาหัส','บาดเจ็บเล็กน้อย']"
                              labels="['ตายที่จุดเกิดเหตุ', 'ตายที่โรงพยาบาล','บาดเจ็บสาหัส','บาดเจ็บเล็กน้อย']">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
        </div>
    </div>
</div>

<div id="sec7" style="display:none">
    <div class="extra container">
        <div class="boxA" style="height: 700px">
            <h2 align="middle">Section มูลเหตุที่สันนิษฐาน</h2>
            <ul>
                <g:radioGroup name="reason" values="['ขับรถเร็วเกินอัตราที่กำหนด', 'มีการตัดหน้าระยะกระชั้นชิด', 'แซงรถอย่างผิดกฎหมาย'
                        ,'ขับรถไม่เปิดไฟ/ไม่ใช้แสงสว่างตามกำหนด','ไม่ให้สัญญาณชะลอ/เลี้ยว','ไม่ให้สัญญาณเข้าจอด หรือออกจากที่จอด','ไม่ให้สิทธิรถที่มาก่อนผ่านทาง เช่น ทางแยก'
                        ,'รถเสียไม่แสดงเครื่องหมายหรือสัญญาณไฟที่กำหนด'
                        ,'ฝ่าฝืนป้ายหยุดขณะออกจากทางร่วมแยก','ไม่ขับรถในช่องทางเดินรถซ้ายสุดในถนนที่มี 4 ช่องทาง'
                        ,'ฝ่าฝืนสัญญาณไฟ/เครื่องหมายจราจร','บรรทุกเกินอัตรา','ขับรถไม่ชำนาญ/ไม่เป็น','อุปกรณ์รถบกพร่อง'
                        ,'มีสิ่งกีดขวางบนถนน','เมาสุรา','หลับใน','0']"
                              labels="['ขับรถเร็วเกินอัตราที่กำหนด', 'มีการตัดหน้าระยะกระชั้นชิด', 'แซงรถอย่างผิดกฎหมาย'
                                      ,'ขับรถไม่เปิดไฟ/ไม่ใช้แสงสว่างตามกำหนด','ไม่ให้สัญญาณชะลอ/เลี้ยว','ไม่ให้สัญญาณเข้าจอด หรือออกจากที่จอด','ไม่ให้สิทธิรถที่มาก่อนผ่านทาง เช่น ทางแยก'
                                      ,'รถเสียไม่แสดงเครื่องหมายหรือสัญญาณไฟที่กำหนด'
                                      ,'ฝ่าฝืนป้ายหยุดขณะออกจากทางร่วมแยก','ไม่ขับรถในช่องทางเดินรถซ้ายสุดในถนนที่มี 4 ช่องทาง'
                                      ,'ฝ่าฝืนสัญญาณไฟ/เครื่องหมายจราจร','บรรทุกเกินอัตรา','ขับรถไม่ชำนาญ/ไม่เป็น','อุปกรณ์รถบกพร่อง'
                                      ,'มีสิ่งกีดขวางบนถนน','เมาสุรา','หลับใน','อื่นๆ']">
                    <li>${it.radio}<span><g:message code="${it.label}"/>
                    <g:if test="${it.label == 'อื่นๆ'}">
                        <g:field type="text" name="reasonOther" id="reasonOther"
                                 placeholder="ระบุ" maxlength="50"/>
                    </g:if>
                    </span></li>
                </g:radioGroup>

            </ul>
        </div>

        <div class="boxB" style="height: 700px">
            <h2 align="middle">Section รูปแบบการชน</h2>
            <ul>
                <g:radioGroup name="crashPattern" values="['ชนที่ทางเเยก', 'ชนที่จุดยูเทิร์น', 'ชนประสานงา'
                        ,'ชนท้าย','ชนด้านข้าง','พลิกคว่ำ/ตกถนน'
                        ,'ชนสิ่งกีดขวางข้างทาง','0']"
                              labels="['ชนที่ทางเเยก', 'ชนที่จุดยูเทิร์น', 'ชนประสานงา'
                                      ,'ชนท้าย','ชนด้านข้าง','พลิกคว่ำ/ตกถนน'
                                      ,'ชนสิ่งกีดขวางข้างทาง','อื่นๆ']">
                    <li>${it.radio}<span><g:message code="${it.label}"/>
                    <g:if test="${it.label == 'อื่นๆ'}">
                        <g:field type="text" name="crashPatternOther" id="crashPatternOther"
                                 placeholder="ระบุ" maxlength="50"/>
                    </g:if>
                    </span></li>
                </g:radioGroup>
            </ul>
        </div>

        <div class="boxC" style="height: 700px">
            <h2 align="middle">Section ความเสียหายจากอุบัติเหตุ</h2>
            <table>
                <tr>
                    <td colspan="1"></td>
                    <td colspan="2" align="center">ผู้ใหญ่</td><td colspan="2" align="center">เด็ก</td>
                </tr>
                <tr>
                    <td colspan="1"></td><td colspan="1" align="center">ช</td><td colspan="1" align="center">ญ</td><td
                        colspan="1" align="center">ช</td><td colspan="1" align="center">ญ</td>
                </tr>
                <tr>
                    <td>ตาย ณ จุดเกิดเหตุ</td>
                    <td>
                        <g:field type="text" name="adultMaleDeath" size="3" maxlength="3" value="0" onkeypress="return isNumber(event);" />
                    </td>
                    <td>
                        <g:field type="text" name="adultFemaleDeath" size="3" maxlength="3" value="0" onkeypress="return isNumber(event);" />
                    </td>
                    <td>
                        <g:field type="text" name="childMaleDeath" size="3" maxlength="3" value="0" onkeypress="return isNumber(event);" />
                    </td>
                    <td>
                        <g:field type="text" name="childFemaleDeath" size="3" maxlength="3" value="0" onkeypress="return isNumber(event);" />
                    </td>
                </tr>
                <tr>
                    <td>ตาย ณ โรงพยาบาล</td>
                    <td>
                        <g:field type="text" name="adultMaleHospital" size="3" maxlength="3" value="0" onkeypress="return isNumber(event);" />
                    </td>
                    <td>
                        <g:field type="text" name="adultFemaleHospital" size="3" maxlength="3" value="0" onkeypress="return isNumber(event);" />
                    </td>
                    <td>
                        <g:field type="text" name="childMaleHospital" size="3" maxlength="3" value="0" onkeypress="return isNumber(event);" />
                    </td>
                    <td>
                        <g:field type="text" name="childFemaleHospital" size="3" maxlength="3" value="0" onkeypress="return isNumber(event);" />
                    </td>
                </tr>
                <tr>
                    <td>บาดเจ็บสาหัส</td>
                    <td>
                        <g:field type="text" name="adultMaleSeriousInjure" size="3" maxlength="3" value="0" onkeypress="return isNumber(event);" />
                    </td>
                    <td>
                        <g:field type="text" name="adultFemaleSeriousInjure" size="3" maxlength="3" value="0" onkeypress="return isNumber(event);" />
                    </td>
                    <td>
                        <g:field type="text" name="childMaleSeriousInjure" size="3" maxlength="3" value="0" onkeypress="return isNumber(event);" />
                    </td>
                    <td>
                        <g:field type="text" name="childFemaleSeriousInjure" size="3" maxlength="3" value="0" onkeypress="return isNumber(event);" />
                    </td>
                </tr>
                <tr>
                    <td>บาดเจ็บเล็กน้อย</td>
                    <td>
                        <g:field type="text" name="adultMaleInjure" size="3" maxlength="3" value="0" onkeypress="return isNumber(event);" />
                    </td>
                    <td>
                        <g:field type="text" name="adultFemaleInjure" size="3" maxlength="3" value="0" onkeypress="return isNumber(event);" />
                    </td>
                    <td>
                        <g:field type="text" name="childMaleInjure" size="3" maxlength="3" value="0" onkeypress="return isNumber(event);" />
                    </td>
                    <td>
                        <g:field type="text" name="childFemaleInjure" size="3" maxlength="3" value="0" onkeypress="return isNumber(event);" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
</div>

<div id="sec9" style="display:none">
    <div class="extra container">
        <h2 align="middle">Section รายงานเหตุการณ์โดยย่อ</h2>
        <g:textArea name="eventDescription" rows="20" style="width:100%" />
    </div>
</div>
<div id="secAction" style="display:block;text-align: right">
    <div class="extra container">
        <g:submitButton name="update" value="Save" class="button2"/>
    </div>
</div>
</g:form>

</body>
</html>