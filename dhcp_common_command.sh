ssh -XY rui.qian@navarro
matlab -v 2018a

#neonatal raw data path
cd /neuro/labs/grantlab/users/rui.qian/Package_1232682/fmriresults01/rel3_derivatives
#subject list
/neuro/labs/grantlab/users/rui.qian/Package_1232682/fmriresults01/rel3_derivatives/rel3_dhcp_fmri_pipeline/subject_neonatal_func.txt


#genome(plink) raw data path
cd /neuro/labs/grantlab/users/rui.qian/Package_1232682/genomics_sample03/Users/nickharper/cdb/dhcp_plink_files
#subject list
/neuro/labs/grantlab/users/rui.qian/Package_1232682/genomics_sample03/Users/nickharper/cdb/dhcp_plink_files/subjects.txt

#add toolbox to matlab
scp -r /Users/Rui/downloads/spm12 rui.qian@navarro:/neuro/arch/x86_64-Linux/packages/matlab/R2018a/toolbox

brith age (week)
Min: 23.0 Max: 42.71428571
