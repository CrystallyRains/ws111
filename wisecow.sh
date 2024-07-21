#!/usr/bin/env bash

# Configuration
SRVPORT=4499
RSPFILE=response
TLS_CERT="/etc/tls/tls.crt"
TLS_KEY="/etc/tls/tls.key"

# Clean up previous response file
rm -f $RSPFILE
mkfifo $RSPFILE

get_api() {
	read line
	echo $line
}

handleRequest() {
    # 1) Process the request
	get_api
	mod=`fortune`

cat <<EOF > $RSPFILE
HTTP/1.1 200 OK
Content-Type: text/html

<pre>`cowsay $mod`</pre>
EOF
}

prerequisites() {
	command -v cowsay >/dev/null 2>&1 &&
	command -v fortune >/dev/null 2>&1 &&
	command -v openssl >/dev/null 2>&1 || 
		{ 
			echo "Install prerequisites."
			exit 1
		}
}

main() {
	prerequisites
	echo "Wisdom served on port=$SRVPORT with TLS..."

	while [ 1 ]; do
		openssl s_server -accept $SRVPORT -cert $TLS_CERT -key $TLS_KEY -www \
			-quiet -CAfile $TLS_CERT -Verify 1 < $RSPFILE | handleRequest
		sleep 0.01
	done
}

main
