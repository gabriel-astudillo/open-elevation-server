#!/usr/bin/env bash
BASEDIR=$(readlink -f $0)
BASEDIR=$(dirname $BASEDIR)

DATA_DIR=srtm_data
ORIG_FILES_DIR=orig_files

GDAL_INFO=$(which gdalinfo)
GDAL_TRANSLATE=$(which gdal_translate)

create_tiles() {
	raster=$1
	xtiles=$2
	ytiles=$3

	printf "====== Creating tiles from %s ======\n" $1
	# get raster bounds
	ul=($($GDAL_INFO $raster | grep '^Upper Left' | sed -e 's/[a-zA-Z ]*(//' -e 's/).*//' -e 's/,/ /'))
	lr=($($GDAL_INFO $raster | grep '^Lower Right' | sed -e 's/[a-zA-Z ]*(//' -e 's/).*//' -e 's/,/ /'))

	xmin=${ul[0]}
	xsize=$(echo "${lr[0]} - $xmin" | bc)
	ysize=$(echo "${ul[1]} - ${lr[1]}" | bc)

	xdif=$(echo "$xsize/$xtiles" | bc -l)

	for x in $(eval echo {0..$(($xtiles-1))}); do
	    xmax=$(echo "$xmin + $xdif" | bc)
	    ymax=${ul[1]}
	    ydif=$(echo "$ysize/$ytiles" | bc -l)

	    for y in $(eval echo {0..$((ytiles-1))}); do
	        ymin=$(echo "$ymax - $ydif" | bc)

	        # Create chunk of source raster
	        $GDAL_TRANSLATE -q \
	            -projwin $xmin $ymax $xmax $ymin \
	            -of GTiff \
	            $raster ${raster%.tif}_${x}_${y}.tif

	        ymax=$ymin
			printf "."
	    done
	    xmin=$xmax
	done
	printf "\n"
	
}


if [ -z $GDAL_INFO ] || [ -z $GDAL_TRANSLATE ]; then
	echo "Install gdal-bin package"
	exit
fi

mkdir -p $BASEDIR/$DATA_DIR/$ORIG_FILES_DIR

DOWNLOAD_URL="https://srtm.csi.cgiar.org/wp-content/uploads/files/250m"
SRTM_FILES="SRTM_NE_250m_TIF.rar SRTM_SE_250m_TIF.rar SRTM_W_250m_TIF.rar"

for u in $SRTM_FILES; do
	urlFile=$DOWNLOAD_URL/$u
	printf "Download $urlFile to $BASEDIR/$DATA_DIR/\n"
	wget $urlFile -P $BASEDIR/$DATA_DIR
done

cd $BASEDIR/$DATA_DIR
for u in $SRTM_FILES; do
	printf "Extract $BASEDIR/$DATA_DIR/$u\n"
	unar -f -D $BASEDIR/$DATA_DIR/$u
 	rm $BASEDIR/$DATA_DIR/$u
done


create_tiles $BASEDIR/$DATA_DIR/SRTM_NE_250m.tif 10 10
rm $BASEDIR/$DATA_DIR/SRTM_NE_250m.tif

create_tiles $BASEDIR/$DATA_DIR/SRTM_SE_250m.tif 10 10
rm $BASEDIR/$DATA_DIR/SRTM_SE_250m.tif

create_tiles $BASEDIR/$DATA_DIR/SRTM_W_250m.tif 10 20
rm $BASEDIR/$DATA_DIR/SRTM_W_250m.tif
rm $BASEDIR/$DATA_DIR/readme.txt



















