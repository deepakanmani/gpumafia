#! /bin/bash
# to launch from this directory only

# done with dimension-first layout
# TODO: set to 1 if the data is not generated yet
GENERATE=1

# compile for profiling
make -C ../../cppmafia

# compile clugen, if not already
make -C ../../utils/clugen

# clean cluster data and generate new data
DATA_DIR=/private/adinetz/cluster-n10m-d10

mkdir -p $DATA_DIR
if [ $GENERATE == 1 ]; then
		rm -rf $DATA_DIR/*
		for k in {2..10}; do
				../../utils/clugen/bin/clugen -n10000000 -d10 -k$k \
						$DATA_DIR/cluster-$k.dat
		done
fi

# generate profile data; also alternate between bitmap and direct
for s in {direct,bitmap}; do
		sopt=''
		if [ $s == direct ]; then
				sopt=--no-bitmap
		fi
		for k in {2..10}; do
				../../cppmafia/bin/cppmafia --timing -n100 $sopt	--seq\
						$DATA_DIR/cluster-$k.dat > time-$s-$k.log
		done
done
