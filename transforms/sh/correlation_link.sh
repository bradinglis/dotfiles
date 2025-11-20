sed 's/\(.*\)$/[Correlation: \1](https:\/\/integ-monitorviewer-v1-webapp-bslau-tst-aes.azurewebsites.net\/Home\/Transaction?correlationId=\1)\n/g'
echo "md" > /tmp/ext
