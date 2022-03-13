#!/bin/bash

# Get user info
info=$(cat ./configure)

username=${info#*username=}
username=${username%%;*}

password=${info#*password=}
password=${password%%;*}

status=${info#*status=}
status=${status%%;*}

longitude=${info#*longitude=}
longitude=${longitude%%;*}

latitude=${info#*latitude=}
latitude=${latitude%%;*}

province=${info#*province=}
province=${province%%;*}

city=${info#*city=}
city=${city%%;*}

district=${info#*district=}
district=${district%%;*}

street_number=${info#*street_number=}
street_number=${street_number%%;*}

vaccine=${info#*vaccine=}
vaccine=${vaccine%%;*}


# Urlencode the info
password=$(echo -n $password | xxd -p | tr -d '\n' | sed 's/\(..\)/%\1/g')
province=$(echo -n $province | xxd -p | tr -d '\n' | sed 's/\(..\)/%\1/g')
city=$(echo -n $city | xxd -p | tr -d '\n' | sed 's/\(..\)/%\1/g')
street_number=$(echo -n $street_number | xxd -p | tr -d '\n' | sed 's/\(..\)/%\1/g')

# Get jsessionid and LT to log in
cnt=$(curl -i -s 'https://sso.hitsz.edu.cn:7002/cas/login?service=https%3A%2F%2Fstudent.hitsz.edu.cn%2Fcommon%2FcasLogin%3Fparams%3DL3hnX21vYmlsZS9ob21l')
jsessionid=${cnt#*JSESSIONID=}
jsessionid=${jsessionid%%;*}
LT=${cnt#*LT-}
LT=${LT%%-cas*}
LT="LT-$LT-cas"

# Log in to get ticket
cnt=$(curl -s "https://sso.hitsz.edu.cn:7002/cas/login;jsessionid=$jsessionid?service=https%3A%2F%2Fstudent.hitsz.edu.cn%2Fcommon%2FcasLogin%3Fparams%3DL3hnX21vYmlsZS9ob21l" \
  -H 'Connection: keep-alive' \
  -H 'Cache-Control: max-age=0' \
  -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="99", "Microsoft Edge";v="99"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'Origin: https://sso.hitsz.edu.cn:7002' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36 Edg/99.0.1150.36' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Sec-Fetch-Mode: navigate' \
  -H 'Sec-Fetch-User: ?1' \
  -H 'Sec-Fetch-Dest: document' \
  -H 'Referer: https://sso.hitsz.edu.cn:7002/cas/login?service=https%3A%2F%2Fstudent.hitsz.edu.cn%2Fcommon%2FcasLogin%3Fparams%3DL3hnX21vYmlsZS9ob21l' \
  -H 'Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6' \
  -H "Cookie: JSESSIONID=$jsessionid;" \
  --data-raw "username=$username&password=$password&rememberMe=on&lt=$LT&execution=e1s1&_eventId=submit&vc_username=&vc_password=" \
  -i \
  --compressed)
ticket=${cnt#*ticket=}
ticket=${ticket%%-cas*}
ticket="$ticket-cas"

# Get jsessionid to post
cnt=$(curl -s "https://student.hitsz.edu.cn/common/casLogin?params=L3hnX21vYmlsZS9ob21l&ticket=$ticket" \
  -H 'Connection: keep-alive' \
  -H 'Cache-Control: max-age=0' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36 Edg/99.0.1150.36' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'Sec-Fetch-Site: same-site' \
  -H 'Sec-Fetch-Mode: navigate' \
  -H 'Sec-Fetch-User: ?1' \
  -H 'Sec-Fetch-Dest: document' \
  -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="99", "Microsoft Edge";v="99"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'Referer: https://sso.hitsz.edu.cn:7002/' \
  -H 'Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6' \
  -i \
  --compressed)
jsessionid=${cnt#*JSESSIONID=}
jsessionid=${jsessionid%%;*}

# Simulate a browser's behavior
curl -s "https://student.hitsz.edu.cn/common/casLogin;jsessionid=$jsessionid?params=L3hnX21vYmlsZS9ob21l" \
  -H 'Connection: keep-alive' \
  -H 'Cache-Control: max-age=0' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36 Edg/99.0.1150.36' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'Sec-Fetch-Site: same-site' \
  -H 'Sec-Fetch-Mode: navigate' \
  -H 'Sec-Fetch-User: ?1' \
  -H 'Sec-Fetch-Dest: document' \
  -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="99", "Microsoft Edge";v="99"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'Referer: https://sso.hitsz.edu.cn:7002/' \
  -H 'Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6' \
  -H "Cookie: JSESSIONID=$jsessionid" \
  --compressed

cnt=$(curl -s 'https://student.hitsz.edu.cn/xg_mobile/home' \
  -H 'Connection: keep-alive' \
  -H 'Cache-Control: max-age=0' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36 Edg/99.0.1150.36' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'Sec-Fetch-Site: same-site' \
  -H 'Sec-Fetch-Mode: navigate' \
  -H 'Sec-Fetch-User: ?1' \
  -H 'Sec-Fetch-Dest: document' \
  -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="99", "Microsoft Edge";v="99"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'Referer: https://sso.hitsz.edu.cn:7002/' \
  -H 'Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6' \
  -H "Cookie: JSESSIONID=$jsessionid" \
  --compressed)

# Get the token
token=$(curl -s 'https://student.hitsz.edu.cn/xg_common/getToken' \
  -X 'POST' \
  -H 'Connection: keep-alive' \
  -H 'Content-Length: 0' \
  -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="99", "Microsoft Edge";v="99"' \
  -H 'Accept: */*' \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36 Edg/99.0.1150.36' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'Origin: https://student.hitsz.edu.cn' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Dest: empty' \
  -H 'Referer: https://student.hitsz.edu.cn/xg_mobile/xsMrsbNew/index' \
  -H 'Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6' \
  -H "Cookie: JSESSIONID=$jsessionid" \
  --compressed)

# Final post
res=$(curl -s 'https://student.hitsz.edu.cn/xg_mobile/xsMrsbNew/save' \
  -H 'Connection: keep-alive' \
  -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="99", "Microsoft Edge";v="99"' \
  -H 'Accept: application/json, text/javascript, */*; q=0.01' \
  -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
  -H 'X-Requested-With: XMLHttpRequest' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36 Edg/99.0.1150.36' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'Origin: https://student.hitsz.edu.cn' \
  -H 'Sec-Fetch-Site: same-origin' \
  -H 'Sec-Fetch-Mode: cors' \
  -H 'Sec-Fetch-Dest: empty' \
  -H 'Referer: https://student.hitsz.edu.cn/xg_mobile/xsMrsbNew/index' \
  -H 'Accept-Language: zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6' \
  -H "Cookie: JSESSIONID=$jsessionid" \
  --data-raw "info=%7B%22model%22%3A%7B%22dqzt%22%3A%22$status%22%2C%22gpsjd%22%3A$longitude%2C%22gpswd%22%3A$latitude%2C%22kzl1%22%3A%221%22%2C%22kzl2%22%3A%22%22%2C%22kzl3%22%3A%22%22%2C%22kzl4%22%3A%22%22%2C%22kzl5%22%3A%22%22%2C%22kzl6%22%3A%22$province%22%2C%22kzl7%22%3A%22$city%22%2C%22kzl8%22%3A%22$district%22%2C%22kzl9%22%3A%22$street_number%22%2C%22kzl10%22%3A%22$province$district$street_number%22%2C%22kzl11%22%3A%22%22%2C%22kzl12%22%3A%22%22%2C%22kzl13%22%3A%220%22%2C%22kzl14%22%3A%22%22%2C%22kzl15%22%3A%220%22%2C%22kzl16%22%3A%22%22%2C%22kzl17%22%3A%221%22%2C%22kzl18%22%3A%220%3B%22%2C%22kzl19%22%3A%22%22%2C%22kzl20%22%3A%22%22%2C%22kzl21%22%3A%22%22%2C%22kzl22%22%3A%22%22%2C%22kzl23%22%3A%220%22%2C%22kzl24%22%3A%220%22%2C%22kzl25%22%3A%22%22%2C%22kzl26%22%3A%22%22%2C%22kzl27%22%3A%22%22%2C%22kzl28%22%3A%220%22%2C%22kzl29%22%3A%22%22%2C%22kzl30%22%3A%22%22%2C%22kzl31%22%3A%22%22%2C%22kzl32%22%3A%22$vaccine%22%2C%22kzl33%22%3A%22%22%2C%22kzl34%22%3A%7B%7D%2C%22kzl38%22%3A%22$province%22%2C%22kzl39%22%3A%22$city%22%2C%22kzl40%22%3A%22$district%22%7D%2C%22token%22%3A%22$token%22%7D" \
  --compressed)
time=$(date "+[%Y/%m/%d-%H:%M:%S]")
echo "$time:$res"