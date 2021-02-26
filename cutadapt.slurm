  GNU nano 2.9.8                                      cutadpt.slurm                                                
#!/bin/bash

#SBATCH -t 1:30:00
#SBATCH --mem=10G
#SBATCH --cpus-per-task 4
#SBATCH --ntasks 1
#SBATCH --array=0-42

module load cutadapt/2.8

ilist_R1=(/work/IshikawaU/tsunghan/200206_ID584_Th_RNAseq/fastq/*R1*.fastq.gz)
ilist_R2=(/work/IshikawaU/tsunghan/200206_ID584_Th_RNAseq/fastq/*R2*.fastq.gz)

input_R1=${ilist_R1[$SLURM_ARRAY_TASK_ID]}
input_R2=${ilist_R2[$SLURM_ARRAY_TASK_ID]}

output_forward=$(basename -s _001.fastq.gz $input_R1).fq.gz
output_reverse=$(basename -s _001.fastq.gz $input_R2).fq.gz

cutadapt -q 25 --minimum-length 30 -o $output_forward -p $output_reverse $input_R1 $input_R2
