 #!/bin/sh

 function test() {
    local myval="this $1"
    echo $myval  

 }
mystring="thischar"
result=$(test $mystring)
echo $result