<?php
ini_set('display_errors', 1);
//memcached
echo "memcached " . extension_loaded("memcached") . "\n";
$memcached = new Memcached;
$memcached->addServer('memcached', 11211) or die ("Could not connect");
$key = md5('test-memcached');  //something unique
for ($k=0; $k<5; $k++) {
    $data = $memcached->get($key);
    if ($data == NULL) {
        $data = array();
        //generate an array of random
        echo "expensive query";
        for ($i=0; $i<100; $i++) {
            for ($j=0; $j<10; $j++) {
                $data[$i][$j] = 'something';
            }
        }
        $memcached->set($key, $data);
    } else {
        echo "cached";
    }
    echo "\n";
}
$memcached->set('hello', "yes!");
var_dump($memcached->get('hello'));
?>
