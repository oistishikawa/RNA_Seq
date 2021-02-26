
#!/bin/bash

#SBATCH -t 12:00:00
#SBATCH -p compute
#SBATCH --mem=15G
#SBATCH --cpus-per-task 8
#SBATCH -n 1
#SBATCH --array=0-42
#SBATCH -o salmon_%j.out

module load salmon/v1.3.0

ilist_R1=(trimmed/*R1.fq.gz)
ilist_R2=(trimmed/*R2.fq.gz)

input_R1=${ilist_R1[$SLURM_ARRAY_TASK_ID]}
input_R2=${ilist_R2[$SLURM_ARRAY_TASK_ID]}

prefix="trimmed/"
suffix=".fq.gz"
output=${input_R1#"$prefix"}
output=${output%"$suffix"}

#echo "{$input_R1} {$output}"

#During counting, salmon  generates many temp files/folders with common names
#If we run multi samples at the same time, we should seperate those temp files/folders
mkdir quant/$output

mm10_index=(/apps/unit/IshikawaU/salmon/salmon_v1.3.0/mm10/ensembl/Mus_musculus.GRCm38_cdna_all_salmon_index_k_def$
salmon quant -i $mm10_index -l A \
-1 $input_R1 \
-2 $input_R2 \
-p 8 --validateMappings -o quant/$output/
