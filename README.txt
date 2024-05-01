$0 - executed script, or parent if sourced
$BASH_SOURCE - current script even if sourced
$0 = './outer.sh'
$BASH_SOURCE[0] = './inner.sh'
$BASH_SOURCE[1] = './middle.sh'
$BASH_SOURCE[2] = './outer.sh'

# exit from a subshell won't bubble up
$(exit 1)
