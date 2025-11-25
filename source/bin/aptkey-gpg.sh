#!/bin/bash

# aptkey-gpg.sh 
# Version: 1.1.1
# Author: monon


KEY_DEPOT="/etc/apt/trusted.gpg.d"
PRIVIL="sudo"


function running()
{
    local temporal_key_file=""
    local url_origen=${1} ## url_origen can be a "file://", "http://" or "ftp://"
    local input_key_file=$(basename -- "${url_origen}")
    local key_name="${input_key_file%.*}"
    local temporal_key_file="/tmp/${input_key_file}"
    local gpg_test="gpg --dearmor --dry-run"
    local gpg_command="gpg --dearmor -vo"

    echo -e "Getting $input_key_file from:"
    echo -e "${url_origen}"
    
    if [[  ${url_origen} =~ ^http://.+ ]] || [[  ${url_origen} =~ ^ftp://.+ ]] ; then
        wget -qO "${temporal_key_file}" "${url_origen}"
    elif [[ -e ${url_origen} ]]; then
        cp ${url_origen} ${temporal_key_file}
    fi
    
    if [[ -z $(cat "${temporal_key_file}" | ${gpg_test}  1> /dev/null) ]]; then
        echo ""
        (cat "${temporal_key_file}" \
                            | ${PRIVIL} ${gpg_command} ${KEY_DEPOT}/${key_name}.gpg \
                            && rm "${temporal_key_file}" \
                            && echo -e "\n${key_name}.gpg into ${KEY_DEPOT}") \
                            || echo -e "Error adquiring the key"
    else
        echo "Not valid url or file doesn't exists"
    fi

    exit 0
}

function help_message(){

    cat <<EOF
    
####  $( basename ${0} ) ####
Syntaxi: $( basename ${0} ) [options] URL
  
  URL   Can be http://, ftp:// or a path to a key file
  
  Options:
    -D  Debug option. Normal user and output file in the working directory
    -h  Show this message
     
EOF
}


OPTIONS=$(getopt  -o "hD" -n '$0' -- "$@")

if [ $? != 0 ] ; then
  exit 1 ;
fi

eval set -- "$OPTIONS"

while true ; do 
    case $1 in 
            -h)
                shift
                help_message
                exit 0
                ;;
            -D)
                shift
                PRIVIL=""
                KEY_DEPOT="$(realpath .)"
                ;;
            --)
                shift
                running "${1}"
                break
                ;;
            *)
                shift
                exit 1
                ;;
    esac
done

exit 0





