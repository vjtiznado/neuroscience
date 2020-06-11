""" this code reads all the bdf files from every recorded subject
 and save the data as a .mat file
 it is made by using the mne library """

import os
import glob
import mne
import scipy.io as sio
import apoptosis

mainpath = apoptosis.def_mainpath("schizophrenia")

for s in sorted(glob.glob(mainpath + "/splinter*")):
    for r in sorted(glob.glob(s + "/*.bdf")):
        if os.path.isfile(r[:len(r)-3] + "mat"):
            continue

        raw_data = mne.io.read_raw_bdf(r)
        datadic = apoptosis.mne_makedic(raw_data)
        sio.savemat(r[:len(r)-3] + "mat", datadic)

        # wpli = mne.connectivity.spectral_connectivity(data, ['coh', 'wpli'])

print("ready")
