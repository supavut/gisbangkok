import org.codehaus.groovy.grails.orm.hibernate.cfg.GrailsAnnotationConfiguration

hibernate {
    cache.use_second_level_cache = true
    cache.use_query_cache = true
    cache.provider_class = 'net.sf.ehcache.hibernate.EhCacheProvider'
}

// environment specific settings
environments {
    development {

        dataSource {
            dbCreate = "create-drop"//"test" // one of 'create', 'create-drop','update'
            url = "jdbc:mysql://localhost/test?useUnicode=yes&characterEncoding=UTF-8"
            username = "root"
            password = ""
            pooled = true
            driverClassName = "com.mysql.jdbc.Driver"
            dialect = "org.hibernate.dialect.MySQL5InnoDBDialect"
        }
        hibernate {
            show_sql = true
        }
    }

    test {
        dataSource {
            dbCreate = "create-drop" // one of 'create', 'create-drop','update'
            url = "jdbc:mysql://localhost/TESTDBNAME?useUnicode=yes&characterEncoding=UTF-8"
            username = "test"
            password = "testpw"
        }
    }

    production {
        dataSource {
            driverClassName = "com.microsoft.sqlserver.jdbc.SQLServerDriver"
            dbCreate = "update"
            url = "jdbc:sqlserver://rutest2\\isoc_doc;databaseName=gisbangkok"
            username = "rtaphone"
            password = "rtaphone"
            pooled = true
            properties {
                maxActive = -1
                minEvictableIdleTimeMillis=1800000
                timeBetweenEvictionRunsMillis=1800000
                numTestsPerEvictionRun=3
                testOnBorrow=true
                testWhileIdle=true
                testOnReturn=true
                validationQuery="SELECT 1"
            }
        }
    }
}
