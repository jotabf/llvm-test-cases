CLANG=$DATA/LLVM/install/clang/bin/clang++
CLANG_INC=$DATA/LLVM/install/clang/include/
CLANG_LIB=$DATA/LLVM/install/clang/lib/
OMP_INC=$DATA/LLVM/install/omp/include/
OMP_LIB=$DATA/LLVM/install/omp/lib/
LLVM=$DATA/LLVM/install/llvm/bin/
LLVM_LIB=$DATA/LLVM/install/llvm/lib/
LLVM_INC=$DATA/LLVM/install/llvm/include/

CURR_DIR=/home/joao.fernandes/LLVM/basic-case

export LD_LIBRARY_PATH=$DATA/LLVM/install/llvm/lib/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$DATA/LLVM/install/clang/lib/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$DATA/LLVM/install/omp/lib/:$LD_LIBRARY_PATH

# ${CLANG} -g -L${OMP_LIB} -L${LLVM_LIB} -I${OMP_INC} -I${LLVM_INC} -lomp -fopenmp src/basic-case.cpp -o basic-case || exit 1
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