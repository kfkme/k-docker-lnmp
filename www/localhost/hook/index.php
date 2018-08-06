<?php
error_reporting(1);

$target    = '/var/www'; // 生产环境web目录
$secret    = "kfkdock";  // 密钥
$wwwUser   = 'www-data'; // 用户
$wwwGroup  = 'www-data'; // 用户组
$fs        = fopen('/var/log/webhook/coding_webhook.log', 'a'); // 日志文件地址
$json      = file_get_contents('php://input'); // 获取 Coding 发送的内容
$content   = json_decode($json, true);
$signature = isset($_SERVER['HTTP_X_CODING_SIGNATURE']) ? $_SERVER['HTTP_X_CODING_SIGNATURE'] : ''; // Coding.net 发送过来的签名

if (!$signature) {
	return http_response_code(404);
}

list($algo, $hash) = explode('=', $signature, 2);
$payloadHash = hash_hmac($algo, $json, $secret);//计算签名

// 判断签名是否匹配
if ($hash === $payloadHash) {
	$project_name = $content['repository']['name']; //项目文件名
	$cmd          = "cd $target/$project_name && git pull";
	$res          = shell_exec($cmd);

	$res_log .= 'Success:' . PHP_EOL;
	$res_log .= $content['head_commit']['author']['name'] . ' 在' . date('Y-m-d H:i:s') . '向' . $content['repository']['name'] . '项目的' . $content['ref'] . '分支push了' . count($content['commits']) . '个commit：' . PHP_EOL;
	$res_log .= $res . PHP_EOL;
	$res_log .= '=======================================================================' . PHP_EOL;

	fwrite($fs, $res_log);
	$fs and fclose($fs);
} else {
	$res_log = 'Error:' . PHP_EOL;
	$res_log .= $content['head_commit']['author']['name'] . ' 在' . date('Y-m-d H:i:s') . '向' . $content['repository']['name'] . '项目的' . $content['ref'] . '分支push了' . count($content['commits']) . '>个commit：' . PHP_EOL;
	$res_log .= '密钥(' . $signature . ')不正确不能pull' . PHP_EOL;
	$res_log .= '=======================================================================' . PHP_EOL;
	fwrite($fs, $res_log);
	$fs and fclose($fs);
}