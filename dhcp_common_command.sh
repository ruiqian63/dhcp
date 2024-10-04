ssh -XY rui.qian@navarro
matlab -v 2018a
e3-ondemand.tch.harvard.edu

#neonatal raw data path
cd /neuro/labs/grantlab/research/enrique.mondragon/morton_lab/dhcp/data/Package_1232682/fmriresults01/rel3_derivatives/rel3_dhcp_fmri_pipeline
#subject list
/neuro/labs/grantlab/research/enrique.mondragon/morton_lab/dhcp/data/Package_1232682/fmriresults01/rel3_derivatives/rel3_dhcp_fmri_pipeline/subject_neonatal_func.txt


#genome(plink) raw data path
cd /neuro/labs/grantlab/research/enrique.mondragon/morton_lab/dhcp/data/Package_1232682/genomics_sample03/Users/nickharper/cdb/dhcp_plink_files
#subject list
/neuro/labs/grantlab/research/enrique.mondragon/morton_lab/dhcp/data/Package_1232682/genomics_sample03/Users/nickharper/cdb/dhcp_plink_files/subjects.txt

#add toolbox to matlab
scp -r /Users/Rui/downloads/spm12 rui.qian@navarro:/neuro/labs/grantlab/research/enrique.mondragon/morton_lab/dhcp/toolbox

brith age (week)
Min: 23.0 Max: 42.71428571

scp ch258782@e3-login.tch.harvard.edu:/neuro/labs/grantlab/research/enrique.mondragon/morton_lab/dhcp/data/Package_1232682/fmriresults01/rel3_derivatives/rel3_dhcp_fmri_pipeline/sub-CC00056XX07/ses-10700/func/sub-CC00056XX07_ses-10700_task-rest_desc-preproc_bold.nii.gz  /Users/Rui/documents/dhcp
