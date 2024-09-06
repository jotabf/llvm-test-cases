MODE=Release

CLANG=$HOME/LLVM/install/$HOSTNAME/$MODE/clang/bin/clang++
CLANG_INC=$HOME/LLVM/install/$HOSTNAME/$MODE/clang/include/
CLANG_LIB=$HOME/LLVM/install/$HOSTNAME/$MODE/clang/lib/
OMP_INC=$HOME/LLVM/install/$HOSTNAME/$MODE/omp/include/
OMP_LIB=$HOME/LLVM/install/$HOSTNAME/$MODE/omp/lib/
LLVM=$HOME/LLVM/install/$HOSTNAME/$MODE/llvm/bin/
LLVM_LIB=$HOME/LLVM/install/$HOSTNAME/$MODE/llvm/lib/
LLVM_INC=$HOME/LLVM/install/$HOSTNAME/$MODE/llvm/include/

export LD_LIBRARY_PATH=$HOME/LLVM/install/$HOSTNAME/$MODE/llvm/lib/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$HOME/LLVM/install/$HOSTNAME/$MODE/clang/lib/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$HOME/LLVM/install/$HOSTNAME/$MODE/omp/lib/:$LD_LIBRARY_PATH

NSIZE=8000
CODE=2DWaveModeling # RBGaussSeidel 2DWaveModeling
BORDE=100

echo "Compiling ${CODE} with N=${NSIZE} and B=${BORDE}"

for i in $(seq 1 10); do
	printf "DynAuto "
    FILE=bin/$(uuidgen).o
    ${CLANG} -I${OMP_INC} -I${LLVM_INC} -L${OMP_LIB} -L${LLVM_LIB} -O3 -lomp -fopenmp src/${CODE}.cpp -o ${FILE} -DN=${NSIZE} -DB=${BORDE} -DSCHED=dynamic,auto || exit 1
    ./${FILE}; wait
    rm ${FILE}

    printf "GuiAuto "
    FILE=bin/$(uuidgen).o
    ${CLANG} -I${OMP_INC} -I${LLVM_INC} -L${OMP_LIB} -L${LLVM_LIB} -O3 -lomp -fopenmp src/${CODE}.cpp -o ${FILE} -DN=${NSIZE} -DB=${BORDE} -DSCHED=guided,auto || exit 1
    ./${FILE}; wait
    rm ${FILE}

    printf "StaAuto "
    FILE=bin/$(uuidgen).o
    ${CLANG} -I${OMP_INC} -I${LLVM_INC} -L${OMP_LIB} -L${LLVM_LIB} -O3 -lomp -fopenmp src/${CODE}.cpp -o ${FILE} -DN=${NSIZE} -DB=${BORDE} -DSCHED=static,auto || exit 1
    ./${FILE}; wait
    rm ${FILE}

    printf "Dynamic "
    FILE=bin/$(uuidgen).o
    ${CLANG} -I${OMP_INC} -I${LLVM_INC} -L${OMP_LIB} -L${LLVM_LIB} -O3 -lomp -fopenmp src/${CODE}.cpp -o ${FILE} -DN=${NSIZE} -DB=${BORDE} -DSCHED=dynamic || exit 1
    ./${FILE}; wait
    rm ${FILE}

   	printf "Guided "
    FILE=bin/$(uuidgen).o
    ${CLANG} -I${OMP_INC} -I${LLVM_INC} -L${OMP_LIB} -L${LLVM_LIB} -O3 -lomp -fopenmp src/${CODE}.cpp -o ${FILE} -DN=${NSIZE} -DB=${BORDE} -DSCHED=guided || exit 1
    ./${FILE}; wait
    rm ${FILE}

    printf "Static "
    FILE=bin/$(uuidgen).o
    ${CLANG} -I${OMP_INC} -I${LLVM_INC} -L${OMP_LIB} -L${LLVM_LIB} -O3 -lomp -fopenmp src/${CODE}.cpp -o ${FILE} -DN=${NSIZE} -DB=${BORDE} -DSCHED=static || exit 1
    ./${FILE}; wait
    rm ${FILE}
done

echo "Done"