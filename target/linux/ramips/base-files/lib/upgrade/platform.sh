#
# Copyright (C) 2010 OpenWrt.org
#

PART_NAME=firmware
REQUIRE_IMAGE_METADATA=1

RAMFS_COPY_BIN='fw_printenv fw_setenv'
RAMFS_COPY_DATA='/etc/fw_env.config /var/lock/fw_printenv.lock'

platform_check_image() {
	return 0
}

platform_pre_upgrade() {
	local board=$(board_name)

	case "$board" in
	mikrotik,rb750gr3|\
	mikrotik,rbm11g|\
	mikrotik,rbm33g)
		[ -z "$(rootfs_type)" ] && mtd erase firmware
		;;
	esac
}

platform_nand_pre_upgrade() {
	local board=$(board_name)

	case "$board" in
	ubnt-erx|\
	ubnt-erx-sfp)
		platform_upgrade_ubnt_erx "$ARGV"
		;;
	esac
}

platform_do_upgrade() {
	local board=$(board_name)

	case "$board" in
	hc5962|\
	r6220|\
	netgear,r6350|\
	ubnt-erx|\
	ubnt-erx-sfp|\
	xiaomi,mir3g|\
	xiaomi,mir3p)
		nand_do_upgrade "$ARGV"
		;;
	tplink,c50-v4)
		MTD_ARGS="-t romfile"
		default_do_upgrade "$ARGV"
		;;
	linksys,ea8100)
		platform_do_upgrade_linksys "$ARGV"
		;;
	*)
		default_do_upgrade "$ARGV"
		;;
	esac
}
