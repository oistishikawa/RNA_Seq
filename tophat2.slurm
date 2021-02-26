  GNU nano 2.9.8                                      tophat2.slurm                                                
#!/bin/bash
#SBATCH -t 12:00:00
#SBATCH -p compute
#SBATCH --mem=15G
#SBATCH --cpus-per-task 8
#SBATCH -n 1
#SBATCH --array=0-42
#SBATCH --out=tophat_%j.out

module load python/2.7.18
module load bowtie2/2.3.4.3
module load samtools/1.9
module load tophat/2.1.1

ilist_R1=(trimmed/*R1.fq.gz)
ilist_R2=(trimmed/*R2.fq.gz)

input_R1=${ilist_R1[$SLURM_ARRAY_TASK_ID]}
input_R2=${ilist_R2[$SLURM_ARRAY_TASK_ID]}

prefix="trimmed/"
suffix=".fq.gz"
output=${input_R1#"$prefix"}
output=${output%"$suffix"}

#echo "{$input_R1} {$output}"

#During mapping, tophat2 generates many temp files/folders with common names
#If we run multi samples at the same time, we should seperate those temp files/folders
mkdir mapped/$output

tophat -p8 -o mapped/$output/ \
/flash/IshikawaU/tsunghan/mm10/Sequence/Bowtie2Index/genome \
$input_R1,$input_R2
