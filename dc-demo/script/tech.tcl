
set rm_lib_dirs         "/mnt/nas-eda/cell-lib/nangate45"

set rm_library         "nangate_ccs_slow.db nangate_ccs_fast.db"

set search_path         [concat ${search_path} "${rm_lib_dirs}/" ".."]

set synthetic_library   dw_foundation.sldb
set link_library        [list *]
set link_library        [concat ${link_library} ${rm_library} $synthetic_library]
set target_library      "nangate_ccs_slow.db"
