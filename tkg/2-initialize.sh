#!/bin/bash
#bdereims@vmware.com

. ./password
. ./env

echo "Launching UI to quickly set TKG"
echo "Suggestion: launch remote proxy port with 'ssh -L 8080:127.0.0.1:8080 user@jumpbox'"
echo "and use browser with 'http://localhost:8080'"
echo ""

tkg init --ui -v 6 
