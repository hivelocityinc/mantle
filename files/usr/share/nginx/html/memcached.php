<?php

$m = new Memcached();
$m->addServer('localhost', 11211);
$m->set('string', 'Memcached testing with PHP');

var_dump($m->get('string'));
