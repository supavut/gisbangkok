<%--
  Created by IntelliJ IDEA.
  User: Home
  Date: 5/25/14
  Time: 1:01 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
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

      /*  var p1 = new OpenLayers.Geometry.Point(parseFloat(${accident.lon}), parseFloat(${accident.lat}));
        var point = new OpenLayers.Feature.Vector(p1);
        vector.addFeatures(point);*/
        drawPoint(${accident.lat},${accident.lon});
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
</script>
</head>

<body onload="init();">

<g:form action="edit">


    <div id="sec1" style="display:block">
        <div class="extra container">
            <h2 align="middle">Section ข้อมูลพื้นฐาน</h2>
            <g:field name="accidentId" type="hidden" value="${accident.id}" />
            <g:field name="editAction" type="hidden" value="1" />
            <div class="tbox1">
                <table>
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
                </table>
            </div>

            <div class="tbox2">
                <div id="map-canvas"></div>
            </div>
        </div>
    </div>
    <div id="secAction" style="display:block;text-align: right">
        <div class="extra container">
            <g:submitButton name="update" value="Update" class="button2"/>
        </div>
    </div>
</g:form>

<body>

</body>
</html>