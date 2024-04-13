# Author: Alex Dunahoo
# Data: 4/13/2024
# Purpose: This script will count the number of files with a specific file format for all subdirectories within a supplied directory. 

import os,csv
from datetime import datetime

### User Input Needed ###

# Path to the parent directory
parentDirectoryPath = "E:\MRB_MaskedRasters"

# File format of interest. For example ".tif" or ".pdf"
fileFormat = ".asc"

# Path to the desired output directory
outputDirectoryPath = r"\\Mac\Home\Downloads"

#####################-

# Creates output file name with date
outputFile = "FileCounter_" + datetime.now().strftime("%m_%d_%Y") + ".csv"

# Path to output directory
outputFilePath = os.path.join(outputDirectoryPath,outputFile)

# Creates a list of all of the paths to subfolders within parent directory
subFolderPaths = [os.path.join(parentDirectoryPath, folder) for folder in os.listdir(parentDirectoryPath) if not folder.startswith('.')]

# Creates empty data frame to store data
data = []

# For each subfolder, extract folder name and count how many files it contains.
for folderPath in subFolderPaths:

    folderName = os.path.basename(folderPath)

    numberOfFiles = len([file for file in os.listdir(folderPath) if file.endswith(fileFormat)])

    # Appends to data frame
    data.append([folderName, numberOfFiles])

# Write data frame to a csv file in the output directory
with open(outputFilePath, 'w') as csvfile:
    csv_writer = csv.writer(csvfile,lineterminator='\n')
    csv_writer.writerow(['Folder Name', 'Number of Files'])
    csv_writer.writerows(sorted(data))

# Writes message to user
print("Sucessfully Created: " + outputFile)





