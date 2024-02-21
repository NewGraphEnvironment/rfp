#!/bin/bash
set -euxo pipefail


# check that the name of the new directory for the project is provided as argument
if [ $# -eq 0 ]
  then
    echo "No arguments supplied - provide name of new project directory to be placed in ~Projects/gis/"
    exit 1
fi

echo 'Generating QGIS project in Projects/gis/: '$1


# ---------------
# create directory for project and move the files in and copy in a qlr template (works relative to location dragged from when we reference gpkg) along with the directories for info ignored on phones

mkdir ~/Projects/gis/$1
mv background_layers.gpkg* ~/Projects/gis/$1/
mv habitat_lateral.tif ~/Projects/gis/$1/
cp ../../data/qgis/bcfishpass_mobile.qgs ~/Projects/gis/$1/$1.qgs
cp ../../data/qgis/form_pscis.gpkg ~/Projects/gis/$1/
cp ../../data/qgis/form_fiss_site.gpkg ~/Projects/gis/$1/
mkdir -p ~/Projects/gis/$1/ignore_mobile/photos
touch ~/Projects/gis/$1/ignore_mobile/photos/photos.txt
cp -R ../../data/methods ~/Projects/gis/$1/ignore_mobile/methods
cp -R ../../data/templates ~/Projects/gis/$1/ignore_mobile/templates
