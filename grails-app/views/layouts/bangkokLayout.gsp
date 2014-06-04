<%--
  Created by IntelliJ IDEA.
  User: Home
  Date: 5/18/14
  Time: 6:14 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title><g:layoutTitle default="Grails"/></title>
    <!-- MAin Theme -->
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'css', file: 'plaindisplaycss/default.css')}" />
    <link rel="stylesheet" type="text/css" href="${resource(dir: 'css', file: 'plaindisplaycss/fonts.css')}" />
    <link href="http://fonts.googleapis.com/css?family=Varela" rel="stylesheet" />

    <!-- jQuery -->
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'css', file: 'custom-theme/jquery-ui-1.10.4.custom.css')}"/>
    <g:javascript src="jquery-ui-1.10.4/js/jquery-1.10.2.js"/>
    <g:javascript src="jquery-ui-1.10.4/js/jquery-ui-1.10.4.js"/>

    <g:layoutHead/>
</head>

<body>
<div id="wrapper">
    <div id="header-wrapper">
        <div id="header" class="container">
            <div id="logo">
                <h1><a href="#">Bangkok Road Accident  </a></h1>
            </div>
            <div id="menu">
                <ul>
                    <li class="${actionName=='index'?'current_page_item':''}"><a href="${createLink(controller :'main',action: 'index')}" accesskey="1" title="">Home</a></li>
                    <li class="${actionName=='create'?'current_page_item':''}"><a href="${createLink(controller :'main',action: 'create')}" accesskey="2" title="">Create data</a></li>
                    <li class="${actionName=='list'?'current_page_item':''}"><a href="${createLink(controller :'main',action: 'list')}" accesskey="3" title="">List data</a></li>
                </ul>
            </div>
        </div>
    </div>
    <g:layoutBody/>
</div>
<div id="copyright" class="container">
    <p>Copyright (c) 2014 Sitename.com. All rights reserved. | Photos by <a href="http://fotogrph.com/">Fotogrph</a> | Design by <a href="http://www.freecsstemplates.org/" rel="nofollow">FreeCSSTemplates.org</a>.</p>
</div>
</body>
</html>
