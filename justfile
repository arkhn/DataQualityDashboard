install:
    Rscript -e "install.packages(c('remotes', 'checkmate', 'rJava', 'rlang', 'jsonlite', 'languageserver', 'devtools', 'shinydashboard', 'readr', 'DBI', 'urltools', 'bit64', 'dbplyr', 'plyr', 'ParallelLogger', 'dotenv'))"

[working-directory: '../SqlRender']
r-sqlrender:
    R CMD INSTALL .

[working-directory: '../DatabaseConnector']
r-databaseconnector:
    R CMD INSTALL .

[working-directory: '../DataQualityDashboard']
r-dataqualitydashboard:
    R CMD INSTALL .

r-all: r-sqlrender r-databaseconnector r-dataqualitydashboard

[working-directory: '../SqlRender']
java-sqlrender:
    mvn clean package -DskipUnitTests -DskipITtests -s pom.xml
    mv target/SqlRender-1.19.2-SNAPSHOT.jar inst/java/SqlRender.jar
    CLASSPATH=inst/java/SqlRender.jar Rscript extras/UpdateChecksum.R
    R CMD INSTALL .

java-all: java-sqlrender

all: java-all r-all

launch-render:
    Rscript -e "library(SqlRender); launchSqlRenderDeveloper()"

launch-render-firefox:
    Rscript -e "library(SqlRender); options(browser = 'firefox'); launchSqlRenderDeveloper()"

run-dqd:
    Rscript ./runDQD.R