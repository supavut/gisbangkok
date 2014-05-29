<%--
  Created by IntelliJ IDEA.
  User: Home
  Date: 5/25/14
  Time: 10:48 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
<title>Create</title>
<meta name="layout" content="bangkokLayout"/>
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
    var mode = '0';
    var currentPoint;
    var newPoint = 1;
    function init() {
        map = new OpenLayers.Map("map-canvas");

        //restrict to focus only bangkok area
        //map.setOptions({restrictedExtent: new OpenLayers.Bounds(8, 44.5, 19, 50)});

        //create based layer
        var gmap = new OpenLayers.Layer.Google("Google Streets", {numZoomLevels: 20, sphericalMercator: true});


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
        //gmap.mapObject.addOverlay(new GStreetviewOverlay());


        //set map center
        var BangkokPosition = new OpenLayers.LonLat("11193299.296468", "1545835.5748853");
        map.setCenter(BangkokPosition, 12);
        currentPoint = BangkokPosition;
        //map.addControl(new OpenLayers.Control.LayerSwitcher());

        drawPoint("${accident.lat}","${accident.lon}");

        //add click event
        click = new OpenLayers.Control.Click();
        map.addControl(click);
        click.activate();

        createTime();
        checkExtraData();

        geocoder = new google.maps.Geocoder();
    }

    $(function () {
        $("#datepicker").datepicker({
            changeMonth: true,
            changeYear: true
        });
    });

    function toggleStreetView() {
        if (mode == 0) {
            var projWGS84 = new OpenLayers.Projection("EPSG:4326");
            var proj900913 = new OpenLayers.Projection("EPSG:900913");
            var point2
            if (newPoint == 1) {
                point2 = currentPoint.transform(proj900913, projWGS84);
                newPoint = 0;
            } else {
                point2 = currentPoint;
            }
            //console.log(point2.lat);
            //console.log(point2.lon);
            document.getElementById("map-canvas").style.display = 'none';
            document.getElementById("street-view").style.display = 'block';
            var fenway = new google.maps.LatLng(point2.lat, point2.lon);
            var panoOptions = {
                position: fenway,
                addressControlOptions: {
                    position: google.maps.ControlPosition.BOTTOM
                },
                linksControl: false,
                panControl: false,
                zoomControlOptions: {
                    style: google.maps.ZoomControlStyle.SMALL
                },
                enableCloseButton: false,
                visible: true
            };

            var panorama = new google.maps.StreetViewPanorama(
                    document.getElementById("street-view"), panoOptions);
            mode = 1;
        } else {
            document.getElementById("map-canvas").style.display = 'block';
            document.getElementById("street-view").style.display = 'none';
            mode = 0;
        }

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
        currentPoint = new OpenLayers.LonLat(parseFloat(lon), parseFloat(lat));
        newPoint = 1;
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
            if (parseInt("${accident.dateAccident.getMinutes()}") == i) {
                opt.selected = "selected";
            }
            select.appendChild(opt);
        }
        var hourMin = 00;
        var hourMax = 24;
        select = document.getElementById('hour');

        for (var i = hourMin; i <= hourMax; i++) {
            var opt = document.createElement('option');
            opt.value = i;
            opt.innerHTML = i;
            if (parseInt("${accident.dateAccident.getHours()}") == i) {
                opt.selected = "selected";
            }
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
            document.getElementById("sec9").style.display = 'none';
        } else {
            document.getElementById("sec2").style.display = 'block';
            document.getElementById("sec3").style.display = 'block';
            document.getElementById("sec4").style.display = 'block';
            document.getElementById("sec6").style.display = 'block';
            document.getElementById("sec7").style.display = 'block';
            document.getElementById("sec9").style.display = 'block';
        }
    }

</script>
</head>

<body onload="init();">

<g:form action="edit">
<g:field name="editAction" type="hidden" value="2" />
<div id="sec1" style="display:block">
    <div class="extra container">
        <h2 align="middle">Section ข้อมูลพื้นฐาน</h2>

        <div>
            <input id="address" value="" type="text" size="200" placeholder="ค้นหาสถานที่"/>
            <a href="" onclick="getAddress();
            return false" class="button2">Search</a>
            <br/>
        </div>

        <div id="all-map" style="position: relative;width: 100%;height: 500px;margin: 5px 0px;">
            <input type="button" value="Toggle Street View" style="position: absolute;z-index: 2;right: 0;"
                   onclick="toggleStreetView();"/>

            <div id="map-canvas">

            </div>

            <div id="street-view" style="height: 100%;display:none">
            </div>
        </div>

        <div class="fullbox">
            <table>

                <tr>
                    <td>
                        <h4>วันที่</h4>
                    </td>
                    <td colspan="2">
                        <g:field type="text" name="dateAccident" value="${accident.dateAccident.format("MM/dd/yyyy")}"
                                 required="required" id="datepicker"/>
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
                                             value="${accident.policeStation}"
                                             id="policeStation"/></td>
                </tr>
                <tr>
                    <td><h4>เล่มที่/หน้า</h4></td>
                    <td colspan="2"><g:field type="text" name="bookPage" required="required"
                                             value="${accident.bookPage}"
                                             id="bookPage"/></td>
                </tr>
                <tr>
                    <td><h4>เลขคดี</h4></td>
                    <td colspan="2"><g:field type="text" name="caseId" required="required"
                                             value="${accident.caseId}"
                                             id="caseId"/></td>
                </tr>
                <tr>
                    <td><h4>ชื่อถนน</h4></td>
                    <td colspan="2"><g:field type="text" name="roadName" required="required" value="${accident.roadName}" id="roadName"/></td>
                </tr>
                <tr>
                    <td colspan="3"><h4>พิกัดจีพีเอส</h4></td>
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
                    <td colspan="2"><g:checkBox name="isComplete" id="isComplete" onclick="checkExtraData()"
                                                value="1"
                                                checked="${accident.isComplete==1}"/></td>
                </tr>

            </table>
        </div>
    </div>
</div>

<div id="sec2" style="display:none">
    <div class="extra container">
        <h2 align="middle">Section ข้อมูลเส้นทาง</h2>
        <g:field type="hidden" name="accidentId"
                 value="${accident.id}"
                 id="accidentId" />
        <div class="boxA">
            <h4>บริเวณเฉพาะที่เกิดเหตุ</h4>
            <ul name="sec2">
                <g:radioGroup name="specificArea"
                              value="${accident.specificArea?accident.specificArea.id:''}"
                              values="${specificArea.id}"
                              labels="${specificArea.name}">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
            <h4>ลักษณะถนนขณะเกิดเหตุ</h4>
            <ul>
                <g:radioGroup name="roadAtCurrentTime" values="${roadAtCurrentTime.id}"
                              value="${accident.roadAtCurrentTime?accident.roadAtCurrentTime.id:''}"
                              labels="${roadAtCurrentTime.name}">
                    <li>${it.radio}<span><g:message code="${it.label}"/>
                    <g:if test="${it.label == 'อื่นๆ'}">
                        <g:field type="text" name="roadAtCurrentTimeDetail"
                                 value="${accident.roadAtCurrentTimeDetail}"
                                 id="roadAtCurrentTimeDetail"
                                 placeholder="ระบุ" maxlength="50"/>
                    </g:if>
                    </span></li>
                </g:radioGroup>
            </ul>
            <h4>จำนวนช่องจราจร</h4>
            <ul>
                <g:radioGroup name="roadLane"
                              value="${accident.roadLane?accident.roadLane.id:''}"
                              values="${roadLane.id}"
                              labels="${roadLane.name}">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
        </div>

        <div class="boxB">
            <h4>ทิศทาง</h4>
            <ul>
                <g:radioGroup name="roadDirection"
                              value="${accident.roadDirection?accident.roadDirection.id:''}"
                              values="${roadDirection.id}"
                              labels="${roadDirection.name}">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
            <h4>ประเภทเกาะกลาง</h4>
            <ul>
                <g:radioGroup name="islandType"
                              value="${accident.islandType?accident.islandType.id:''}"
                              values="${islandType.id}"
                              labels="${islandType.name}">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
            <h4>ชนิดผิวจราจร</h4>
            <ul>
                <g:radioGroup name="roadType"
                              value="${accident.roadType?accident.roadType.id:''}"
                              values="${roadType.id}"
                              labels="${roadType.name}">
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
                    <g:radioGroup name="horizontal"
                                  value="${accident.horizontal?accident.horizontal.id:''}"
                                  values="${horizontal.id}"
                                  labels="${horizontal.name}">
                        <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                    </g:radioGroup>
                </ul>
                <h4>ทางแยก</h4>
                <ul>
                    <g:radioGroup name="intersection"
                                  value="${accident.intersection?accident.intersection.id:''}"
                                  values="${intersection.id}"
                                  labels="${intersection.name}">
                        <li>${it.radio}<span><g:message code="${it.label}"/>
                        <g:if test="${it.label == 'อื่นๆ'}">
                            <g:field type="text" name="intersectionDetail"
                                     value="${accident.intersectionDetail}"
                                     id="intersectionDetail"
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

                <g:radioGroup name="uTurn"
                              value="${accident.uTurn?accident.uTurn.id:''}"
                              values="${uTurn.id}"
                              labels="${uTurn.name}">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>

        </div>

        <div class="boxC">
            <h4>บริเวณเฉพาะอื่นๆ</h4>
            <ul>
                <g:radioGroup name="roadTypeSpecial"
                              value="${accident.roadTypeSpecial?accident.roadTypeSpecial.id:''}"
                              values="${roadTypeSpecial.id}"
                              labels="${roadTypeSpecial.name}">
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
                <g:radioGroup name="accidentType"
                              value="${accident.accidentType?accident.accidentType.id:''}"
                              values="${accidentType.id}"
                              labels="${accidentType.name}">
                    <li>${it.radio}<span><g:message code="${it.label}"/>
                    <g:if test="${it.label == 'อื่นๆ'}">
                        <g:field type="text" name="accidentTypeDetail"
                                 value="${accident.accidentTypeDetail}"
                                 id="accidentTypeDetail"
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
                <g:radioGroup name="roadHumidity"
                              value="${accident.roadHumidity?accident.roadHumidity.id:''}"
                              values="${roadHumidity.id}"
                              labels="${roadHumidity.name}">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
            <h4>สภาพผิวทาง</h4>
            <ul>
                <g:radioGroup name="roadSurface"
                              value="${accident.roadSurface?accident.roadSurface.id:''}"
                              values="${roadSurface.id}"
                              labels="${roadSurface.name}">
                    <li>${it.radio}<span><g:message code="${it.label}"/>
                    <g:if test="${it.label == 'อื่นๆ'}">
                        <g:field type="text" name="roadSurfaceDetail"
                                 value="${accident.roadSurfaceDetail}"
                                 id="roadSurfaceDetail"
                                 placeholder="ระบุ" maxlength="50"/>
                    </g:if>
                    </span></li>
                </g:radioGroup>
            </ul>
            <h4>สภาพภูมิอากาศ</h4>
            <ul>
                <g:radioGroup name="weather"
                              value="${accident.weather?accident.weather.id:''}"
                              values="${weather.id}"
                              labels="${weather.name}">
                    <li>${it.radio}<span><g:message code="${it.label}"/>
                    <g:if test="${it.label == 'อื่นๆ'}">
                        <g:field type="text" name="weatherDetail"
                                 value="${accident.weatherDetail}"
                                 id="weatherDetail"
                                 placeholder="ระบุ" maxlength="50"/>
                    </g:if>
                    </span></li>
                </g:radioGroup>
            </ul>

            <h4>แสงสว่าง</h4>
            <ul>
                <g:radioGroup name="light"
                              value="${accident.light?accident.light.id:''}"
                              values="${light.id}"
                              labels="${light.name}">
                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                </g:radioGroup>
            </ul>
        </div>

        <div class="boxC" style="height: 700px">
        </div>
    </div>
</div>

<div id="sec6" style="display:none">
<div id="contentSec6" class="extra container">
<h2 align="middle">Section ข้อมูลเกี่ยวกับผู้ขับขี่หรือผู้ใช้ถนน</h2>
<script type="text/javascript">
    var masterElement;
    var masterElementPassenger;
    var personCount = 1;
    $(document).ready(function () {
        masterElement = $("#person").clone();
        masterElementPassenger = $("#passenger").clone();
        personCount = parseInt($('#countPerson').val());
        $("#person").remove();
        <g:if test="${accident.persons?accident.persons.size()==0:'false'}">
            addPerson();
        </g:if>
    });

    function addPerson() {
        personCount = personCount + 1;
        $('#countPerson').val(personCount);
        var $selectElement = masterElement.clone();
        $selectElement.find('.personNumText').html(personCount);
        $selectElement.find('#countPassenger_1').attr('name', "countPassenger_" + personCount);
        $selectElement.find('#countPassenger_1').attr('id', "countPassenger_" + personCount);
        $selectElement.find('#allPassenger_1').attr('id', "allPassenger_" + personCount);
        $selectElement.find('#addPassenger').attr('onclick', "addPassengerElement(" + personCount + ")");

        $selectElement.find('#carType').attr('name', "carType_" + personCount);

        $selectElement.find('#personDrivingLicense').attr('name', "personDrivingLicense_" + personCount);
        $selectElement.find('#countPassenger_1').attr('name', "countPassenger_" + personCount);
        $selectElement.find('#carRegistration').attr('name', "carRegistration_" + personCount);


        $selectElement.find('#carBrand').attr('name', "carBrand_" + personCount)
        $selectElement.find('#name').attr('name', "name_" + personCount)
        $selectElement.find('#lastName').attr('name', "lastName_" + personCount)
        $selectElement.find('#identificationCard').attr('name', "identificationCard_" + personCount)
        $selectElement.find('#age').attr('name', "age_" + personCount)

        $selectElement.find('#personDrivingLicense').attr('name', "personDrivingLicense_" + personCount);
        $selectElement.find('#personGender').attr('name', "personGender_" + personCount);
        $selectElement.find('#personEquipment').attr('name', "personEquipment_" + personCount);
        $selectElement.find('#personDrug').attr('name', "personDrug_" + personCount);
        $selectElement.find('#personInjury').attr('name', "personInjury_" + personCount);
        $selectElement.find('#personId').attr('name', "personId_" + personCount);


        $selectElement.find('#seatPosition').attr('name', "seatPosition_" + personCount + "_1");
        $selectElement.find('#passengerAge').attr('name', "passengerAge_" + personCount + "_1");
        $selectElement.find('#passengerGender').attr('name', "passengerGender_" + personCount + "_1");
        $selectElement.find('#passengerEquipment').attr('name', "passengerEquipment" + personCount + "_1");
        $selectElement.find('#passengerInjury').attr('name', "passengerInjury" + personCount + "_1");
        $selectElement.find('#passengerId').attr('name', "passengerId_" + personCount + "_1");

        $selectElement.appendTo('#contentSec6');
    }
    function addPassengerElement(personId) {
        $('#countPassenger_' + personId).val(parseInt($('#countPassenger_' + personId).val()) + 1);
        var passengerNum = $('#countPassenger_' + personId).val();
        var $selectElement = masterElementPassenger.clone();
        $selectElement.find('.personNumText').html(personId);
        $selectElement.find('.passengerNumText').html(passengerNum);


        $selectElement.find('#seatPosition').attr('name', "seatPosition_" + personId + "_" + passengerNum);
        $selectElement.find('#passengerId').attr('name', "passengerId_" + personId + "_" + passengerNum);
        $selectElement.find('#passengerAge').attr('name', "passengerAge_" + personId + "_" + passengerNum);
        $selectElement.find('#passengerGender').attr('name', "passengerGender_" + personId + "_" + passengerNum);
        $selectElement.find('#passengerEquipment').attr('name', "passengerEquipment" + personId + "_" + passengerNum);
        $selectElement.find('#passengerInjury').attr('name', "passengerInjury" + personId + "_" + passengerNum);


        $selectElement.appendTo('#allPassenger_' + personId);
        //alert($('#countPassenger_'+personId).val());
    }

</script>
<g:field type="hidden" name="countPerson" id="countPerson" value="${accident.persons?accident.persons.size():0}"/>
<input type="button" value="AddPerson" onclick="addPerson()"/>
<g:set var="countPerson" value="${1}"  />
<g:each in="${accident.persons}" var="person">
    <div class="fullbox">
        <div style="padding: 10px">
            <table width="90%" align="center">
                <tr>
                    <td colspan="2"><h4>ประเภทผู้ใช้ถนน คันที่ <span class="personNumText">${countPerson}</span></h4>
                        <g:field type="hidden" name="personId_${countPerson}" id="personId" value="${person.id}"/>
                    </td>
                </tr>
                <tr>
                    <td width="40%">
                        <ul>
                            <g:radioGroup name="carType_${countPerson}"
                                          value="${person.carType?person.carType.id:''}"
                                          values="${carType.id}" id="carType"
                                          labels="${carType.name}">
                                <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                            </g:radioGroup>
                        </ul>

                    </td>
                    <td>
                        <g:field type="hidden" name="countPassenger_${countPerson}" id="countPassenger_${countPerson}" value="${person.passengers?person.passengers.size():1}"/>
                        <table width="100%">
                            <tr>
                                <td width="35%"></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td><h4>หมายเลขทะเบียนรถ</h4></td>
                                <td><g:field type="text" name="carRegistration_${countPerson}"
                                             value="${person.carRegistration}"
                                             id="carRegistration" size="8"
                                             maxlength="8"/>
                                </td>
                            </tr>
                            <tr>
                                <td><h4>ยี่ห้อรถ</h4></td>
                                <td><g:field type="text" name="carBrand_${countPerson}" id="carBrand" value="${person.carBrand}" placeholder="ระบุ"
                                             size="20" maxlength="20"/></td>
                            </tr>
                            <tr>
                                <td><h4>ชื่อผู้ขับขี่หรือผู้ใช้ถนน</h4></td>
                                <td><g:field type="text" name="name_${countPerson}" id="name" value="${person.name}" maxlength="50"/></td>
                            </tr>
                            <tr>
                                <td><h4>นามสกุลผู้ขับขี่หรือผู้ใช้ถนน</h4></td>
                                <td><g:field type="text" name="lastName_${countPerson}" id="lastName" value="${person.lastName}" maxlength="50"/></td>
                            </tr>
                            <tr>
                                <td><h4>หมายเลขประจำตัวประชาชน</h4></td>
                                <td><g:field type="text" name="identificationCard_${countPerson}" id="identificationCard" value="${person.identificationCard}"
                                             placeholder="ระบุ" size="20" maxlength="13"
                                             onkeypress="return isNumber(event);"/></td>
                            </tr>
                            <tr>
                                <td><h4>ใบขับขี่ของผู้ขับขี่</h4></td>
                                <td>
                                    <g:radioGroup name="personDrivingLicense_${countPerson}"
                                                  id="personDrivingLicense"
                                                  value="${person.drivingLicense?person.drivingLicense.id:''}"
                                                  values="${personDrivingLicense.id}"
                                                  labels="${personDrivingLicense.name}">
                                        ${it.radio}<span><g:message code="${it.label}"/></span>
                                    </g:radioGroup></td>
                            </tr>
                            <tr>
                                <td><h4>อายุผู้ขับขี่หรือผู้ใช้ถนน (ปี)</h4></td>
                                <td><g:field type="text" name="age_${countPerson}" id="age"
                                             value="${person.age}"
                                             placeholder="ระบุ" size="2"
                                             maxlength="2" onkeypress="return isNumber(event);"/></td>
                            </tr>
                            <tr>
                                <td><h4>เพศผู้ขับขี่หรือผู้ใช้ถนน</h4></td>
                                <td><g:radioGroup name="personGender_${countPerson}"
                                                  id="personGender"
                                                  value="${person.gender?person.gender.id:''}"
                                                  values="${personGender.id}"
                                                  labels="${personGender.name}">
                                    ${it.radio}<span><g:message code="${it.label}"/></span>
                                </g:radioGroup></td>
                            </tr>
                            <tr>
                                <td><h4>การใช้อุปกรณ์นิรภัยของผู้ขับขี่</h4></td>
                                <td><g:radioGroup name="personEquipment_${countPerson}"
                                                  id="personEquipment"
                                                  value="${person.equipment?person.equipment.id:''}"
                                                  values="${personEquipment.id}"
                                                  labels="${personEquipment.name}">
                                    ${it.radio}<span><g:message code="${it.label}"/></span>
                                </g:radioGroup></td>
                            </tr>
                            <tr>
                                <td><h4>การเสพของมึนเมาหรือยา</h4></td>
                                <td><g:radioGroup name="personDrug_${countPerson}"
                                                  id="personDrug"
                                                  value="${person.drug?person.drug.id:''}"
                                                  values="${personDrug.id}"
                                                  labels="${personDrug.name}">
                                    ${it.radio}<span><g:message code="${it.label}"/></span>
                                </g:radioGroup></td>
                            </tr>
                            <tr>
                                <td><h4>การบาดเจ็บ</h4></td>
                                <td><ul>
                                    <g:radioGroup name="personInjury_${countPerson}"
                                                  id="personInjury"
                                                  value="${person.injury?person.injury.id:''}"
                                                  values="${personInjury.id}"
                                                  labels="${personInjury.name}">
                                        <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                                    </g:radioGroup>
                                </ul></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <table width="100%" id="allPassenger_${countPerson}">
                            <tr>
                                <td colspan="2"><hr/></td>
                            </tr>
                            <tr><td colspan="2"><h2 align="middle">Section ข้อมูลเกี่ยวกับผู้โดยสาร/ตำเเหน่งที่นั่ง</h2>
                            </td></tr>
                            <tr>
                                <td colspan="2"><input type="button" value="Add Passenger"
                                                       onclick="addPassengerElement(${countPerson})"/></td>
                            </tr>
                            <g:set var="countPassenger" value="${1}" />
                            <g:each in="${person.passengers}" var="passenger">
                                <tr>
                                    <td colspan="2">
                                        <table width="100%">
                                            <tr>
                                                <td colspan="2"><h4>ผู้โดยสาร คันที่<span
                                                        class="personNumText">${countPerson}</span> คนที่ <span
                                                        class="passengerNumText">${countPassenger}</span></h4>
                                                    <g:field type="hidden" name="passengerId_${countPerson}_${countPassenger}" id="passengerId" value="${passenger.id}"/>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td width="35%"><h4>ตำเเหน่ง ที่นั่ง</h4></td>
                                                <td><ul>
                                                    <g:radioGroup name="seatPosition_${countPerson}_${countPassenger}" id="seatPosition"
                                                                  value="${passenger.seatPosition?passenger.seatPosition.id:''}"
                                                                  values="${seatPosition.id}"
                                                                  labels="${seatPosition.name}">
                                                        <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                                                    </g:radioGroup>
                                                </ul></td>
                                            </tr>
                                            <tr>
                                                <td><h4>อายุผู้โดยสาร</h4></td>
                                                <td><ul>
                                                    <g:field type="text" name="passengerAge_${countPerson}_${countPassenger}"
                                                             value="${passenger.passengerAge}"
                                                             id="passengerAge"
                                                             placeholder="ระบุ" maxlength="50"/>
                                                </ul></td>
                                            </tr>
                                            <tr>
                                                <td><h4>เพศผู้โดยสาร</h4></td>
                                                <td><ul>
                                                    <g:radioGroup name="passengerGender_${countPerson}_${countPassenger}" id="passengerGender"
                                                                  value="${passenger.passengerGender?passenger.passengerGender.id:''}"
                                                                  values="${passengerGender.id}"
                                                                  labels="${passengerGender.name}">
                                                        ${it.radio}<span><g:message code="${it.label}"/></span>
                                                    </g:radioGroup>
                                                </ul></td>
                                            </tr>
                                            <tr>
                                                <td><h4>การใช้อุปกรณ์นิรภัยของผู้ขับขี่</h4></td>
                                                <td><g:radioGroup name="passengerEquipment_${countPerson}_${countPassenger}" id="passengerEquipment"
                                                                  value="${passenger.passengerEquipment?passenger.passengerEquipment.id:''}"
                                                                  values="${passengerEquipment.id}"
                                                                  labels="${passengerEquipment.name}">
                                                    ${it.radio}<span><g:message code="${it.label}"/></span>
                                                </g:radioGroup></td>
                                            </tr>
                                            <tr>
                                                <td><h4>การบาดเจ็บ</h4></td>
                                                <td>
                                                    <ul>
                                                        <g:radioGroup name="passengerInjury_${countPerson}_${countPassenger}"
                                                                      id="passengerInjury"
                                                                      value="${passenger.passengerInjury?passenger.passengerInjury.id:''}"
                                                                      values="${passengerInjury.id}"
                                                                      labels="${passengerInjury.name}">
                                                            <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                                                        </g:radioGroup>
                                                    </ul></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <g:set var="countPassenger" value="${countPassenger+1}" />
                            </g:each>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </div>
<g:set var="countPerson" value="${countPerson+1}" />
</g:each>
<div id="person" class="fullbox">
    <div style="padding: 10px">
        <table width="90%" align="center">
            <tr>
                <td colspan="2"><h4>ประเภทผู้ใช้ถนน คันที่ <span class="personNumText">1</span></h4>
                    <g:field type="hidden" name="personId_1" id="personId" value="0"/></td>
            </tr>
            <tr>
                <td width="40%">
                    <ul>
                        <g:radioGroup name="carType_1" values="${carType.id}" id="carType"
                                      labels="${carType.name}">
                            <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                        </g:radioGroup>
                    </ul>

                </td>
                <td>

                    <g:field type="hidden" name="countPassenger_1" id="countPassenger_1" value="1"/>
                    <table width="100%">
                        <tr>
                            <td width="35%"></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td><h4>หมายเลขทะเบียนรถ</h4></td>
                            <td><g:field type="text" name="carRegistration_1" id="carRegistration" size="8"
                                         maxlength="8"/>
                            </td>
                        </tr>
                        <tr>
                            <td><h4>ยี่ห้อรถ</h4></td>
                            <td><g:field type="text" name="carBrand_1" id="carBrand" value="" placeholder="ระบุ"
                                         size="20" maxlength="20"/></td>
                        </tr>
                        <tr>
                            <td><h4>ชื่อผู้ขับขี่หรือผู้ใช้ถนน</h4></td>
                            <td><g:field type="text" name="name_1" id="name" value="" maxlength="50"/></td>
                        </tr>
                        <tr>
                            <td><h4>นามสกุลผู้ขับขี่หรือผู้ใช้ถนน</h4></td>
                            <td><g:field type="text" name="lastName_1" id="lastName" value="" maxlength="50"/></td>
                        </tr>
                        <tr>
                            <td><h4>หมายเลขประจำตัวประชาชน</h4></td>
                            <td><g:field type="text" name="identificationCard_1" id="identificationCard" value=""
                                         placeholder="ระบุ" size="20" maxlength="13"
                                         onkeypress="return isNumber(event);"/></td>
                        </tr>
                        <tr>
                            <td><h4>ใบขับขี่ของผู้ขับขี่</h4></td>
                            <td>
                                <g:radioGroup name="personDrivingLicense_1"
                                              id="personDrivingLicense"
                                              values="${personDrivingLicense.id}"
                                              labels="${personDrivingLicense.name}">
                                    ${it.radio}<span><g:message code="${it.label}"/></span>
                                </g:radioGroup></td>
                        </tr>
                        <tr>
                            <td><h4>อายุผู้ขับขี่หรือผู้ใช้ถนน (ปี)</h4></td>
                            <td><g:field type="text" name="age_1" id="age" value="" placeholder="ระบุ" size="2"
                                         maxlength="2" onkeypress="return isNumber(event);"/></td>
                        </tr>
                        <tr>
                            <td><h4>เพศผู้ขับขี่หรือผู้ใช้ถนน</h4></td>
                            <td><g:radioGroup name="personGender_1"
                                              id="personGender"
                                              values="${personGender.id}"
                                              labels="${personGender.name}">
                                ${it.radio}<span><g:message code="${it.label}"/></span>
                            </g:radioGroup></td>
                        </tr>
                        <tr>
                            <td><h4>การใช้อุปกรณ์นิรภัยของผู้ขับขี่</h4></td>
                            <td><g:radioGroup name="personEquipment_1"
                                              id="personEquipment"
                                              values="${personEquipment.id}"
                                              labels="${personEquipment.name}">
                                ${it.radio}<span><g:message code="${it.label}"/></span>
                            </g:radioGroup></td>
                        </tr>
                        <tr>
                            <td><h4>การเสพของมึนเมาหรือยา</h4></td>
                            <td><g:radioGroup name="personDrug_1"
                                              id="personDrug"
                                              values="${personDrug.id}"
                                              labels="${personDrug.name}">
                                ${it.radio}<span><g:message code="${it.label}"/></span>
                            </g:radioGroup></td>
                        </tr>
                        <tr>
                            <td><h4>การบาดเจ็บ</h4></td>
                            <td><ul>
                                <g:radioGroup name="personInjury_1"
                                              id="personInjury"
                                              values="${personInjury.id}"
                                              labels="${personInjury.name}">
                                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                                </g:radioGroup>
                            </ul></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <table width="100%" id="allPassenger_1">
                        <tr>
                            <td colspan="2"><hr/></td>
                        </tr>
                        <tr><td colspan="2"><h2 align="middle">Section ข้อมูลเกี่ยวกับผู้โดยสาร/ตำเเหน่งที่นั่ง</h2>
                        </td></tr>
                        <tr>
                            <td colspan="2">

                                <input type="button" value="Add Passenger" id="addPassenger"
                                                   onclick="addPassengerElement(1)"/></td>
                        </tr>
                        <tr id="passenger">
                            <td colspan="2">
                                <table width="100%">
                                    <tr>
                                        <td colspan="2"><h4>ผู้โดยสาร คันที่<span
                                                class="personNumText">1</span> คนที่ <span
                                                class="passengerNumText">1</span></h4>
                                            <g:field type="hidden" name="passengerId_1" id="passengerId" value="0"/></td>
                                    </tr>
                                    <tr>
                                        <td width="35%"><h4>ตำเเหน่ง ที่นั่ง</h4></td>
                                        <td><ul>
                                            <g:radioGroup name="seatPosition_1_1" id="seatPosition"
                                                          values="${seatPosition.id}"
                                                          labels="${seatPosition.name}">
                                                <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                                            </g:radioGroup>
                                        </ul></td>
                                    </tr>
                                    <tr>
                                        <td><h4>อายุผู้โดยสาร</h4></td>
                                        <td><ul>
                                            <g:field type="text" name="passengerAge_1_1" id="passengerAge"
                                                     placeholder="ระบุ" maxlength="50"/>
                                        </ul></td>
                                    </tr>
                                    <tr>
                                        <td><h4>เพศผู้โดยสาร</h4></td>
                                        <td><ul>
                                            <g:radioGroup name="passengerGender_1_1" id="passengerGender"
                                                          values="${passengerGender.id}"
                                                          labels="${passengerGender.name}">
                                                ${it.radio}<span><g:message code="${it.label}"/></span>
                                            </g:radioGroup>
                                        </ul></td>
                                    </tr>
                                    <tr>
                                        <td><h4>การใช้อุปกรณ์นิรภัยของผู้ขับขี่</h4></td>
                                        <td><g:radioGroup name="passengerEquipment_1_1" id="passengerEquipment"
                                                          values="${passengerEquipment.id}"
                                                          labels="${passengerEquipment.name}">
                                            ${it.radio}<span><g:message code="${it.label}"/></span>
                                        </g:radioGroup></td>
                                    </tr>
                                    <tr>
                                        <td><h4>การบาดเจ็บ</h4></td>
                                        <td>
                                            <ul>
                                                <g:radioGroup name="passengerInjury_1_1"
                                                              id="passengerInjury"
                                                              values="${passengerInjury.id}"
                                                              labels="${passengerInjury.name}">
                                                    <li>${it.radio}<span><g:message code="${it.label}"/></span></li>
                                                </g:radioGroup>
                                            </ul></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </div>
</div>
</div>
</div>

<div id="sec7" style="display:none">
    <div class="extra container">
        <div class="boxA" style="height: 700px">
            <h2 align="middle">Section มูลเหตุที่สันนิษฐาน</h2>
            <ul>
                <g:radioGroup name="reason"
                              value="${accident.reason?accident.reason.id:''}"
                              values="${reason.id}"
                              labels="${reason.name}">
                    <li>${it.radio}<span><g:message code="${it.label}"/>
                    <g:if test="${it.label == 'อื่นๆ'}">
                        <g:field type="text" name="reasonDetail"
                                 value="${accident.reasonDetail}"
                                 id="reasonDetail"
                                 placeholder="ระบุ" maxlength="50"/>
                    </g:if>
                    </span></li>
                </g:radioGroup>

            </ul>
        </div>

        <div class="boxB" style="height: 700px">
            <h2 align="middle">Section รูปแบบการชน</h2>
            <ul>
                <g:radioGroup name="crashPattern"
                              value="${accident.crashPattern?accident.crashPattern.id:''}"
                              values="${crashPattern.id}"
                              labels="${crashPattern.name}">
                    <li>${it.radio}<span><g:message code="${it.label}"/>
                    <g:if test="${it.label == 'อื่นๆ'}">
                        <g:field type="text" name="crashPatternDetail"
                                 value="${accident.crashPatternDetail}"
                                 id="crashPatternDetail"
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
                        <g:field type="text" name="adultMaleDeath" size="3" maxlength="3" value="${accident.damageCost?accident.damageCost.adultMaleDeath:'0'}"
                                 onkeypress="return isNumber(event);"/>
                    </td>
                    <td>
                        <g:field type="text" name="adultFemaleDeath" size="3" maxlength="3" value="${accident.damageCost?accident.damageCost.adultFemaleDeath:'0'}"
                                 onkeypress="return isNumber(event);"/>
                    </td>
                    <td>
                        <g:field type="text" name="childMaleDeath" size="3" maxlength="3" value="${accident.damageCost?accident.damageCost.adultFemaleDeath:'0'}"
                                 onkeypress="return isNumber(event);"/>
                    </td>
                    <td>
                        <g:field type="text" name="childFemaleDeath" size="3" maxlength="3" value="${accident.damageCost?accident.damageCost.adultFemaleDeath:'0'}"
                                 onkeypress="return isNumber(event);"/>
                    </td>
                </tr>
                <tr>
                    <td>ตาย ณ โรงพยาบาล</td>
                    <td>
                        <g:field type="text" name="adultMaleHospital" size="3" maxlength="3" value="${accident.damageCost?accident.damageCost.adultMaleHospital:'0'}"
                                 onkeypress="return isNumber(event);"/>
                    </td>
                    <td>
                        <g:field type="text" name="adultFemaleHospital" size="3" maxlength="3" value="${accident.damageCost?accident.damageCost.adultFemaleHospital:'0'}"
                                 onkeypress="return isNumber(event);"/>
                    </td>
                    <td>
                        <g:field type="text" name="childMaleHospital" size="3" maxlength="3" value="${accident.damageCost?accident.damageCost.childMaleHospital:'0'}"
                                 onkeypress="return isNumber(event);"/>
                    </td>
                    <td>
                        <g:field type="text" name="childFemaleHospital" size="3" maxlength="3" value="${accident.damageCost?accident.damageCost.childFemaleHospital:'0'}"
                                 onkeypress="return isNumber(event);"/>
                    </td>
                </tr>
                <tr>
                    <td>บาดเจ็บสาหัส</td>
                    <td>
                        <g:field type="text" name="adultMaleSeriousInjure" size="3" maxlength="3" value="${accident.damageCost?accident.damageCost.adultMaleSeriousInjure:'0'}"
                                 onkeypress="return isNumber(event);"/>
                    </td>
                    <td>
                        <g:field type="text" name="adultFemaleSeriousInjure" size="3" maxlength="3" value="${accident.damageCost?accident.damageCost.adultFemaleSeriousInjure:'0'}"
                                 onkeypress="return isNumber(event);"/>
                    </td>
                    <td>
                        <g:field type="text" name="childMaleSeriousInjure" size="3" maxlength="3" value="${accident.damageCost?accident.damageCost.childMaleSeriousInjure:'0'}"
                                 onkeypress="return isNumber(event);"/>
                    </td>
                    <td>
                        <g:field type="text" name="childFemaleSeriousInjure" size="3" maxlength="3" value="${accident.damageCost?accident.damageCost.childFemaleSeriousInjure:'0'}"
                                 onkeypress="return isNumber(event);"/>
                    </td>
                </tr>
                <tr>
                    <td>บาดเจ็บเล็กน้อย</td>
                    <td>
                        <g:field type="text" name="adultMaleInjure" size="3" maxlength="3" value="${accident.damageCost?accident.damageCost.adultMaleInjure:'0'}"
                                 onkeypress="return isNumber(event);"/>
                    </td>
                    <td>
                        <g:field type="text" name="adultFemaleInjure" size="3" maxlength="3" value="${accident.damageCost?accident.damageCost.adultFemaleInjure:'0'}"
                                 onkeypress="return isNumber(event);"/>
                    </td>
                    <td>
                        <g:field type="text" name="childMaleInjure" size="3" maxlength="3" value="${accident.damageCost?accident.damageCost.childMaleInjure:'0'}"
                                 onkeypress="return isNumber(event);"/>
                    </td>
                    <td>
                        <g:field type="text" name="childFemaleInjure" size="3" maxlength="3" value="${accident.damageCost?accident.damageCost.childFemaleInjure:'0'}"
                                 onkeypress="return isNumber(event);"/>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</div>

<div id="sec9" style="display:none">
    <div class="extra container">
        <h2 align="middle">Section รายงานเหตุการณ์โดยย่อ</h2>
        <g:textArea name="eventDescription" rows="20" style="width:100%" value="${accident.eventDescription}"/>
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