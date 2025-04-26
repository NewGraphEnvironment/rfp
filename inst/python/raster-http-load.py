from qgis.core import QgsRasterLayer
from qgis.PyQt.QtCore import QFileInfo

def StringToRaster(raster):
    # Check if string is provided

    fileInfo = QFileInfo(raster)
    path = fileInfo.filePath()
    baseName = fileInfo.baseName()

    layer = QgsRasterLayer(path, baseName)
    QgsProject.instance().addMapLayer(layer)

    if layer.isValid():
        print("Layer was loaded successfully!")
    else:
        print("Unable to read basename and file path - Your string is probably invalid")

project_path = '/Users/airvine/Projects/repo/rfp/inst/extdata/qgis-raw.qgs'
raster_path = '/Volumes/backup_2022/backups/new_graph/archive/uav_imagery/fraser/nechacko/2024/199173_necr_trib_dog/odm_orthophoto/odm_orthophoto.tif'

StringToRaster(raster_path)
