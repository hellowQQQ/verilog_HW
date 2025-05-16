# Altera System Console's RC script
#
# This TCL file is installed as:
#   $QUARTUS_ROOTDIR/sopc_builder/system_console_macros/system_console_rc.tcl
#
# On launch, if this TCL file is found in the above location, System Console 
# will call the TCL command "source <this file>" upon entry.  This is intended
# to be a configuration file that allows users to handily source scripts and
# perform commands they would want to set up their System Console environment.
#
# Please edit this script to your preference.

proc o_sys {} {
	open_service master [get_default_master]
}
proc c_sys {} {
	close_service master [get_default_master]
}
# Returns the first master in the system.
proc get_default_master {} {
	return [ lindex [ get_service_paths master ] 0 ]
}
proc write_32 { address values } {
  set p0 [ get_default_master ]
  master_write_32 $p0 $address $values
}
proc read_32 { address size } {
  set p0 [ get_default_master ]
  return [ master_read_32 $p0 $address $size ]
}

proc led_shift { } {
	while {1} {
	after 1000
	write_32 0x0 0xf
	after 1000
	write_32 0x0 0x0
	after 1000
	write_32 0x10 0xa
	after 1000
	write_32 0x10 0x5
  }
}
