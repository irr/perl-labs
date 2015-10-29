curl -X PUT -T "${file}" \
  -H "Host: ${bucket}.s3.amazonaws.com" \
  -H "Date: ${dateValue}" \
  -H "Content-Type: ${contentType}" \
  -H "Authorization: AWS ${s3Key}:${signature}" \
  https://${bucket}.s3.amazonaws.com/${file}

curl -v -H "Date: Mon, 26-Oct-15 15:37:43 GMT" -H "Authorization: AWS ...:...." http://irrs3.s3.amazonaws.com/test;echo
curl -v -X PUT -T "s3.txt" -H "Date: Mon, 26-Oct-15 15:37:43 GMT" -H "Authorization: AWS ...:..." -H "Host: irrs3.s3.amazonaws.com" -H "Content-Type: text/plain" http://irrs3.s3.amazonaws.com/s3.txt;echo
curl -v -X DELETE -H "Date: Mon, 26-Oct-15 15:37:43 GMT" -H "Authorization: AWS ...:..." -H "Host: irrs3.s3.amazonaws.com" http://irrs3.s3.amazonaws.com/s3.txt;echo

curl -v http://localhost:8888/s3.txt
curl -v http://localhost:8888/s3.jpg -o s3.jpg

curl -v -X PUT --data "@s3.txt" http://localhost:8888/s3.txt
curl -v -X PUT --data-binary "@s3.jpg" -H "Content-Type: image/jpeg" http://localhost:8888/s3.jpg

curl -v -X PUT -T "s3.jpg" -H "Content-Type: image/jpeg" http://localhost:8888/s3.jpg
curl -v -X PUT -T "s3.txt" http://localhost:8888/s3.txt

curl -v X DELETE http://localhost:8888/s3.txt
curl -v X DELETE http://localhost:8888/s3.jpg

