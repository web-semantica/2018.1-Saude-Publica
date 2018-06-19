#############################################################################
# Copyright (C) 2012-2016 Franz Inc, Oakland, CA - All rights reserved.     #
#                                                                           #
# The software, data and information contained herein are proprietary       #
# to, and comprise valuable trade secrets of, Franz, Inc.  They are         #
# given in confidence by Franz, Inc. pursuant to a written license          #
# agreement, and may be stored and used only in accordance with the terms   #
# of such license.                                                          #
#                                                                           #
# Restricted Rights Legend                                                  #
# ------------------------                                                  #
# Use, duplication, and disclosure of the software, data and information    #
# contained herein by any agency, department or entity of the U.S.          #
# Government are subject to restrictions of Restricted Rights for           #
# Commercial Software developed at private expense as specified in          #
# DOD FAR Supplement 52.227-7013 (c) (1) (ii), as applicable.               #
#############################################################################

host=localhost
port=10035
user=
password=
catalog=
repo=
verbose=

function make_base_url {
    local prefix=

    if [ "$catalog" ]; then
	echo http://$host:$port/catalogs/$catalog/repositories/$repo 
    else
	echo http://$host:$port/repositories/$repo 
    fi
}

function do_curl {
    curl --silent --show-error --user $user:$password "$@"
}

if ! TEMP=`getopt -n "$0" -o h:P:u:p:c:v -l host:,port:,user:,password:,catalog:,verbose,help -- "$@"`; then
    usage
fi

eval set -- "$TEMP"

while true; do
    case "$1" in
	-h|--host)
	    host="$2"
	    shift 2
	    ;;
	-P|--port)
	    port="$2"
	    shift 2
	    ;;
	-u|--user)
	    user="$2"
	    shift 2
	    ;;
	-p|--password)
	    password="$2"
	    shift 2
	    ;;
	-c|--catalog)
	    catalog="$2"
	    shift 2
	    ;;
	-v|--verbose)
	    verbose=t
	    shift 1
	    ;;
	--help)
	    usage
	    exit 1
	    ;;
	--)
	    shift
	    break
	    ;;
	*)
	    echo Got "$1" from getopt.  This should never happen
	    exit 1
    esac
done

if [ -z "$user" -o -z "$password" ]; then
    echo Username and password are required
    usage
fi
