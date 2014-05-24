import org.codehaus.groovy.grails.plugins.metadata.GrailsPlugin
import org.codehaus.groovy.grails.web.pages.GroovyPage
import org.codehaus.groovy.grails.web.taglib.*
import org.codehaus.groovy.grails.web.taglib.exceptions.GrailsTagException
import org.springframework.web.util.*
import grails.util.GrailsUtil

class gsp_road_Accident_Phase1_layoutsbangkokLayout_gsp extends GroovyPage {
public String getGroovyPageFileName() { "/WEB-INF/grails-app/views/layouts/bangkokLayout.gsp" }
public Object run() {
Writer out = getOut()
Writer expressionOut = getExpressionOut()
registerSitemeshPreprocessMode()
printHtmlPart(0)
printHtmlPart(1)
createTagBody(1, {->
printHtmlPart(2)
createTagBody(2, {->
createTagBody(3, {->
invokeTag('layoutTitle','g',10,['default':("Grails")],-1)
})
invokeTag('captureTitle','sitemesh',11,[:],3)
})
invokeTag('wrapTitleTag','sitemesh',11,[:],2)
printHtmlPart(3)
expressionOut.print(resource(dir: 'css', file: 'plaindisplaycss/default.css'))
printHtmlPart(4)
expressionOut.print(resource(dir: 'css', file: 'plaindisplaycss/fonts.css'))
printHtmlPart(5)
invokeTag('layoutHead','g',15,[:],-1)
printHtmlPart(6)
})
invokeTag('captureHead','sitemesh',15,[:],1)
printHtmlPart(0)
createTagBody(1, {->
printHtmlPart(7)
expressionOut.print(actionName=='index'?'current_page_item':'')
printHtmlPart(8)
expressionOut.print(createLink(controller :'main',action: 'index'))
printHtmlPart(9)
expressionOut.print(actionName=='create'?'current_page_item':'')
printHtmlPart(8)
expressionOut.print(createLink(controller :'main',action: 'create'))
printHtmlPart(10)
expressionOut.print(actionName=='edit'?'current_page_item':'')
printHtmlPart(8)
expressionOut.print(createLink(controller :'main',action: 'edit'))
printHtmlPart(11)
invokeTag('layoutBody','g',31,[:],-1)
printHtmlPart(12)
})
invokeTag('captureBody','sitemesh',38,[:],1)
printHtmlPart(13)
}
public static final Map JSP_TAGS = new HashMap()
protected void init() {
	this.jspTags = JSP_TAGS
}
public static final String CONTENT_TYPE = 'text/html;charset=UTF-8'
public static final long LAST_MODIFIED = 1400414388129L
public static final String EXPRESSION_CODEC = 'html'
public static final String STATIC_CODEC = 'none'
public static final String OUT_CODEC = 'html'
public static final String TAGLIB_CODEC = 'none'
}
