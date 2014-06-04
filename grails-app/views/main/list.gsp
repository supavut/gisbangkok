<%--
  Created by IntelliJ IDEA.
  User: yana_yanee
  Date: 4/12/14 AD
  Time: 15:59
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Edit</title>
    <meta name="layout" content="bangkokLayout"/>
    <style>
    table, td, th
    {
        font-size:13px;
        border:1px green;
    }
    td input {
        border:0px
    }
    table
    {
        width:100%;
    }
    th
    {
        background-color:#009E2D;
        color:white;
        font-family: 'Varela', sans-serif;
    }
    </style>

    <link rel='stylesheet' href="${resource(plugin: 'jquery-datatables', file: 'css/demo_table.css')}" type="text/css"/>

</head>

<body>
    <div id="page" class="container">
        <div style="float:left"><input class="button2" type="button" value="Select All" onclick="SelectAll();"/></div>
        <div style="float:right"><input class="button2" type="button" value="Delete Checked items" onclick="Delete();"/></div>
        <table id="dataTablesList">
            <tr>
                <th>Delete</th>
                <th>ที่</th>
                <th>ชื่อสถานีตำรวจนครบาล</th>
                <th>เล่มที่/หน้า</th>
                <th>เลขคดี</th>
                <th>วันที่เกิดเหตุ</th>
                <th>ละติจูด</th>
                <th>ลองติจูด</th>
                <th>#</th>
            </tr>
            <!-- Loop -->
            <g:each in="${accidents}" var="accident">
                <tr>
                    <td><input type="checkbox" name="record1"></td>
                    <td>${accident.id}</td>
                    <td>${accident.policeStation}</td>
                    <td>${accident.bookPage}</td>
                    <td>${accident.caseId}</td>
                    <td>${accident.dateAccident}</td>
                    <td>${accident.lat}</td>
                    <td>${accident.lon}</td>
                    <td>
                        <a href="${createLink(controller :'main',action: 'edit',params: [editView:1,selectId:accident.id])}" >EDIT MAP</a> |
                        <a href="${createLink(controller :'main',action: 'edit',params: [editView:2,selectId:accident.id])}" >EDIT</a>
                    </td>
                </tr>

            </g:each>

        </table>
    </div>

<g:javascript plugin="jquery-datatables" src="jquery.dataTables.js"/>
<script type="text/javascript">

</script>
</body>
</html>