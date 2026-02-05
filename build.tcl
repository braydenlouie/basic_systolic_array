# project setup
set project_name "basic_systolic_array"
set part "xc7s25csga324-1" # part number for Arty S7-25
set output_dir "./vivado_out"

create_project -force $project_name $output_dir -part $part

# source files
add_files [glob ./src/*.v]
add_files -fileset constrs_1 ./constraints/Arty-S7-25-Master.xdc
set_property target_constrs_file [get_files ./constraint/Arty-S7-25-Master.xdc] [current_fileset -constrest]

# for IP cores
# read_ip ./src/vio_0/vio_0.xci
# upgrade_ip [get_ips vio_0]

# synthesis
launch_runs synth_1 -jobs 4
wait_on_run synth_1

# implementation and bitstream
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1

open_run impl_1
report_utiliziation -file $output_dir/utilization_report.txt
report_timing_summary -file $output_dir/timing_summary.txt

puts "build complete"
puts "bitstream location: $output_dir/$project_name.runs/impl_1/top_systolic.bit"
puts "reports directory: $output_dir"
