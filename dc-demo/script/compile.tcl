set rm_top seq_merger
set rm_para "dw=>8, L=>16"

# working directory
if {[file exists work ] && [file isdirectory work ]} {
    file delete -force work
}
file mkdir work
define_design_lib work -path work

if {![file exists file ]} {
    file mkdir file
}

# set the technology libraries
source script/tech.tcl

# read in source codes
source script/source.tcl

# elaborate the design
elaborate ${rm_top} -parameters ${rm_para}
rename_design ${current_design} sorter

set_operating_conditions -analysis_type bc_wc \
    -min fast -min_library /mnt/nas-eda/cell-lib/nangate45/nangate_ccs_fast.db:NangateOpenCellLibrary \
    -max slow -max_library /mnt/nas-eda/cell-lib/nangate45/nangate_ccs_slow.db:NangateOpenCellLibrary

link

check_design

source script/constraint.tcl

link

report_timing -loops -max_paths 2

compile -boundary_optimization

write -format verilog -hierarchy -out file/${current_design}_syn.v $current_design
write_sdf -significant_digits 5 file/${current_design}.sdf

report_constraints -verbose

report_constraints

report_area

exit
