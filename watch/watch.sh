#/bin/sh
echo "this is watch.sh"

curl_func(){
  echo "this is curl_func" $1 $2 
  while [ true ]
  do
    curl -s $1
    sleep $2
  done
}

curl_func 35.222.253.133:8080/hello/world 1 &
curl_func 35.222.253.133:8080/hello/instana 2 &
curl_func 35.222.253.133:8080/goodbye/world 3 &
curl_func 35.222.253.133:8080/goodbye/instana 4