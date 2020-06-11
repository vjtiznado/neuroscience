# import sys
from sys import platform


# def_mainpath function will define the mainpath where your data is located,
# based on the os you are running and the project you are working on
def def_mainpath(project):
    if platform in ("linux", "linux2"):
        mainpath = "/home/bmilab/Documents/lab_bmi/" + project + "/data"
    elif platform == "darwin":
        mainpath = "/Users/vjtiznado/Google Drive/lab_bmi/" + project + "/data"
    return mainpath
