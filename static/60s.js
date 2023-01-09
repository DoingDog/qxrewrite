/*
* ==UserScript==
* @ScriptName        每天60s读懂世界
* @Author            Cuttlefish
* @TgChannel         https://t.me/ddgksf2021
* @WechatID          墨鱼手记
* @UpdateTime        2022-04-17
* @ScriptFunction    快速浏览今天世界新闻
* @ScriptURL         https://github.com/ddgksf2013/Scripts/raw/main/60s.js
* ==/UserScript==

[task_local]
0 9 * * * https://github.com/ddgksf2013/Scripts/raw/master/60s.js, tag=每天60s读懂世界

*/

const url = `https://api.03c3.cn/zb/api.php`;
const method = `GET`;
const headers = {
'User-Agent' : `Mozilla/5.0 (iPhone; CPU iPhone OS 12_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148`,
'Host' : `api.03c3.cn`,
'Connection' : `keep-alive`,
'Accept-Language' : `zh-TW,zh-Hant;q=0.9`,
'Accept-Encoding' : `gzip, deflate, br`,
'Accept' : `*/*`
};
const body = ``;

const myRequest = {
    url: url,
    method: method,
    headers: headers,
    body: body
};

$task.fetch(myRequest).then(response => {

$notify("每日60s读懂世界", '  ','墨鱼：'+JSON.parse(response.body).datatime+' 请点击通知查看内容',{"open-url":JSON.parse(response.body).imageUrl});
    $done();
}, reason => {
    console.log(reason.error);
    $done();
});
