"""
    apoptosis.py is a custom-made library made by Vicente Tiznado.
    it is meant for providing several python functions
    that will help out in your python projects
"""
import sys
import os
import mne


def def_mainpath(project):
    """ def_mainpath function will define the mainpath where your data is located,
    based on the os you are running and the project you are working on """
    if sys.platform in ("linux", "linux2"):
        homedir = "/home/bmilab"
        if project in ("hippocampus", "schizophrenia", "fnirs_maxplanck"):
            mainpath = homedir + "/Documents/lab_bmi/" + project + "/data"
        elif project == "visuals":
            mainpath = homedir + "/Dropbox/python/" + project
    elif sys.platform == "darwin":
        homedir = "/Users/vjtiznado"
        if project in ("hippocampus", "schizophrenia", "fnirs_maxplanck"):
            mainpath = homedir + "/Google Drive/lab_bmi/" + project + "/data"
        elif project == "visuals":
            mainpath = homedir + "/Dropbox/python/" + project
    return mainpath


def addpath(new_path, add_subfolders=False):
    """ this function adds new folder (and its subfolders
    if add_subfolders == True) into your sys.path) """

    if sys.platform in ("linux", "linux2"):
        pth_path = "/home/bmilab/anaconda3/lib/python3.6/site-packages/"
    elif sys.platform == "darwin":
        pth_path = "/Users/vjtiznado/anaconda3/lib/python3.7/site-packages/"

    pth_file = open(pth_path + "my_custom_paths.pth", "a")
    pth_file.write("\n" + new_path + "\n")
    sys.path.append(new_path)

    if add_subfolders:
        for root, subdirs, _ in os.walk(new_path):
            for sdir in subdirs:
                pth_file.write("\n" + root + "/" + sdir + "\n")
                sys.path.append(root + "/" + sdir)

    pth_file.close()


def mne_makedic(raw_data):
    """ this function creates a dictionary with the esential data of
    an eeg recording in order to save these variables as a mat file"""
    datadic = {
        "data": raw_data.get_data(),
        "srate": raw_data.info["sfreq"],
        "ch_names": raw_data.info["ch_names"],
        "events": mne.find_events(raw_data)}
    return datadic
