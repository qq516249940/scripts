#!/bin/bash
# author:chunk

#自动替换disconf配置文件,并拷贝文件到/data/jetty-app/web/m2c.operate_9101/webapps下

jetty01=xxx.xxx.xxx.xxx
jetty02=xxx.xxx.xxx.xxx
jetty03=xxx.xxx.xxx.xxx
jetty04=xxx.xxx.xxx.xxx


#大写含有路径，小写不保护路径

SRC_CERT=/data/cert
SRC_JETTY=/data/jetty-app
SRC_LOGS=/data/logs
DEST=/data/



OPERATE_WAR=/data/jetty-app/web/m2c.operate_9101/webapps/m2c.operate.war
USERS_WAR=/data/jetty-app/web/m2c.operate_9101/webapps/m2c.users.war
TRADING_WAR=/data/jetty-app/web/m2c.operate_9101/webapps/m2c.trading.war
SCM_WAR=/data/jetty-app/web/m2c.operate_9101/webapps/m2c.scm.war
MARKET_WAR=/data/jetty-app/web/m2c.operate_9101/webapps/m2c.market.war

SUPPORT_WAR=/data/jetty-app/web/m2c.support_9107/webapps/m2c.support.war
BI_WAR=/data/jetty-app/web/m2c.bi_9108/webapps/m2c.bi.war
MEDIA_WAR=/data/jetty-app/web/m2c.media_9109/webapps/m2c.media.war
DLQ_WAR=/data/jetty-app/web/m2c.dlq_9110/webapps/m2c.dlq.war

war_9101="m2c.operate.war"
war_9102=m2c.users.war
war_9103=m2c.trading.war
war_9104=m2c.scm.war
war_9105=m2c.market.war
war_9106=
war_9107=m2c.support.war
war_9108=m2c.bi.war
war_9109=m2c.media.war
war_9110=m2c.dlq.war


#用于拷贝nfinal,/data中的几个重要目录,递归操作,拷贝的详细内容会记录在/tmp/scp.log

scp_all_data() {
    echo  "*******************正在同步${jetty02}:${SRC_CERT}"
    script -q -a /tmp/scp.log -c "scp -r linux@${jetty02}:${SRC_CERT} $DEST"

    echo  "*******************正在同步${jetty02}:${SRC_JETTY}"
    script -q -a /tmp/scp.log -c "scp -r linux@${jetty02}:${SRC_JETTY} $DEST"

    echo  "*******************正在同步${jetty02}:${SRC_LOGS}"
    script -q -a /tmp/scp.log -c "scp -r linux@${jetty02}:${SRC_LOGS} $DEST"

    echo  "******************同步完成！！***********************"
}

scp_war_re_disconf() {
    
    case "$1" in
	    "server01")
		    echo "***********选择的是server01************************"
		    case "$2" in
			    9101)
			         echo  "operate"
                     script -q -a /tmp/scp.log -c "scp -r linux@${jetty01}:$OPERATE_WAR ./"	
					 jar -uvf ${war_9101} ./WEB-INF/classes/disconf.properties
					 cp -f ${war_9101}  $OPERATE_WAR
                     ;;
                9102)
                     echo  "users"			
                     script -q -a /tmp/scp.log -c "scp -r linux@${jetty01}:$USERS_WAR ./"	
                     jar -uvf ${war_9102} ./WEB-INF/classes/disconf.properties
					 cp -f ${war_9102}  $USERS_WAR					 
					 ;;
                9103)
                     echo  "trading"
                     script -q -a /tmp/scp.log -c "scp -r linux@${jetty01}:$TRADING_WAR ./"	
                     jar -uvf ${war_9103} ./WEB-INF/classes/disconf.properties
					 cp -f ${war_9103}  $TRADING_WAR						 
					 ;;
                9104)
                     echo  "scm"	
  					 script -q -a /tmp/scp.log -c "scp -r linux@${jetty01}:$SCM_WAR ./"	
                     jar -uvf ${war_9104} ./WEB-INF/classes/disconf.properties
					 cp -f ${war_9104}  $SCM_WAR	
					 ;;
			    9105)
				     echo  "market"
					 script -q -a /tmp/scp.log -c "scp -r linux@${jetty01}:$MARKET_WAR ./"	
                     jar -uvf ${war_9105} ./WEB-INF/classes/disconf.properties
					 cp -f ${war_9105}  $MARKET_WAR	
					 ;;					 
		        *)
				    echo "Your chooise Error ！222"
					;;
			esac		    
			;;
			
	    "server02")
		    echo "***********选择的是server02************************"
		    case "$2" in
			    9101)
			         echo  "operate"
                     script -q -a /tmp/scp.log -c "scp -r linux@${jetty02}:$OPERATE_WAR ./"	
					 jar -uvf ${war_9101} ./WEB-INF/classes/disconf.properties
					 cp -f ${war_9101}  $OPERATE_WAR
                     ;;
                9102)
                     echo  "users"			
                     script -q -a /tmp/scp.log -c "scp -r linux@${jetty02}:$USERS_WAR ./"		
                     jar -uvf ${war_9102} ./WEB-INF/classes/disconf.properties
					 cp -f ${war_9102}  $USERS_WAR		
					 ;;
                9103)
                     echo  "trading"
                     script -q -a /tmp/scp.log -c "scp -r linux@${jetty02}:$TRADING_WAR ./"	
                     jar -uvf ${war_9103} ./WEB-INF/classes/disconf.properties
					 cp -f ${war_9103}  $TRADING_WAR	
					 ;;
                9104)
                     echo  "scm"	
  					 script -q -a /tmp/scp.log -c "scp -r linux@${jetty02}:$SCM_WAR ./"	
                     jar -uvf ${war_9104} ./WEB-INF/classes/disconf.properties
					 cp -f ${war_9104}  $SCM_WAR	
					 ;;
			    9105)
				     echo  "market"
					 script -q -a /tmp/scp.log -c "scp -r linux@${jetty02}:$MARKET_WAR ./"	
                     jar -uvf ${war_9105} ./WEB-INF/classes/disconf.properties
					 cp -f ${war_9105}  $MARKET_WAR
					 ;;
		        *)
				    echo "Your chooise Error ！222"
					;;
			esac
			;;
			
		"server03")		
            echo "***********选择的是server03************************"
		    case "$2" in
			    9106)
			         echo  "暂时没有包"
					 
                     ;;
                9107)
                     echo  "support"			
                     script -q -a /tmp/scp.log -c "scp -r linux@${jetty03}:$SUPPORT_WAR ./"
					 jar -uvf ${war_9107} ./WEB-INF/classes/disconf.properties
					 cp -f ${war_9107}  $SUPPORT_WAR					 
					 ;;
                9108)
                     echo  "m2c.bi"
                     script -q -a /tmp/scp.log -c "scp -r linux@${jetty03}:$BI_WAR ./"	
					 jar -uvf ${war_9108} ./WEB-INF/classes/disconf.properties
					 cp -f ${war_9108}  $BI_WAR		
					 ;;
                9109)
                     echo  "media"	
  					 script -q -a /tmp/scp.log -c "scp -r linux@${jetty03}:$MEDIA_WAR ./"	
					 jar -uvf ${war_9109} ./WEB-INF/classes/disconf.properties
					 cp -f ${war_9109}  $MEDIA_WAR 		
					 ;;
			    9110)
				     echo  "dlq"
					 script -q -a /tmp/scp.log -c "scp -r linux@${jetty03}:$DLQ_WAR ./"	
					 jar -uvf ${war_9110} ./WEB-INF/classes/disconf.properties
					 cp -f ${war_9110}  $DLQ_WAR	
					 ;;
		        *)
				    echo "Your chooise Error ！222"
					;;
			esac								    
			;;

		"server04")		
            echo "***********选择的是server04************************"
		    case "$2" in
			    9106)
			         echo  "暂时没有包"
					 
                     ;;
                9107)
                     echo  "support"			
                     script -q -a /tmp/scp.log -c "scp -r linux@${jetty04}:$SUPPORT_WAR ./"		
					 jar -uvf ${war_9107} ./WEB-INF/classes/disconf.properties
					 cp -f ${war_9107}  $SUPPORT_WAR	
					 ;;
                9108)
                     echo  "m2c.bi"
                     script -q -a /tmp/scp.log -c "scp -r linux@${jetty04}:$BI_WAR ./"	
					 jar -uvf ${war_9108} ./WEB-INF/classes/disconf.properties
					 cp -f ${war_9108}  $BI_WAR		
					 ;;
                9109)
                     echo  "media"	
  					 script -q -a /tmp/scp.log -c "scp -r linux@${jetty04}:$MEDIA_WAR ./"	
					 jar -uvf ${war_9109} ./WEB-INF/classes/disconf.properties
					 cp -f ${war_9109}  $MEDIA_WAR 		
					 ;;
			    9110)
				     echo  "dlq"
					 script -q -a /tmp/scp.log -c "scp -r linux@${jetty04}:$DLQ_WAR ./"	
					 jar -uvf ${war_9110} ./WEB-INF/classes/disconf.properties
					 cp -f ${war_9110}  $DLQ_WAR	
					 ;;
		        *)
				    echo "Your chooise Error ！222"
					;;
			esac								    
			;;	
			
			
			
		*)
            echo "Your chooise Error ！1111111"	
            ;;			
    esac
}

scp_war_re_disconf $1 $2


#trap "echo  '出错了，请联系chunk,QQ:516249940,thanks!!'" EXIT 1



