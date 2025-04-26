from qgis.core import QgsApplication, QgsRasterLayer, QgsProject
import time

# Initialize QGIS
QgsApplication.setPrefixPath("/usr", True)  # Adjust path as needed for your QGIS installation
qgs = QgsApplication([], False)
qgs.initQgis()

# Define helper logging function
def log(message):
    print(f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] {message}")

try:
    # Path to the existing QGIS project
    project_path = "/Users/airvine/Projects/repo/rfp/inst/extdata/qgis-http-raster.qgs"
    log(f"Loading project: {project_path}")

    # Open the QGIS project
    project = QgsProject.instance()
    if not project.read(project_path):
        log(f"Failed to load project: {project_path}")
        raise RuntimeError("Could not load the project file.")

    log("Project loaded successfully.")

    # List of COG URLs
    cog_urls = [
        "https://23cog.s3.amazonaws.com/20210906lampreymoricetribv220230317.tif",
        "http://23cog.s3.amazonaws.com/199174-necr-trib-dog-settlement/odm_orthophoto.tif",
        "http://23cog.s3.amazonaws.com/199173-necr-trib-dog/odm_orthophoto.tif"
    ]

    # Add each raster layer to the project
    for i, cog_url in enumerate(cog_urls, start=1):
        log(f"Attempting to load raster {i}: {cog_url}")
        raster_layer = QgsRasterLayer(cog_url, f"COG Raster Layer {i}")

        if raster_layer.isValid():
            project.addMapLayer(raster_layer)
            log(f"Successfully loaded raster {i}: {cog_url}")
        else:
            log(f"Failed to load raster {i}: {cog_url}")

    # Save the updated project
    log(f"Saving project: {project_path}")
    if not project.write(project_path):
        log(f"Failed to save project: {project_path}")
        raise RuntimeError("Could not save the project file.")
    log("Project saved successfully.")

except Exception as e:
    log(f"An error occurred: {e}")

finally:
    log("Exiting QGIS application.")
    qgs.exitQgis()
