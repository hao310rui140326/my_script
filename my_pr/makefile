default:
	##quartus_sh -t a10_partial_reconfig/flow.tcl -setup_script a10_partial_reconfig/setup.tcl
	quartus_ipgenerate --generate_project_qsys_files top_base -c top_base
	quartus_syn --read_settings_files=on --write_settings_files=off top_base -c top_base
	quartus_fit --read_settings_files=on --write_settings_files=off top_base -c top_base
	quartus_asm --read_settings_files=on --write_settings_files=off top_base -c top_base
	quartus_sta top_base -c top_base
	quartus_cdb top_base -c top_base --export_partition root_partition --snapshot final --file top_base.qdb --exclude_pr_subblocks
	quartus_cpf -c output_files/top_base.pr_patition.pmsf output_files/top_base.pr_patition.rbf
	quartus_ipgenerate --generate_project_qsys_files top_base -c blinking_led_default
	quartus_syn --read_settings_files=on --write_settings_files=off top_base -c blinking_led_default
	quartus_cdb top_base -c blinking_led_default --export_partition root_partition --snapshot synthesized --file blinking_led_default.qdb
	quartus_ipgenerate --generate_project_qsys_files top_base -c blinking_low_led
	quartus_syn --read_settings_files=on --write_settings_files=off top_base -c blinking_low_led
	quartus_cdb top_base -c blinking_low_led --export_partition root_partition --snapshot synthesized --file blinking_low_led.qdb
	quartus_cdb top_base -c blinking_led_pr_alpha --import_partition root_partition --file top_base.qdb
	quartus_cdb top_base -c blinking_led_pr_alpha --import_partition pr_patition --file blinking_led_default.qdb
	quartus_fit --read_settings_files=on --write_settings_files=off top_base -c blinking_led_pr_alpha
	quartus_asm --read_settings_files=on --write_settings_files=off top_base -c blinking_led_pr_alpha
	quartus_sta top_base -c blinking_led_pr_alpha
	quartus_cpf -c output_files/blinking_led_pr_alpha.pr_patition.pmsf output_files/blinking_led_pr_alpha.pr_patition.rbf
	quartus_cdb top_base -c blinking_led_pr_bravo --import_partition root_partition --file top_base.qdb
	quartus_cdb top_base -c blinking_led_pr_bravo --import_partition pr_patition --file blinking_low_led.qdb
	quartus_fit --read_settings_files=on --write_settings_files=off top_base -c blinking_led_pr_bravo
	quartus_asm --read_settings_files=on --write_settings_files=off top_base -c blinking_led_pr_bravo
	quartus_sta top_base -c blinking_led_pr_bravo
	quartus_cpf -c output_files/blinking_led_pr_bravo.pr_patition.pmsf output_files/blinking_led_pr_bravo.pr_patition.rbf
	



