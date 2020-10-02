#!/bin/bash

#
# Acorn's original DFS layout
#

# Drive 0
# - library (tools like TurMasm, Edit, etc)
#
# Drive 2
# - working files (initially blank)
#
# Drive 1
# - OS source code
#
# Drive 3
# - OS source code (continue)

PREFIX=AcornOS120_disk

rm -rf tmp
mkdir -p tmp/d0
mkdir -p tmp/d1
mkdir -p tmp/d2
mkdir -p tmp/d3

# Copy files

# Drive 0

cp ../tools/TurMasmDfs  tmp/d0/TurMasm
cp ../tools/MasmDfs     tmp/d0/Masm
cp ../tools/IoMasm      tmp/d0/
cp ../tools/Edit        tmp/d0/
cp ../tools/*.inf       tmp/d0

# Drive 1

cp ../dfs/MakeMOS       tmp/d1
cp ../src/MOSHdr        tmp/d1
cp ../src/MOS00         tmp/d1
cp ../src/MOS01         tmp/d1
cp ../src/FONT          tmp/d1
cp ../src/MOS02         tmp/d1
cp ../src/MOS03         tmp/d1
cp ../src/MOS04         tmp/d1
cp ../src/MOS05         tmp/d1
cp ../src/MOS06         tmp/d1
cp ../src/MOS07         tmp/d1
cp ../src/MOS08         tmp/d1
cp ../src/MOS10         tmp/d1
cp ../src/MOS11         tmp/d1
cp ../src/MOS56         tmp/d1
cp ../src/MOS99         tmp/d1

# Drive 2

# Drive 3
cp ../src/MOS30         tmp/d3
cp ../src/MOS32         tmp/d3
cp ../src/MOS34         tmp/d3
cp ../src/MOS36         tmp/d3
cp ../src/MOS38         tmp/d3
cp ../src/MOS40         tmp/d3
cp ../src/MOS42         tmp/d3
cp ../src/MOS44         tmp/d3
cp ../src/MOS46         tmp/d3
cp ../src/MOS48         tmp/d3
cp ../src/MOS52         tmp/d3
cp ../src/MOS54         tmp/d3
cp ../src/MOS70         tmp/d3
cp ../src/MOS72         tmp/d3
cp ../src/MOS74         tmp/d3
cp ../src/MOS76         tmp/d3


# Create a !boot file
cat > tmp/d0/\!BOOT <<EOF
*LIB :0.$
*DRIVE 1
*EXEC MakeMOS
EOF

# Convert sources to CR line endings
unix2mac tmp/d0/\!BOOT
unix2mac tmp/d1/M*
unix2mac tmp/d3/M*


# Create disk images
for i in 0 1 2 3
do
beeb blank_ssd tmp/d${i}.ssd
beeb putfile   tmp/d${i}.ssd tmp/d${i}/*
beeb title     tmp/d${i}.ssd "MOS 1.20/${i}"
done

# Make drive 0 bootable
beeb opt4      tmp/d0.ssd 3

# Show the final disks
for i in 0 1 2 3
do
    beeb info tmp/d${i}.ssd
done

# Generate dsd images
beeb merge_dsd tmp/d0.ssd tmp/d2.ssd tmp/d02.dsd
beeb merge_dsd tmp/d1.ssd tmp/d3.ssd tmp/d13.dsd

# Copy into the final directories
mkdir -p ssd
for i in 0 1 2 3
do
    mv tmp/d${i}.ssd ssd/${PREFIX}${i}.ssd
done

mkdir -p dsd
for i in 02 13
do
    mv tmp/d${i}.dsd dsd/${PREFIX}${i}.dsd
done

ls -l ssd dsd
