#!/bin/bash

# ===============================
# SLURM JOB SETTINGS
# ===============================

#SBATCH --export=ALL                 # Export all environment variables
#SBATCH --partition=teaching         # HPC queue in Teaching Partition
#SBATCH --account=teaching           # Use teaching account
#SBATCH --nodes=1                    # Number of nodes (always 1 for Gaussian)
#SBATCH --ntasks=8                   # Number of CPU cores (change for 4/8/16 runs)
#SBATCH --time=00:15:00              # Max runtime
#SBATCH --job-name=ANTCEN_8c         # Job name
#SBATCH --output=slurm-%j.out        # Output file (%j = job ID)

# ===============================
# MODULE SETUP
# ===============================

module purge                         # Clear any loaded modules
module load gaussian/g16             # Load Gaussian software

# ===============================
# JOB PROLOGUE (HPC SETUP)
# ===============================

/opt/software/scripts/job_prologue.sh   # HPC system setup script

# ===============================
# PRINT JOB INFORMATION (FOR REPORT EVIDENCE)
# ===============================

echo "Job started at: $(date)"          # Start time (Readable version)
echo "Hostname: $(hostname)"            # The compute node used
echo "Working directory: $(pwd)"        # Current folder
echo "Job ID: $SLURM_JOB_ID"            # SLURM job ID
echo "Requested cores: $SLURM_NTASKS"   # Number of cores used

# ===============================
# START TIMING (FOR EXECUTION TIME)
# ===============================

start=$(date +%s)                      # Record start time

# ===============================
# RUN GAUSSIAN
# ===============================

export OMP_NUM_THREADS=$SLURM_NTASKS   # Number of cores used
export GAUSS_SCRDIR=$SLURM_SUBMIT_DIR  # Gaussian scratch directory

# Run Gaussian:
# Input  = .gjf file
# Output = .log file
g16 < ANTCEN_8_Cores.gjf > ANTCEN_8_Cores.log

# ===============================
# END TIMING
# ===============================

end=$(date +%s)                        # Record end time

# ===============================
# PRINT TIMING RESULTS
# ===============================

echo "Job finished at: $(date)"        # End time (Readable version)
echo "Elapsed seconds: $((end-start))" # Total execution time

# ===============================
# JOB EPILOGUE (CLEANUP)
# ===============================

/opt/software/scripts/job_epilogue.sh  # HPC cleanup script