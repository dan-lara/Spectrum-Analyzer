if {$argc > 0} {
  set build_dir [lindex $argv 0]
} else {
  puts "### ERROR: Argument not specified (build_dir)"
  exit -1
}

if {$argc > 1} {
  set app_name [lindex $argv 1]
} else {
  puts "### ERROR: Argument not specified (app_name)"
  exit -1
}

if {$argc > 2} {
  set app_path [lindex $argv 2]
} else {
  puts "### ERROR: Argument not specified (app_path)"
  exit -1
}

if { $argc > 3 } {
  set freertos_new [lindex $argv 3]
} else {
  puts "### WARNING: Argument not specified (baremetal_new): setting to one"
  set freertos_new 1
}

if { $argc > 4 } {
  set stack_size [lindex $argv 4]
} else {
  puts "### WARNING: Argument not specified (stack_size): setting to default (0x2000)"
  set stack_size 0x2000
}

if { $argc > 5 } {
  set heap_size [lindex $argv 5]
} else {
  puts "### WARNING: Argument not specified (heap_size): setting to default (0x2000)"
  set heap_size 0x2000
}

puts "app_path: $app_path"
setws $build_dir/xsct/freertos_workspace
platform active pfm_freertos
if { $freertos_new == 1 } {
  puts "### INFO: Creating application project $app_name"
  app create -name $app_name -template {Empty Application} -platform pfm_freertos
}
importsources -name $app_name -path $app_path -soft-link
lscript section -name stack -mem [lscript def-mem -stack] -size $stack_size
lscript section -name heap -mem [lscript def-mem -stack] -size $heap_size
lscript generate -app $app_name -path $build_dir/xsct/freertos_workspace/$app_name/src -name "lscript"
puts "### INFO: Compiling application $app_name"
app build -name $app_name

unset stack_size
unset heap_size
unset app_name
unset app_path
unset freertos_new
unset build_dir
