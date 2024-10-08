#!/bin/bash

rm -f -r info;
mkdir info;
cd info; mkdir dumps; cd dumps;
mkdir assembly; mkdir shear; cd ..; cd ..;



cp -r info ..;
cd ..;
mv -f info data/storage/systemTotalFreePhi550T50damp75cCL75NPart1500ShearRate20RT1_300RT2_600RT3_1200RT4_2400;
cd data/storage/systemTotalFreePhi550T50damp75cCL75NPart1500ShearRate20RT1_300RT2_600RT3_1200RT4_2400/info; mv dumps ..; cd ..; cd ..; cd ..; cd ..;
