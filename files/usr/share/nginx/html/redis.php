<?php

$redis = new Redis();
$redis->connect('localhost', 6379);

$pong = $redis->ping();
echo $pong.'\n';

$redis->delete('userName');
$redis->set('userName', 'komeda');
$userName = $redis->get('userName');
echo $userName.'\n';
