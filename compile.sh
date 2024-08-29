MODE=Release

CLANG=$HOME/LLVM/install/$MODE/clang/bin/clang++
CLANG_INC=$HOME/LLVM/install/$MODE/clang/include/
CLANG_LIB=$HOME/LLVM/install/$MODE/clang/lib/
OMP_INC=$HOME/LLVM/install/$MODE/omp/include/
OMP_LIB=$HOME/LLVM/install/$MODE/omp/lib/
LLVM=$HOME/LLVM/install/$MODE/llvm/bin/
LLVM_LIB=$HOME/LLVM/install/$MODE/llvm/lib/
LLVM_INC=$HOME/LLVM/install/$MODE/llvm/include/

export LD_LIBRARY_PATH=$HOME/LLVM/install/$MODE/llvm/lib/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$HOME/LLVM/install/$MODE/clang/lib/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$HOME/LLVM/install/$MODE/omp/lib/:$LD_LIBRARY_PATH

# ${CLANG} -g -L${OMP_LIB} -L${LLVM_LIB} -I${OMP_INC} -I${LLVM_INC} -lomp -fopenmp src/test-basic-case.cpp -o $FILE
# ${CLANG} -g -L${OMP_LIB} -L${LLVM_LIB} -I${OMP_INC} -I${LLVM_INC} -lomp -fopenmp src/test-sched-case.cpp -o basic-sched

# ${CLANG} -O -I${OMP_INC} -I${LLVM_INC} -Xclang -disable-llvm-optzns -g0 -fno-discard-value-names test-basic-case.cpp -emit-llvm -c -o test.bc
# ${LLVM}/llvm-dis test.bc -o test.ll
# ${LLVM}/opt basic-case.ll -S -o basic-case.ll
# ${LLVM}/llvm-link ${OMP_LIB}/*.so basic-case.ll -o basic-case.ll

# . /vol0004/apps/oss/spack/share/spack/setup-env.sh
# spack load gcc@13.2.0%gcc@8.5.0 arch=linux-rhel8-skylake_avx512

SCRIPT=run-cpu.sh
NSIZE=8000
CODE=2DWaveModeling

for i in $(seq 1 5); do
    FILE=bin/$(uuidgen).o
    ${CLANG} -I${OMP_INC} -I${LLVM_INC} -L${OMP_LIB} -L${LLVM_LIB} -lomp -fopenmp -O3 src/${CODE}.cpp -o ${FILE} -DN=${NSIZE} -DSCHED=dynamic,auto && sbatch --job-name=ATD-${NSIZE} ${SCRIPT} ${FILE} || rm ${FILE}

    FILE=bin/$(uuidgen).o
    ${CLANG} -I${OMP_INC} -I${LLVM_INC} -L${OMP_LIB} -L${LLVM_LIB} -lomp -fopenmp -O3 src/${CODE}.cpp -o ${FILE} -DN=${NSIZE} -DSCHED=guided,auto && sbatch --job-name=ATG-${NSIZE} ${SCRIPT} ${FILE} || rm ${FILE}

    FILE=bin/$(uuidgen).o
    ${CLANG} -I${OMP_INC} -I${LLVM_INC} -L${OMP_LIB} -L${LLVM_LIB} -lomp -fopenmp -O3 src/${CODE}.cpp -o ${FILE} -DN=${NSIZE} -DSCHED=static,auto && sbatch --job-name=ATS-${NSIZE} ${SCRIPT} ${FILE} || rm ${FILE}

    FILE=bin/$(uuidgen).o
    ${CLANG} -I${OMP_INC} -I${LLVM_INC} -L${OMP_LIB} -L${LLVM_LIB} -lomp -fopenmp -O3 src/${CODE}.cpp -o ${FILE} -DN=${NSIZE} -DSCHED=dynamic && sbatch --job-name=DY-${NSIZE} ${SCRIPT} ${FILE} || rm ${FILE}

    FILE=bin/$(uuidgen).o
    ${CLANG} -I${OMP_INC} -I${LLVM_INC} -L${OMP_LIB} -L${LLVM_LIB} -lomp -fopenmp -O3 src/${CODE}.cpp -o ${FILE} -DN=${NSIZE} -DSCHED=static && sbatch --job-name=ST-${NSIZE} ${SCRIPT} ${FILE} || rm ${FILE}

    FILE=bin/$(uuidgen).o
    ${CLANG} -I${OMP_INC} -I${LLVM_INC} -L${OMP_LIB} -L${LLVM_LIB} -lomp -fopenmp -O3 src/${CODE}.cpp -o ${FILE} -DN=${NSIZE} -DSCHED=guided && sbatch --job-name=GI-${NSIZE} ${SCRIPT} ${FILE} || rm ${FILE}
done