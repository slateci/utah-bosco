#!/bin/sh
#echo "#SBATCH --ntasks=4"
[[ -n "$reservation" ]] && echo "#SBATCH --reservation=$reservation"
