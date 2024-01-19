
/*
 * Quantumult X 脚本: 清空特定列表内容
 * 
 * [rewrite_local]
 * ^https://ipv6.zyh365.com/index5/index url script-response-body your_script_name.js
 * 
 * [mitm]
 * hostname = ipv6.zyh365.com
*/

let body = $response.body;
let obj = JSON.parse(body);

// 列出要清空的列表名称
const emptyLists = [
  "businessList",
  "popAdvertList",
  "waistList",
  "scrollList",
  "chooseRotationList",
  "chooseAdvertiseList"
];

// 遍历并清空列表
emptyLists.forEach((list) => {
  if (obj.data.hasOwnProperty(list)) {
    obj.data[list] = [];
  }
});

// 替换响应体并返回修改后的内容
body = JSON.stringify(obj);
$done({ body });
